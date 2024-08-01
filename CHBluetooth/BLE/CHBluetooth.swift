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
    static let sharedBluetooth = CHBluetooth()
    
    /// 中心设备
    lazy private var central: CHCentralManager = {
        let options = [CBCentralManagerOptionShowPowerAlertKey: true, CBCentralManagerOptionRestoreIdentifierKey: "CHBluetoothRestore"]
        let central = CHCentralManager(options: options)
        central.callback = callback
        return central
    }()
    
    /// 外设模式
    private var peripheral: CHPeripheralManager?
    
    private var callback: CHCallback? = CHCallback()
    
    private var options: CHOptions? = CHOptions()
}

//MARK: - 中心设备
extension CHBluetooth {
    /// 扫描参数配置
    public func optionsConfig(scanOptions: Dictionary<String, Any>? = nil, connectOptions: Dictionary<String, Any>? = nil, scanServices: Array<CBUUID>? = nil, discoverServices: Array<CBUUID>? = nil, discoverCharacteristics: Array<CBUUID>? = nil) -> Void {
        options?.scanForPeripheralsWithOptions = scanOptions
        options?.connectPeripheralWithOptions = connectOptions
        options?.scanForPeripheralsWithServices = scanServices
        options?.discoverWithServices = discoverServices
        options?.discoverWithCharacteristics = discoverCharacteristics
        central.options = options
    }
    
    /// 获取系统正在连接外设
    public func retrieveConnectedPeripherals() -> Array<CBPeripheral>? {
        if options?.scanForPeripheralsWithServices != nil {
            return central.retrieveConnectedPeripherals((options?.scanForPeripheralsWithServices)!)
        }
        return nil
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
    ///   - peripheral: 外设设备
    ///   - value: 写入内容
    ///   - characteristic: 特征值
    ///   - type: CBCharacteristicWriteType
    public func writeValue(_ peripheral: CBPeripheral, _ value: Data, _ characteristic: CBCharacteristic, type: CBCharacteristicWriteType = .withResponse) -> Void {
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

//MARK: - 外设模式
extension CHBluetooth {
    
    /// 生成特征值
    public func makeCharacteristic(characteristicUUID: CBUUID, properties: CBCharacteristicProperties = [.read, .write, .notify], permissions: CBAttributePermissions = [.readable, .writeable], value: Data? = nil) -> CBMutableCharacteristic {
        return CBMutableCharacteristic(type: characteristicUUID, properties: properties, value: value, permissions: permissions)
    }
    /// 生成服务
    public func makeService(uuid: String, characteristics: Array<CBCharacteristic>) -> CBMutableService {
        let service = CBMutableService(type: CBUUID(string: uuid), primary: true)
        service.characteristics = characteristics
        return service
    }
    /// 添加服务
    public func addService(services: Array<CBMutableService>) -> Void {
        peripheral?.addService(services)
    }
    
    public func startPeripheralManager() -> Void {
        let peripheral = CHPeripheralManager(callback: callback)
        self.peripheral = peripheral
    }
    
    /// 开始广播
    public func startAdvertising(localName: String, serverUuids: Array<CBUUID>, manufacturerData: Data? = nil) -> Void {
        if serverUuids.isEmpty {
            return
        }
        peripheral?.startAdvertising(localName: localName, uuids: serverUuids, manufacturerData: manufacturerData)
    }
    /// 停止广播
    public func stopAdvertising() -> Void {
        peripheral?.stopAdvertising()
    }
    
    public func peripheralModeDidUpdateState(_ callback: @escaping CHPeripheralModeDidUpdateStateBlock) -> Void {
        self.callback?.peripheralModeDidUpdateStateBlock = callback
    }
    
    /// 增加service
    /// - Parameter callback: CHPeripheralModeDidAddService
    public func peripheralModeDidAddService(_ callback: @escaping CHPeripheralModeDidAddService) -> Void {
        self.callback?.peripheralModeDidAddService = callback
    }
    
    /// 开始广播
    /// - Parameter callback: CHPeripheralModeDidStartAdvertising
    public func peripheralModeDidStartAdvertising(_ callback: @escaping CHPeripheralModeDidStartAdvertising) -> Void {
        self.callback?.peripheralModeDidStartAdvertising = callback
    }
    
    /// 读取请求
    /// - Parameter callback: CHPeripheralModeDidReceiveReadRequest
    public func peripheralModeDidReceiveReadRequest(_ callback: @escaping CHPeripheralModeDidReceiveReadRequest) -> Void {
        self.callback?.peripheralModeDidReceiveReadRequest = callback
    }
    
    /// 写入请求
    /// - Parameter callback: CHPeripheralModeDidReceiveWriteRequests
    public func peripheralModeDidReceiveWriteRequests(_ callback: @escaping CHPeripheralModeDidReceiveWriteRequests) -> Void {
        self.callback?.peripheralModeDidReceiveWriteRequests = callback
    }
    
    /// 接收订阅通知
    /// - Parameter callback: CHPeripheralModeIsReadyToUpdateSubscribers
    public func peripheralModeIsReadyToUpdateSubscribers(_ callback: @escaping CHPeripheralModeIsReadyToUpdateSubscribers) -> Void {
        self.callback?.peripheralModeIsReadyToUpdateSubscribers = callback
    }
    
    /// 取消订阅通知
    /// - Parameter callback: CHPeripheralModeDidSubscribeToCharacteristic
    public func peripheralModeDidSubscribeToCharacteristic(_ callback: @escaping CHPeripheralModeDidSubscribeToCharacteristic) -> Void {
        self.callback?.peripheralModeDidSubscribeToCharacteristic = callback
    }
    
    /// 更新特征值
    /// - Parameter callback: CHPeripheralModeDidUnSubscribeToCharacteristic
    public func peripheralModeDidUnSubscribeToCharacteristic(_ callback: @escaping CHPeripheralModeDidUnSubscribeToCharacteristic) -> Void {
        self.callback?.peripheralModeDidUnSubscribeToCharacteristic = callback
    }
}
