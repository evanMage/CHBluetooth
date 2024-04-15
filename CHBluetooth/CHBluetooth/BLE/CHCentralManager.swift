//
//  CHCentralManager.swift
//  CHBluetooth
//
//  Created by evan on 2024/04/15.
//

import Foundation
import CoreBluetooth

/// BLE core Centra
class CHCentralManager: NSObject {
    
    internal var centralManager: CBCentralManager!
    internal var scanTimeout = 10
    internal var operationQueue = DispatchQueue(label: "CHQueue", qos: .userInitiated)
    internal var options: CHOptions?
    internal var callback: CHCallback?
    internal var connectedPeripherals: Dictionary<String, CBPeripheral> = Dictionary()
    internal var notifyDcit: Dictionary<String, Any> = Dictionary()
    private lazy var discoverPeripherals: Array<CBPeripheral> = Array()
    
    /// 初始化
    public required init(options: Dictionary<String, Any>? = nil) {
        super.init()
        let backgroundModes: Array<String> = Bundle.main.infoDictionary?["UIBackgroundModes"] as? Array<String> ?? []
        if backgroundModes.contains("bluetooth-central") {
            centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
        } else {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
}

extension CHCentralManager: CBCentralManagerDelegate {
    /// 蓝牙状态变化
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        callback?.centralManagerDidUpdateStateBlock?(central)
    }
    /// 发现外设设备
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        discoverPeripherals.append(peripheral)
        callback?.discoverPeripheralsBlock?(peripheral, advertisementData, RSSI)
    }
    /// 连接外设成功
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripherals[peripheral.identifier.uuidString] = peripheral
        callback?.connectedPeripheralBlock?(peripheral)
    }
    /// 外设连接失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        callback?.failToConnectBlock?(peripheral, error)
    }
    /// 外设设备断开连接
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectedPeripherals.removeValue(forKey: peripheral.identifier.uuidString)
        callback?.disconnectBlock?(peripheral, error)
        if connectedPeripherals.count == 0 {
            callback?.cancelPeripheralsConnectionBlock?(centralManager)
        }
    }
    
    /// 支持后台模式
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        //
    }
    
}

extension CHCentralManager: CBPeripheralDelegate {
    
    /// 扫描到服务
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        callback?.discoverServicesBlock?(peripheral, error)
    }
    /// 发现服务的Characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        callback?.discoverCharacteristicsBlock?(peripheral, service, error)
    }
    /// 读取Characteristics的值
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if notifyDcit[characteristic.uuid.uuidString] != nil {
            guard let notifyBlock = notifyDcit[characteristic.uuid.uuidString] as? ((_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) -> Void) else {
                return
            }
            debugPrint("iOS 特征值监听返回  ------------ \(characteristic.uuid.uuidString)")
            notifyBlock(peripheral, characteristic, error)
//            return
        }
        debugPrint("iOS 读取成功  ------------ \(characteristic.uuid.uuidString)")
        callback?.readValueForCharacteristicBlock?(peripheral, characteristic, error)
    }
    /// 发现Characteristics的Descriptors
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        callback?.discoverDescriptorsForCharacteristicBlock?(peripheral, characteristic, error)
    }
    /// 读取Characteristics的Descriptors的值
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        callback?.readValueForDescriptorsBlock?(peripheral, descriptor, error)
    }
    /// 写Characteristic成功
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        callback?.didWriteValueForCharacteristicBlock?(peripheral, characteristic, error)
    }
    /// 写Characteristic的descriptor成功
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        callback?.didWriteValueForDescriptorBlock?(descriptor, error)
    }
    /// characteristic.isNotifying 状态改变
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        callback?.didUpdateNotificationStateForCharacteristicBlock?(characteristic, error)
    }
    /// 读取readRSSI
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        callback?.readRSSIBlock?(RSSI, error)
    }
    
}

extension CHCentralManager {
    
    /// 开始扫描设备
    public func scanPeripherals(services: [CBUUID]? = nil, options: [String : Any]? = nil) -> Void {
        guard centralManager.state == .poweredOn else {
            return
        }
        discoverPeripherals.removeAll()
        centralManager.scanForPeripherals(withServices: services, options: options)
    }
    
    /// 获取系统连接的蓝牙设备
    public func retrieveConnectedPeripherals(_ services: [CBUUID]) -> Array<CBPeripheral> {
        return centralManager.retrieveConnectedPeripherals(withServices: services)
    }
    
    /// 停止扫描设备
    public func stopScanningPeripherals() -> Void {
        centralManager.stopScan()
    }
    
    /// 开始连接设备
    public func startConnect(_ peripheral: CBPeripheral) -> Void {
        centralManager.connect(peripheral, options: options?.connectPeripheralWithOptions)
    }
    /// 断开连接设备
    public func cancelPeripheral(_ peripheral: CBPeripheral) -> Void {
        centralManager.cancelPeripheralConnection(peripheral)
    }
    /// 断开所有连接的设备
    public func cancelAllperipheral() -> Void {
        for peripheral in connectedPeripherals.values {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    /// 开始发现服务
    public func startDiscoverServices(_ peripheral: CBPeripheral) -> Void {
        peripheral.delegate = self
        peripheral.discoverServices(options?.discoverWithServices)
    }
    
    /// 发现特征值
    public func startDiscoverCharacteristics(_ peripheral: CBPeripheral) {
        guard let services = peripheral.services else {
            return
        }
        for service in services {
            peripheral.discoverCharacteristics(options?.discoverWithCharacteristics, for: service)
        }
    }
    
    /// 读取RSSI
    public func readRSSI(_ peripheral: CBPeripheral) -> Void {
        peripheral.delegate = self
        peripheral.readRSSI()
    }
    
    /// 监听
    public func notify(_ characteristic: CBCharacteristic, _ block: @escaping ((_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) -> Void)) -> Void {
        notifyDcit.updateValue(block, forKey: characteristic.uuid.uuidString)
    }
    
    public func removeNotify(_ characteristic: CBCharacteristic) -> Void {
        notifyDcit.removeValue(forKey: characteristic.uuid.uuidString)
    }
    
}
