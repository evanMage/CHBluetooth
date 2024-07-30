//
//  CHPeripheralManager.swift
//  CHBluetooth
//
//  Created by evan on 2024/7/11.
//

import CoreBluetooth

class CHPeripheralManager: NSObject {
    
    private var peripheralManager: CBPeripheralManager!
    
    private var callback: CHCallback?
    
    private var services: Array<CBService> = []
    
    private var addServiceCount = 0
    
    init(callback: CHCallback? = nil) {
        super.init()
        self.callback = callback
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func addService(_ services: Array<CBMutableService>) -> Void {
        self.services = services
        for service in services {
            peripheralManager.add(service)
        }
    }
    
    func startAdvertising(localName: String, uuids: Array<CBUUID>, manufacturerData: Data? = nil) -> Void {
        if peripheralManager.state != .poweredOn, addServiceCount != services.count {
            return
        }
        var uuids: Array<CBUUID> = []
        for service in services {
            uuids.append(service.uuid)
        }
        var advertisementData: Dictionary<String, Any> = [CBAdvertisementDataLocalNameKey: localName, CBAdvertisementDataServiceUUIDsKey: uuids]
        if manufacturerData != nil {
            advertisementData[CBAdvertisementDataManufacturerDataKey] = manufacturerData
        }
        peripheralManager.startAdvertising(advertisementData)
    }
    
    func stopAdvertising() -> Void {
        peripheralManager.stopAdvertising()
    }
    
}

extension CHPeripheralManager: CBPeripheralManagerDelegate {
    
    /// Tells the delegate the peripheral manager’s state updated
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        callback?.peripheralModeDidUpdateStateBlock?(peripheral)
    }
    /// Adding Services
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: (any Error)?) {
        addServiceCount += 1
        callback?.peripheralModeDidAddService?(peripheral, service, error)
    }
    /// 开始广播
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: (any Error)?) {
        callback?.peripheralModeDidStartAdvertising?(peripheral, error)
    }
    /// 读请求
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        callback?.peripheralModeDidReceiveReadRequest?(peripheral, request)
    }
    /// 写请求
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        callback?.peripheralModeDidReceiveWriteRequests?(peripheral, requests)
    }
    /// 接收订阅通知
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        callback?.peripheralModeDidSubscribeToCharacteristic?(peripheral, central, characteristic)
    }
    /// 接收订阅取消
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        callback?.peripheralModeDidUnSubscribeToCharacteristic?(peripheral, central, characteristic)
    }
    /// Tells the delegate that a local peripheral device is ready to send characteristic value updates.
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        callback?.peripheralModeIsReadyToUpdateSubscribers?(peripheral)
    }
    
}
