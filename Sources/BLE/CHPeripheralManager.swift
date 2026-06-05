//
//  CHPeripheralManager.swift
//  CHBluetooth
//
//  Created by evan on 2024/7/11.
//

import CoreBluetooth

/// 外设模式
#if !os(watchOS)
final class CHPeripheralManager: NSObject {

    private static let peripheralQueue = DispatchQueue(label: "com.chbluetooth.peripheral", qos: .userInitiated)

    private var peripheralManager: CBPeripheralManager
    private var callback: CHPeripheralCallback?
    private var services: [CBService] = []
    private var addServiceCount = 0

    init(callback: CHPeripheralCallback? = nil) {
        peripheralManager = CBPeripheralManager(delegate: nil, queue: CHPeripheralManager.peripheralQueue, options: nil)
        super.init()
        self.callback = callback
        peripheralManager.delegate = self
    }

    func addService(_ services: [CBMutableService]) {
        self.services = services
        addServiceCount = 0
        for service in services {
            peripheralManager.add(service)
        }
    }

    func startAdvertising(localName: String, manufacturerData: Data? = nil) {
        guard peripheralManager.state == .poweredOn, addServiceCount == services.count else { return }
        let uuids: [CBUUID] = services.map { $0.uuid }
        var advertisementData: [String: Any] = [
            CBAdvertisementDataLocalNameKey: localName,
            CBAdvertisementDataServiceUUIDsKey: uuids
        ]
        if let manufacturerData = manufacturerData {
            advertisementData[CBAdvertisementDataManufacturerDataKey] = manufacturerData
        }
        peripheralManager.startAdvertising(advertisementData)
    }

    func stopAdvertising() {
        peripheralManager.stopAdvertising()
        addServiceCount = 0
        services = []
    }

}

extension CHPeripheralManager: CBPeripheralManagerDelegate {
    
    /// Tells the delegate the peripheral manager's state updated
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        callback?.peripheralDidUpdateStateBlock?(peripheral)
    }
    
    /// Adding Services
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: (any Error)?) {
        addServiceCount += 1
        callback?.peripheralDidAddService?(peripheral, service, error)
    }
    
    /// 开始广播
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: (any Error)?) {
        callback?.peripheralDidStartAdvertising?(peripheral, error)
    }
    
    /// 读请求
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        callback?.peripheralDidReceiveReadRequest?(peripheral, request)
    }
    
    /// 写请求
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        callback?.peripheralDidReceiveWriteRequests?(peripheral, requests)
    }
    
    /// 接收订阅通知
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        callback?.peripheralDidSubscribeToCharacteristic?(peripheral, central, characteristic)
    }
    
    /// 接收订阅取消
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        callback?.peripheralDidUnSubscribeToCharacteristic?(peripheral, central, characteristic)
    }
    
    /// Tells the delegate that a local peripheral device is ready to send characteristic value updates.
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        callback?.peripheralIsReadyToUpdateSubscribers?(peripheral)
    }
    
}
#endif
