//
//  CHDefinitions.swift
//  CHBluetooth
//
//  Created by evan on 2023/8/4.
//

import Foundation
import CoreBluetooth

/// 设备状态改变委托
public typealias CHCentralManagerDidUpdateStateBlock = ((_ central: CBCentralManager) -> Void)
/// 找到设备委托
public typealias CHDiscoverPeripheralsBlock = ((_ peripheral: CBPeripheral, _ advertisementData: [String : Any], _ rssi: NSNumber) -> Void)
/// 连接设备成功委托
public typealias CHConnectedPeripheralBlock = ((_ peripheral: CBPeripheral) -> Void)
/// 连接设备失败委托
public typealias CHFailToConnectBlock = ((_ peripheral: CBPeripheral, _ error: Error?) -> Void)
/// 断开设备连接委托
public typealias CHDisconnectBlock = ((_ peripheral: CBPeripheral, _ error: Error?) -> Void)
/// 找到服务委托
public typealias CHDiscoverServicesBlock = ((_ peripheral: CBPeripheral, _ error: Error?) -> Void)
/// 找到特征委托
public typealias CHDiscoverCharacteristicsBlock = ((_ peripheral: CBPeripheral, _ service: CBService, _ error: Error?) -> Void)
/// 读取特征值委托
public typealias CHReadValueForCharacteristicBlock = ((_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) -> Void)
/// 获取特征值名称
public typealias CHDiscoverDescriptorsForCharacteristicBlock = ((_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) -> Void)
/// 获取Descriptors的值
public typealias CHReadValueForDescriptorsBlock = ((_ peripheral: CBPeripheral, _ descriptor: CBDescriptor, _ error: Error?) -> Void)
/// 写入特征值委托
public typealias CHDidWriteValueForCharacteristicBlock = ((_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) -> Void)
/// 写入Descriptors
public typealias CHDidWriteValueForDescriptorBlock = ((_ descriptor: CBDescriptor, _ error: Error?) -> Void)
/// 监听特征值返回
public typealias CHDidUpdateNotificationStateForCharacteristicBlock = ((_ characteristic: CBCharacteristic, _ error: Error?) -> Void)
/// 读取rssi值
public typealias CHReadRSSIBlock = ((_ rssi: NSNumber, _ error: Error?) -> Void)
/// 停止扫描委托
public typealias CHCancelScanBlock = ((_ centralManager: CBCentralManager) -> Void)
/// 断开所有连接设备回调
public typealias CHCancelPeripheralsConnectionBlock = ((_ centralManager: CBCentralManager) -> Void)

public class CHCallback: NSObject {
    
    var centralManagerDidUpdateStateBlock: CHCentralManagerDidUpdateStateBlock?
    
    var discoverPeripheralsBlock: CHDiscoverPeripheralsBlock?
    
    var connectedPeripheralBlock: CHConnectedPeripheralBlock?
    
    var failToConnectBlock: CHFailToConnectBlock?
    
    var disconnectBlock: CHDisconnectBlock?
    
    var discoverServicesBlock: CHDiscoverServicesBlock?
    
    var discoverCharacteristicsBlock: CHDiscoverCharacteristicsBlock?
    
    var readValueForCharacteristicBlock: CHReadValueForCharacteristicBlock?
    
    var discoverDescriptorsForCharacteristicBlock: CHDiscoverDescriptorsForCharacteristicBlock?
    
    var readValueForDescriptorsBlock: CHReadValueForDescriptorsBlock?
    
    var didWriteValueForCharacteristicBlock: CHDidWriteValueForCharacteristicBlock?
    
    var didWriteValueForDescriptorBlock: CHDidWriteValueForDescriptorBlock?
    
    var didUpdateNotificationStateForCharacteristicBlock: CHDidUpdateNotificationStateForCharacteristicBlock?
    
    var readRSSIBlock: CHReadRSSIBlock?
    
    var cancelScanBlock: CHCancelScanBlock?
    
    var cancelPeripheralsConnectionBlock: CHCancelPeripheralsConnectionBlock?
    
    init(centralManagerDidUpdateStateBlock: CHCentralManagerDidUpdateStateBlock? = nil, discoverPeripheralsBlock: CHDiscoverPeripheralsBlock? = nil, connectedPeripheralBlock: CHConnectedPeripheralBlock? = nil, failToConnectBlock: CHFailToConnectBlock? = nil, disconnectBlock: CHDisconnectBlock? = nil, discoverServicesBlock: CHDiscoverServicesBlock? = nil, discoverCharacteristicsBlock: CHDiscoverCharacteristicsBlock? = nil, readValueForCharacteristicBlock: CHReadValueForCharacteristicBlock? = nil, discoverDescriptorsForCharacteristicBlock: CHDiscoverDescriptorsForCharacteristicBlock? = nil, readValueForDescriptorsBlock: CHReadValueForDescriptorsBlock? = nil, didWriteValueForCharacteristicBlock: CHDidWriteValueForCharacteristicBlock? = nil, didWriteValueForDescriptorBlock: CHDidWriteValueForDescriptorBlock? = nil, didUpdateNotificationStateForCharacteristicBlock: CHDidUpdateNotificationStateForCharacteristicBlock? = nil, readRSSIBlock: CHReadRSSIBlock? = nil, cancelScanBlock: CHCancelScanBlock? = nil, cancelPeripheralsConnectionBlock: CHCancelPeripheralsConnectionBlock? = nil) {
        self.centralManagerDidUpdateStateBlock = centralManagerDidUpdateStateBlock
        self.discoverPeripheralsBlock = discoverPeripheralsBlock
        self.connectedPeripheralBlock = connectedPeripheralBlock
        self.failToConnectBlock = failToConnectBlock
        self.disconnectBlock = disconnectBlock
        self.discoverServicesBlock = discoverServicesBlock
        self.discoverCharacteristicsBlock = discoverCharacteristicsBlock
        self.readValueForCharacteristicBlock = readValueForCharacteristicBlock
        self.discoverDescriptorsForCharacteristicBlock = discoverDescriptorsForCharacteristicBlock
        self.readValueForDescriptorsBlock = readValueForDescriptorsBlock
        self.didWriteValueForCharacteristicBlock = didWriteValueForCharacteristicBlock
        self.didWriteValueForDescriptorBlock = didWriteValueForDescriptorBlock
        self.didUpdateNotificationStateForCharacteristicBlock = didUpdateNotificationStateForCharacteristicBlock
        self.readRSSIBlock = readRSSIBlock
        self.cancelScanBlock = cancelScanBlock
        self.cancelPeripheralsConnectionBlock = cancelPeripheralsConnectionBlock
    }
    
}
