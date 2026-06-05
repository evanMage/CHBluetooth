//
//  CHBluetooth.swift
//  CHBluetooth
//
//  Created by evan on 2024/04/15.
//

import Foundation
import CoreBluetooth

/// Swift BLE
public final class CHBluetooth: @unchecked Sendable {
    
    /// 单例
    public static let shared = CHBluetooth()
    
    /// 中心设备
    private lazy var central: CHCentralManager = {
        let initOptions: [String: Any] = [
            CBCentralManagerOptionShowPowerAlertKey: true,
            CBCentralManagerOptionRestoreIdentifierKey: "com.evan.restore"
        ]
        let central = CHCentralManager(options: initOptions)
        central.callback = centralCallback
        return central
    }()
    
#if !os(watchOS)
    /// 外设模式
    private var peripheral: CHPeripheralManager?
    /// 外设回调
    private var peripheralCallback: CHPeripheralCallback?
#endif
    
    private let centralCallback = CHCentralCallback()
    private var options = CHOptions()
}

// MARK: - 中心设备
extension CHBluetooth {
    
    /// 扫描参数配置
    public func optionsConfig(scanOptions: [String: Any]? = nil, connectOptions: [String: Any]? = nil, scanServices: [CBUUID]? = nil, discoverServices: [CBUUID]? = nil, discoverCharacteristics: [CBUUID]? = nil) {
        options.scanForPeripheralsWithOptions = scanOptions
        options.connectPeripheralWithOptions = connectOptions
        options.scanForPeripheralsWithServices = scanServices
        options.discoverWithServices = discoverServices
        options.discoverWithCharacteristics = discoverCharacteristics
        central.options = options
    }
    
    /// 获取系统正在连接外设
    public func retrieveConnectedPeripherals(scanServices: [CBUUID]? = nil) -> [CBPeripheral]? {
        if let scanServices {
            return central.retrieveConnectedPeripherals(scanServices)
        }
        if let services = options.scanForPeripheralsWithServices {
            return central.retrieveConnectedPeripherals(services)
        }
        return nil
    }
    
    /// 获取已知外设的蓝牙设备
    public func retrievePeripherals(identifiers: [UUID]) -> [CBPeripheral] {
        central.retrievePeripherals(identifiers: identifiers)
    }
    
    /// 开始扫描
    /// - Parameters:
    ///   - scanServices: ！= nil 会重设扫描Services
    ///   - scanOptions: ！= nil 会重设扫描Options
    public func startScanPeripherals(scanServices: [CBUUID]? = nil, scanOptions: [String: Any]? = nil) {
        if let scanServices {
            options.scanForPeripheralsWithServices = scanServices
        }
        if let scanOptions {
            options.scanForPeripheralsWithOptions = scanOptions
        }
        central.scanPeripherals(services: options.scanForPeripheralsWithServices, options: options.scanForPeripheralsWithOptions)
    }
    
    /// 停止扫描
    public func stopScan(callback: (() -> Void)? = nil) {
        central.stopScanningPeripherals()
        callback?()
    }
    
    /// 开始连接设备
    /// - Parameters:
    ///   - connectOptions: ！= nil 时options会被重设
    public func startConnect(_ peripheral: CBPeripheral, connectOptions: [String: Any]? = nil) {
        if let connectOptions { options.connectPeripheralWithOptions = connectOptions }
        central.startConnect(peripheral)
    }
    
    /// 断开设备连接
    public func cancelPeripheralConnection(_ peripheral: CBPeripheral) {
        central.cancelPeripheral(peripheral)
    }
    
    /// 开始发现服务
    public func startDiscoverServices(_ peripheral: CBPeripheral) {
        central.startDiscoverServices(peripheral)
    }
    
    /// 开始发现特征值
    public func startDiscoverCharacteristic(_ peripheral: CBPeripheral) {
        central.startDiscoverCharacteristics(peripheral)
    }
    
    /// 读取特征值
    public func readValue(_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic) {
        peripheral.readValue(for: characteristic)
    }
    
    /// 写入特征值
    public func writeValue(_ peripheral: CBPeripheral, _ value: Data, _ characteristic: CBCharacteristic, type: CBCharacteristicWriteType = .withResponse) {
        peripheral.writeValue(value, for: characteristic, type: type)
    }
}

// MARK: - 中心模式回调
extension CHBluetooth {
    
    /// central state 发生改变
    public func onStateChange(_ callback: @escaping CHCentralManagerBlock) {
        centralCallback.centralManagerDidUpdateStateBlock = callback
    }
    
    /// 扫描发现设备
    public func onDiscoverPeripherals(_ callback: @escaping CHDiscoverPeripheralsBlock) {
        centralCallback.discoverPeripheralsBlock = callback
    }
    
    /// 连接设备成功
    public func onConnectedPeripheral(_ callback: @escaping CHConnectedPeripheralBlock) {
        centralCallback.connectedPeripheralBlock = callback
    }
    
    /// 连接设备失败
    public func onFailToConnect(_ callback: @escaping CHPeripheralInfoBlock) {
        centralCallback.failToConnectBlock = callback
    }
    
    /// 断开设备连接
    public func onDisconnect(_ callback: @escaping CHPeripheralInfoBlock) {
        centralCallback.disconnectBlock = callback
    }
    
    /// 发现服务委托
    public func onDiscoverServices(_ callback: @escaping CHPeripheralInfoBlock) {
        centralCallback.discoverServicesBlock = callback
    }
    
    /// 找到特征委托
    public func onDiscoverCharacteristics(_ callback: @escaping CHDiscoverCharacteristicsBlock) {
        centralCallback.discoverCharacteristicsBlock = callback
    }
    
