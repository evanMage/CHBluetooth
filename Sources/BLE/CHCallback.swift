//
//  CHCallback.swift
//  CHBluetooth
//
//  Created by evan on 2024/04/15.
//

import Foundation
import CoreBluetooth

/// 设备状态改变委托 停止扫描委托 断开所有连接设备回调
public typealias CHCentralManagerBlock = (_ central: CBCentralManager) -> Void
/// 找到设备委托
public typealias CHDiscoverPeripheralsBlock = (_ peripheral: CBPeripheral, _ advertisementData: [String : Any], _ rssi: NSNumber) -> Void
/// 连接设备成功委托
public typealias CHConnectedPeripheralBlock = (_ peripheral: CBPeripheral) -> Void
/// 找到服务委托、断开设备连接委托、连接设备失败委托
public typealias CHPeripheralInfoBlock = (_ peripheral: CBPeripheral, _ error: Error?) -> Void
/// 找到特征委托
public typealias CHDiscoverCharacteristicsBlock = (_ peripheral: CBPeripheral, _ service: CBService, _ error: Error?) -> Void
/// 读取特征值委托  写入特征值委托 获取特征值名称
public typealias CHCharacteristicInfoBlock = (_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) -> Void
/// 获取Descriptors的值
public typealias CHReadValueForDescriptorsBlock = (_ peripheral: CBPeripheral, _ descriptor: CBDescriptor, _ error: Error?) -> Void
/// 写入Descriptors
public typealias CHDidWriteValueForDescriptorBlock = (_ descriptor: CBDescriptor, _ error: Error?) -> Void
/// 监听特征值返回
public typealias CHDidUpdateNotificationStateForCharacteristicBlock = (_ characteristic: CBCharacteristic, _ error: Error?) -> Void
/// 读取rssi值
public typealias CHReadRSSIBlock = (_ rssi: NSNumber, _ error: Error?) -> Void

#if !os(watchOS)
/// 外设状态关闭委托
public typealias CHPeripheralModeDidUpdateStateBlock = (_ peripheral: CBPeripheralManager) -> Void
/// 添加服务委托
public typealias CHPeripheralModeDidAddService = (_ peripheral: CBPeripheralManager, _ service: CBService, _ error: Error?) -> Void
public typealias CHPeripheralModeDidStartAdvertising = (_ peripheral: CBPeripheralManager, _ error: Error?) -> Void
public typealias CHPeripheralModeDidReceiveReadRequest = (_ peripheral: CBPeripheralManager, _ request: CBATTRequest) -> Void
public typealias CHPeripheralModeDidReceiveWriteRequests = (_ peripheral: CBPeripheralManager, _ requests: [CBATTRequest]) -> Void
public typealias CHPeripheralModeIsReadyToUpdateSubscribers = (_ peripheral: CBPeripheralManager) -> Void
public typealias CHPeripheralModeCharacteristicBlock = (_ peripheral: CBPeripheralManager, _ central: CBCentral, _ characteristic: CBCharacteristic) -> Void
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
    var peripheralModeDidUpdateStateBlock: CHPeripheralModeDidUpdateStateBlock?
    var peripheralModeDidAddService: CHPeripheralModeDidAddService?
    var peripheralModeDidStartAdvertising: CHPeripheralModeDidStartAdvertising?
    var peripheralModeDidReceiveReadRequest: CHPeripheralModeDidReceiveReadRequest?
    var peripheralModeDidReceiveWriteRequests: CHPeripheralModeDidReceiveWriteRequests?
    var peripheralModeIsReadyToUpdateSubscribers: CHPeripheralModeIsReadyToUpdateSubscribers?
    var peripheralModeDidSubscribeToCharacteristic: CHPeripheralModeCharacteristicBlock?
    var peripheralModeDidUnSubscribeToCharacteristic: CHPeripheralModeCharacteristicBlock?
}
#endif
