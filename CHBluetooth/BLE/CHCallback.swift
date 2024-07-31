//
//  CHDefinitions.swift
//  CHBluetooth
//
//  Created by evan on 2024/04/15.
//

import Foundation
import CoreBluetooth

/// 设备状态改变委托
public typealias CHCentralManagerDidUpdateStateBlock = (_ central: CBCentralManager) -> Void
/// 找到设备委托
public typealias CHDiscoverPeripheralsBlock = (_ peripheral: CBPeripheral, _ advertisementData: [String : Any], _ rssi: NSNumber) -> Void
/// 连接设备成功委托
public typealias CHConnectedPeripheralBlock = (_ peripheral: CBPeripheral) -> Void
/// 连接设备失败委托
public typealias CHFailToConnectBlock = (_ peripheral: CBPeripheral, _ error: Error?) -> Void
/// 断开设备连接委托
public typealias CHDisconnectBlock = (_ peripheral: CBPeripheral, _ error: Error?) -> Void
/// 找到服务委托
public typealias CHDiscoverServicesBlock = (_ peripheral: CBPeripheral, _ error: Error?) -> Void
/// 找到特征委托
public typealias CHDiscoverCharacteristicsBlock = (_ peripheral: CBPeripheral, _ service: CBService, _ error: Error?) -> Void
/// 读取特征值委托
public typealias CHReadValueForCharacteristicBlock = (_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) -> Void
/// 获取特征值名称
public typealias CHDiscoverDescriptorsForCharacteristicBlock = (_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) -> Void
/// 获取Descriptors的值
public typealias CHReadValueForDescriptorsBlock = (_ peripheral: CBPeripheral, _ descriptor: CBDescriptor, _ error: Error?) -> Void
/// 写入特征值委托
public typealias CHDidWriteValueForCharacteristicBlock = (_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) -> Void
/// 写入Descriptors
public typealias CHDidWriteValueForDescriptorBlock = (_ descriptor: CBDescriptor, _ error: Error?) -> Void
/// 监听特征值返回
public typealias CHDidUpdateNotificationStateForCharacteristicBlock = (_ characteristic: CBCharacteristic, _ error: Error?) -> Void
/// 读取rssi值
public typealias CHReadRSSIBlock = (_ rssi: NSNumber, _ error: Error?) -> Void
/// 停止扫描委托
public typealias CHCancelScanBlock = (_ centralManager: CBCentralManager) -> Void
/// 断开所有连接设备回调
public typealias CHCancelPeripheralsConnectionBlock = ((_ centralManager: CBCentralManager) -> Void)
/// 外设状态关闭委托
public typealias CHPeripheralModeDidUpdateStateBlock = (_ peripheral: CBPeripheralManager) -> Void
/// 添加服务委托
public typealias CHPeripheralModeDidAddService = (_ peripheral: CBPeripheralManager, _ service: CBService, _ error: Error?) -> Void
public typealias CHPeripheralModeDidStartAdvertising = (_ peripheral: CBPeripheralManager, _ error: Error?) -> Void
public typealias CHPeripheralModeDidReceiveReadRequest = (_ peripheral: CBPeripheralManager, _ request: CBATTRequest) -> Void
public typealias CHPeripheralModeDidReceiveWriteRequests = (_ peripheral: CBPeripheralManager, _ requests: Array<CBATTRequest>) -> Void
public typealias CHPeripheralModeIsReadyToUpdateSubscribers = (_ peripheral: CBPeripheralManager) -> Void
public typealias CHPeripheralModeDidSubscribeToCharacteristic = (_ peripheral: CBPeripheralManager, _ central: CBCentral, _ characteristic: CBCharacteristic) -> Void
public typealias CHPeripheralModeDidUnSubscribeToCharacteristic = (_ peripheral: CBPeripheralManager, _ central: CBCentral, _ characteristic: CBCharacteristic) -> Void

public class CHCallback {
    //MARK: - central callback
    var centralManagerDidUpdateStateBlock: CHCentralManagerDidUpdateStateBlock? = nil
    var discoverPeripheralsBlock: CHDiscoverPeripheralsBlock? = nil
    var connectedPeripheralBlock: CHConnectedPeripheralBlock? = nil
    var failToConnectBlock: CHFailToConnectBlock? = nil
    var disconnectBlock: CHDisconnectBlock? = nil
    var discoverServicesBlock: CHDiscoverServicesBlock? = nil
    var discoverCharacteristicsBlock: CHDiscoverCharacteristicsBlock? = nil
    var readValueForCharacteristicBlock: CHReadValueForCharacteristicBlock? = nil
    var discoverDescriptorsForCharacteristicBlock: CHDiscoverDescriptorsForCharacteristicBlock? = nil
    var readValueForDescriptorsBlock: CHReadValueForDescriptorsBlock? = nil
    var didWriteValueForCharacteristicBlock: CHDidWriteValueForCharacteristicBlock? = nil
    var didWriteValueForDescriptorBlock: CHDidWriteValueForDescriptorBlock? = nil
    var didUpdateNotificationStateForCharacteristicBlock: CHDidUpdateNotificationStateForCharacteristicBlock? = nil
    var readRSSIBlock: CHReadRSSIBlock? = nil
    var cancelScanBlock: CHCancelScanBlock? = nil
    var cancelPeripheralsConnectionBlock: CHCancelPeripheralsConnectionBlock? = nil
    
    //MARK: - peripheral callback
    var peripheralModeDidUpdateStateBlock: CHPeripheralModeDidUpdateStateBlock? = nil
    var peripheralModeDidAddService: CHPeripheralModeDidAddService? = nil
    var peripheralModeDidStartAdvertising: CHPeripheralModeDidStartAdvertising? = nil
    var peripheralModeDidReceiveReadRequest: CHPeripheralModeDidReceiveReadRequest? = nil
    var peripheralModeDidReceiveWriteRequests: CHPeripheralModeDidReceiveWriteRequests? = nil
    var peripheralModeIsReadyToUpdateSubscribers: CHPeripheralModeIsReadyToUpdateSubscribers? = nil
    var peripheralModeDidSubscribeToCharacteristic: CHPeripheralModeDidSubscribeToCharacteristic? = nil
    var peripheralModeDidUnSubscribeToCharacteristic: CHPeripheralModeDidUnSubscribeToCharacteristic? = nil
}
