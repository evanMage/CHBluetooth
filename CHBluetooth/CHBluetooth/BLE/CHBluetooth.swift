//
//  CHBluetooth.swift
//  CHBluetooth
//
//  Created by evan on 2024/04/15.
//

import Foundation
import CoreBluetooth

/// Swift BLE
public class CHBluetooth {
    
    /// 单例
    static var instance = CHBluetooth()
    
    /// 中心设备
    lazy var central: CHCentralManager = {
        let options = [CBCentralManagerOptionShowPowerAlertKey: true, CBCentralManagerOptionRestoreIdentifierKey: "CHBluetoothRestore"]
        return CHCentralManager(options: options)
    }()
    
    private var callback: CHCallback?
    
    private var options: CHOptions?
    
    required public init() {
        callback = CHCallback()
        central.callback = callback
        options = CHOptions()
        central.options = options
    }
    
    /// 扫描参数配置
    public func optionsConfig(scanOptions: Dictionary<String, Any>? = nil, connectOptions: Dictionary<String, Any>? = nil, scanServices: Array<CBUUID>? = nil, discoverServices: Array<CBUUID>? = nil, discoverCharacteristics: Array<CBUUID>? = nil) -> Void {
        if scanOptions != nil {
            options?.scanForPeripheralsWithOptions = scanOptions
        }
        if connectOptions != nil {
            options?.connectPeripheralWithOptions = connectOptions
        }
        if scanServices != nil {
            options?.scanForPeripheralsWithServices = scanServices
        }
        if discoverServices != nil {
            options?.discoverWithServices = discoverServices
        }
        if discoverCharacteristics != nil {
            options?.discoverWithCharacteristics = discoverCharacteristics
        }
        central.options = options
    }
    
    /// 开始扫描
    public func startScanPeripherals() -> Void {
        central.scanPeripherals(services: options?.scanForPeripheralsWithServices, options: options?.scanForPeripheralsWithOptions)
    }
    
    /// 停止扫描
    /// - Parameter callback: 回调
    public func stopScan(callback: CHCancelScanBlock? = nil) -> Void {
        central.stopScanningPeripherals()
        callback?(central.centralManager)
    }
    /// 开始连接设备
    public func startConnect(_ peripheral: CBPeripheral) -> Void {
        central.startConnect(peripheral)
    }
    /// 断开设备连接
    public func cancelPeripheralConnection(_ peripheral: CBPeripheral) -> Void {
        central.cancelPeripheral(peripheral)
    }
    
    /// 开始发现服务
    public func startDiscoverServices(_ peripheral: CBPeripheral) -> Void {
        central.startDiscoverServices(peripheral)
    }
    
    /// 开始发现特征值
    public func startDiscoverCharacteristic(_ peripheral: CBPeripheral) -> Void {
        central.startDiscoverCharacteristics(peripheral)
    }
    
    /// 读取特征值
    /// - Parameters:
    ///   - peripheral: 外设设备
    ///   - characteristic: 特征值
    public func readValue(_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic) -> Void {
        peripheral.readValue(for: characteristic)
//        peripheral.discoverDescriptors(for: characteristic)
    }
    
    /// 写入特征值
    /// - Parameters:
    ///   - value: 写入内容
    ///   - peripheral: 外设设备
    ///   - characteristic: 特征值
    ///   - type: CBCharacteristicWriteType
    public func writeValue(_ value: Data, _ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, type: CBCharacteristicWriteType = .withResponse) -> Void {
        peripheral.writeValue(value, for: characteristic, type: type)
    }
    
    //MARK: - 回调
    /// central state 发生改变
    public func onStateChange(_ callback: @escaping CHCentralManagerDidUpdateStateBlock) -> Void {
        self.callback?.centralManagerDidUpdateStateBlock = callback
        
    }
    
    /// 扫描发现设备
    public func onDiscoverPeripherals(_ callback: @escaping CHDiscoverPeripheralsBlock) -> Void {
        self.callback?.discoverPeripheralsBlock = callback
    }
    
    /// 连接设备成功
    public func onConnectedPeripheral(_ callback: @escaping CHConnectedPeripheralBlock) -> Void {
        self.callback?.connectedPeripheralBlock = callback
    }
    