    /// 读取特征值委托
    public func onReadValueForCharacteristic(_ callback: @escaping CHCharacteristicInfoBlock) {
        centralCallback.readValueForCharacteristicBlock = callback
    }
    
    /// 获取特征值名称
    public func onDiscoverDescriptorsForCharacteristic(_ callback: @escaping CHCharacteristicInfoBlock) {
        centralCallback.discoverDescriptorsForCharacteristicBlock = callback
    }
    
    /// 获取Descriptors的值
    public func onReadValueForDescriptors(_ callback: @escaping CHReadValueForDescriptorsBlock) {
        centralCallback.readValueForDescriptorsBlock = callback
    }
    
    /// 写入特征值委托
    public func onDidWriteValueForCharacteristic(_ callback: @escaping CHCharacteristicInfoBlock) {
        centralCallback.didWriteValueForCharacteristicBlock = callback
    }
    
    /// 写入Descriptors
    public func onDidWriteValueForDescriptor(_ callback: @escaping CHDidWriteValueForDescriptorBlock) {
        centralCallback.didWriteValueForDescriptorBlock = callback
    }
    
    /// characteristic.isNotifying 状态改变
    public func onDidUpdateNotificationStateForCharacteristic(_ callback: @escaping CHDidUpdateNotificationStateForCharacteristicBlock) {
        centralCallback.didUpdateNotificationStateForCharacteristicBlock = callback
    }
    
    /// 读取 RSSI
    public func onDidReadRSSI(_ peripheral: CBPeripheral, _ callback: @escaping CHReadRSSIBlock) {
        central.readRSSI(peripheral)
        centralCallback.readRSSIBlock = callback
    }
    
    /// 断开所有设备连接
    public func onCancelAllPeripheralsConnection(_ callback: CHCentralManagerBlock? = nil) {
        // 先设置回调再断开，避免竞态条件
        centralCallback.cancelPeripheralsConnectionBlock = callback
        central.cancelAllPeripherals()
    }
    
    /// 监听特征值返回
    public func notify(_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ callback: @escaping CHCharacteristicInfoBlock) {
        guard !characteristic.isNotifying else {
            // 已在监听中，直接更新回调
            central.notify(peripheral, characteristic, callback)
            return
        }
        peripheral.setNotifyValue(true, for: characteristic)
        central.notify(peripheral, characteristic, callback)
    }
    
    /// 移除监听特征值
    public func removeNotify(_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic) {
        peripheral.setNotifyValue(false, for: characteristic)
        central.removeNotify(peripheral, characteristic)
    }
    
}

#if !os(watchOS)
// MARK: - 外设模式
extension CHBluetooth {
    
    /// 生成特征值
    public func makeCharacteristic( characteristicUUID: CBUUID, properties: CBCharacteristicProperties = [.read, .write, .notify], permissions: CBAttributePermissions = [.readable, .writeable], value: Data? = nil) -> CBMutableCharacteristic {
        CBMutableCharacteristic(type: characteristicUUID, properties: properties, value: value, permissions: permissions)
    }
    
    /// 生成服务
    public func makeService(uuid: String, characteristics: [CBCharacteristic]) -> CBMutableService {
        let service = CBMutableService(type: CBUUID(string: uuid), primary: true)
        service.characteristics = characteristics
        return service
    }
    
    /// 添加服务
    public func addService(services: [CBMutableService]) {
        peripheral?.addService(services)
    }
    
    /// 启动外设管理器
    public func startPeripheralManager() {
        let callback = CHPeripheralCallback()
        peripheralCallback = callback
        peripheral = CHPeripheralManager(callback: callback)
    }
    
    /// 开始广播
    public func startAdvertising(localName: String, manufacturerData: Data? = nil) {
        peripheral?.startAdvertising(localName: localName, manufacturerData: manufacturerData)
    }
    
    /// 停止广播
    public func stopAdvertising() {
        peripheral?.stopAdvertising()
    }
    
    /// 外设状态更新
    public func peripheralDidUpdateState(_ callback: @escaping CHPeripheralDidUpdateStateBlock) {
        peripheralCallback?.peripheralDidUpdateStateBlock = callback
    }
    
    /// 增加service
    public func peripheralDidAddService(_ callback: @escaping CHPeripheralDidAddService) {
        peripheralCallback?.peripheralDidAddService = callback
    }
    
    /// 开始广播回调
    public func peripheralDidStartAdvertising(_ callback: @escaping CHPeripheralDidStartAdvertising) {
        peripheralCallback?.peripheralDidStartAdvertising = callback
    }
    
    /// 读取请求
    public func peripheralDidReceiveReadRequest(_ callback: @escaping CHPeripheralDidReceiveReadRequest) {
        peripheralCallback?.peripheralDidReceiveReadRequest = callback
    }
    
    /// 写入请求
    public func peripheralDidReceiveWriteRequests(_ callback: @escaping CHPeripheralDidReceiveWriteRequests) {
        peripheralCallback?.peripheralDidReceiveWriteRequests = callback
    }
    
    /// 接收订阅通知
    public func peripheralIsReadyToUpdateSubscribers(_ callback: @escaping CHPeripheralIsReadyToUpdateSubscribers) {
        peripheralCallback?.peripheralIsReadyToUpdateSubscribers = callback
    }
    
    /// 订阅特征值
    public func peripheralDidSubscribeToCharacteristic(_ callback: @escaping CHPeripheralCharacteristicBlock) {
        peripheralCallback?.peripheralDidSubscribeToCharacteristic = callback
    }
    
    /// 取消订阅特征值
    public func peripheralDidUnSubscribeToCharacteristic(_ callback: @escaping CHPeripheralCharacteristicBlock) {
        peripheralCallback?.peripheralDidUnSubscribeToCharacteristic = callback
    }
}
#endif
