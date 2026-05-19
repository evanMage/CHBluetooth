//
//  CHCentralManager.swift
//  CHBluetooth
//
//  Created by evan on 2024/04/15.
//

import Foundation
import CoreBluetooth

/// BLE core Central
class CHCentralManager: NSObject {
    
    internal var centralManager: CBCentralManager?
    internal var options: CHOptions?
    internal var callback: CHCallback?
    internal var connectedPeripherals: [String : CBPeripheral] = [:]
    internal var notifyDict: [String: CHCharacteristicInfoBlock] = [:]
    private lazy var discoverPeripherals: [UUID: CBPeripheral] = [:]
    
    /// 初始化
    required init(options: Dictionary<String, Any>? = nil) {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue(label: "com.chbluetooth.central", qos: .userInitiated), options: options)
    }
    
}

extension CHCentralManager: CBCentralManagerDelegate {
    /// 蓝牙状态变化
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        callback?.centralManagerDidUpdateStateBlock?(central)
    }
    /// 发现外设设备
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        discoverPeripherals[peripheral.identifier] = peripheral
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
            callback?.cancelPeripheralsConnectionBlock?(central)
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
        let key = notifyKey(peripheral: peripheral, characteristic: characteristic)
        if let notifyBlock = notifyDict[key] {
            notifyBlock(peripheral, characteristic, error)
        }
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
    func scanPeripherals(services: [CBUUID]? = nil, options: [String : Any]? = nil) -> Void {
        guard centralManager?.state == .poweredOn else {
            return
        }
        discoverPeripherals.removeAll()
        centralManager?.scanForPeripherals(withServices: services, options: options)
    }
    
    /// 获取系统连接的蓝牙设备
    func retrieveConnectedPeripherals(_ services: [CBUUID]) -> Array<CBPeripheral> {
        return centralManager?.retrieveConnectedPeripherals(withServices: services) ?? []
    }
    
    /// 获取已知外设的蓝牙设备
    func retrievePeripherals(identifiers: [UUID]) -> Array<CBPeripheral> {
        return centralManager?.retrievePeripherals(withIdentifiers: identifiers) ?? []
    }
    
    /// 停止扫描设备
    func stopScanningPeripherals() -> Void {
        centralManager?.stopScan()
    }
    
    /// 开始连接设备
    func startConnect(_ peripheral: CBPeripheral) -> Void {
        centralManager?.connect(peripheral, options: options?.connectPeripheralWithOptions)
    }
    /// 断开连接设备
    func cancelPeripheral(_ peripheral: CBPeripheral) -> Void {
        centralManager?.cancelPeripheralConnection(peripheral)
    }
    /// 断开所有连接的设备
    func cancelAllperipheral() -> Void {
        for peripheral in connectedPeripherals.values {
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    /// 开始发现服务
    func startDiscoverServices(_ peripheral: CBPeripheral) -> Void {
        peripheral.delegate = self
        peripheral.discoverServices(options?.discoverWithServices)
    }
    
    /// 发现特征值
    func startDiscoverCharacteristics(_ peripheral: CBPeripheral) {
        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics(options?.discoverWithCharacteristics, for: service)
        }
    }
    
    /// 读取RSSI
    func readRSSI(_ peripheral: CBPeripheral) -> Void {
        peripheral.delegate = self
        peripheral.readRSSI()
    }
    
    /// 监听
    func notify(_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ block: @escaping CHCharacteristicInfoBlock) -> Void {
        let key = notifyKey(peripheral: peripheral, characteristic: characteristic)
        notifyDict.updateValue(block, forKey: key)
    }
    
    func removeNotify(_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic) -> Void {
        let key = notifyKey(peripheral: peripheral, characteristic: characteristic)
        notifyDict.removeValue(forKey: key)
    }
    
    
    private func notifyKey(peripheral: CBPeripheral, characteristic: CBCharacteristic) -> String {
        return [peripheral.identifier.uuidString, characteristic.service?.uuid.uuidString ?? "", characteristic.uuid.uuidString].joined(separator: "_")
    }
}

//MARK: - 中心模式扫描参数
class CHOptions {
    /// 扫描设备参数
    var scanForPeripheralsWithOptions: Dictionary<String, Any>? = nil
    /// 连接设备参数
    var connectPeripheralWithOptions: Dictionary<String, Any>? = nil
    /// 扫描设备服务参数
    var scanForPeripheralsWithServices: Array<CBUUID>? = nil
    /// 发现服务参数
    var discoverWithServices: Array<CBUUID>? = nil
    /// 发现特征值参数
    var discoverWithCharacteristics: Array<CBUUID>? = nil
    
}