    /// 连接设备失败
    public func onFailToConnect(_ callback: @escaping CHFailToConnectBlock) -> Void {
        self.callback?.failToConnectBlock = callback
    }
    /// 断开设备连接
    public func onDisconnect(_ callback: @escaping CHDisconnectBlock) -> Void {
        self.callback?.disconnectBlock = callback
    }
    /// 发现服务委托
    public func onDiscoverServices(_ callback: @escaping CHDiscoverServicesBlock) -> Void {
        self.callback?.discoverServicesBlock = callback
    }
    /// 找到特征委托
    public func onDiscoverCharacteristics(_ callback: @escaping CHDiscoverCharacteristicsBlock) -> Void {
        self.callback?.discoverCharacteristicsBlock = callback
    }
    /// 读取特征值委托
    public func onReadValueForCharacteristic(_ callback: @escaping CHReadValueForCharacteristicBlock) -> Void {
        self.callback?.readValueForCharacteristicBlock = callback
    }
    /// 获取特征值名称
    public func onDiscoverDescriptorsForCharacteristic(_ callback: @escaping CHDiscoverDescriptorsForCharacteristicBlock) -> Void {
        self.callback?.discoverDescriptorsForCharacteristicBlock = callback
    }
    /// 获取Descriptors的值
    public func onReadValueForDescriptors(_ callback: @escaping CHReadValueForDescriptorsBlock) -> Void {
        self.callback?.readValueForDescriptorsBlock = callback
    }
    /// 写入特征值委托
    public func onDidWriteValueForCharacteristic(_ callback: @escaping CHDidWriteValueForCharacteristicBlock) -> Void {
        self.callback?.didWriteValueForCharacteristicBlock = callback
    }
    /// 写入Descriptors
    public func onDidWriteValueForDescriptor(_ callback: @escaping CHDidWriteValueForDescriptorBlock) -> Void {
        self.callback?.didWriteValueForDescriptorBlock = callback
    }
    
    /// characteristic.isNotifying 状态改变
    public func onDidUpdateNotificationStateForCharacteristic(_ callback: @escaping CHDidUpdateNotificationStateForCharacteristicBlock) -> Void {
        self.callback?.didUpdateNotificationStateForCharacteristicBlock = callback
    }
    /// 读取rssi
    public func onDidReadRSSI(_ peripheral: CBPeripheral, _ callback: @escaping CHReadRSSIBlock) -> Void {
        central.readRSSI(peripheral)
        self.callback?.readRSSIBlock = callback
    }
    
    /// 断开所有设备连接
    public func onCancelAllPeripheralsConnection(_ callback: CHCancelPeripheralsConnectionBlock? = nil) -> Void {
        central.cancelAllperipheral()
        self.callback?.cancelPeripheralsConnectionBlock = callback
    }
    
    /// 获取系统连接外设
    public func retrieveConnectedPeripherals() -> Array<CBPeripheral> {
        if central.connectedPeripherals.count == 0, options?.scanForPeripheralsWithServices != nil {
            let connectedPeripherals = central.retrieveConnectedPeripherals((options?.scanForPeripheralsWithServices)!)
            for peripheral in connectedPeripherals {
                cancelPeripheralConnection(peripheral)
            }
            return connectedPeripherals
        }
        return []
    }
    
    /// 监听特征值返回
    /// - Parameters:
    ///   - peripheral: 外设设备
    ///   - characteristic: 特征值
    ///   - callback: 结果回调
    public func notify(_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ callback: @escaping ((_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) -> Void)) -> Void {
        peripheral.setNotifyValue(true, for: characteristic)
        central.notify(characteristic, callback)
    }
    
    /// 移除监听特征值
    /// - Parameters:
    ///   - peripheral: 外设设备
    ///   - characteristic: 特征值
    /// - Returns: 结果回调
    public func removeNotify(_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic) -> Void {
        peripheral.setNotifyValue(false, for: characteristic)
        central.removeNotify(characteristic)
    }
    
}

//MARK: - 扫描参数
public class CHOptions {
    
    /// 扫描设备参数
    public var scanForPeripheralsWithOptions: Dictionary<String, Any>?
    /// 连接设备参数
    public var connectPeripheralWithOptions: Dictionary<String, Any>?
    /// 扫描设备服务参数
    public var scanForPeripheralsWithServices: Array<CBUUID>?
    /// 发现服务参数
    public var discoverWithServices: Array<CBUUID>?
    /// 发现特征值参数
    public var discoverWithCharacteristics: Array<CBUUID>?
    
    init(scanForPeripheralsWithOptions: Dictionary<String, Any>? = nil, connectPeripheralWithOptions: Dictionary<String, Any>? = nil, scanForPeripheralsWithServices: Array<CBUUID>? = nil, discoverWithServices: Array<CBUUID>? = nil, discoverWithCharacteristics: Array<CBUUID>? = nil) {
        self.scanForPeripheralsWithOptions = scanForPeripheralsWithOptions
        self.connectPeripheralWithOptions = connectPeripheralWithOptions
        self.scanForPeripheralsWithServices = scanForPeripheralsWithServices
        self.discoverWithServices = discoverWithServices
        self.discoverWithCharacteristics = discoverWithCharacteristics
    }
    
}
