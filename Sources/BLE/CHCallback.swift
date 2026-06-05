//
//  CHCallback.swift
//  CHBluetooth
//
//  Created by evan on 2024/04/15.
//

import Foundation
import CoreBluetooth

/// 设备状态改变委托 停止扫描委托 断开所有连接设备回调
public typealias CHCentralManagerBlock = (CBCentralManager) -> Void
/// 找到设备委托
public typealias CHDiscoverPeripheralsBlock = (CBPeripheral, [String : Any], NSNumber) -> Void
/// 连接设备成功委托
public typealias CHConnectedPeripheralBlock = (CBPeripheral) -> Void
/// 找到服务委托、断开设备连接委托、连接设备失败委托
public typealias CHPeripheralInfoBlock = (CBPeripheral, Error?) -> Void
/// 找到特征委托
public typealias CHDiscoverCharacteristicsBlock = (CBPeripheral, CBService, Error?) -> Void
/// 读取特征值委托  写入特征值委托 获取特征值名称
public typealias CHCharacteristicInfoBlock = (CBPeripheral, CBCharacteristic, Error?) -> Void
/// 获取Descriptors的值
public typealias CHReadValueForDescriptorsBlock = (CBPeripheral, CBDescriptor, Error?) -> Void
/// 写入Descriptors
public typealias CHDidWriteValueForDescriptorBlock = (CBDescriptor, Error?) -> Void
/// 监听特征值返回
public typealias CHDidUpdateNotificationStateForCharacteristicBlock = (CBCharacteristic, Error?) -> Void
/// 读取rssi值
public typealias CHReadRSSIBlock = (NSNumber, Error?) -> Void

#if !os(watchOS)
/// 外设状态关闭委托
public typealias CHPeripheralDidUpdateStateBlock = (CBPeripheralManager) -> Void
/// 添加服务委托
public typealias CHPeripheralDidAddService = (CBPeripheralManager, CBService, Error?) -> Void
public typealias CHPeripheralDidStartAdvertising = (CBPeripheralManager, Error?) -> Void
public typealias CHPeripheralDidReceiveReadRequest = (CBPeripheralManager, CBATTRequest) -> Void
public typealias CHPeripheralDidReceiveWriteRequests = (CBPeripheralManager, [CBATTRequest]) -> Void
public typealias CHPeripheralIsReadyToUpdateSubscribers = (CBPeripheralManager) -> Void
public typealias CHPeripheralCharacteristicBlock = (CBPeripheralManager, CBCentral, CBCharacteristic) -> Void
#endif

// MARK: - 中心模式回调
final class CHCentralCallback {
    var centralManagerDidUpdateStateBlock: CHCentralManagerBlock?
    var discoverPeripheralsBlock: CHDiscoverPeripheralsBlock?
    var connectedPeripheralBlock: CHConnectedPeripheralBlock?
    var failToConnectBlock: CHPeripheralInfoBlock?
    var disconnectBlock: CHPeripheralInfoBlock?
    var discoverServicesBlock: CHPeripheralInfoBlock?
    var discoverCharacteristicsBlock: CHDiscoverCharacteristicsBlock?
    var readValueForCharacteristicBlock: CHCharacteristicInfoBlock?
    var discoverDescriptorsForCharacteristicBlock: CHCharacteristicInfoBlock?
    var readValueForDescriptorsBlock: CHReadValueForDescriptorsBlock?
    var didWriteValueForCharacteristicBlock: CHCharacteristicInfoBlock?
    var didWriteValueForDescriptorBlock: CHDidWriteValueForDescriptorBlock?
    var didUpdateNotificationStateForCharacteristicBlock: CHDidUpdateNotificationStateForCharacteristicBlock?
    var readRSSIBlock: CHReadRSSIBlock?
    var cancelPeripheralsConnectionBlock: CHCentralManagerBlock?
}

#if !os(watchOS)
// MARK: - 外设模式回调
final class CHPeripheralCallback {
    var peripheralDidUpdateStateBlock: CHPeripheralDidUpdateStateBlock?
    var peripheralDidAddService: CHPeripheralDidAddService?
    var peripheralDidStartAdvertising: CHPeripheralDidStartAdvertising?
    var peripheralDidReceiveReadRequest: CHPeripheralDidReceiveReadRequest?
    var peripheralDidReceiveWriteRequests: CHPeripheralDidReceiveWriteRequests?
    var peripheralIsReadyToUpdateSubscribers: CHPeripheralIsReadyToUpdateSubscribers?
    var peripheralDidSubscribeToCharacteristic: CHPeripheralCharacteristicBlock?
    var peripheralDidUnSubscribeToCharacteristic: CHPeripheralCharacteristicBlock?
}
#endif
