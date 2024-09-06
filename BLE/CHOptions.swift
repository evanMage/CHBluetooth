//
//  CHOptions.swift
//  CHBluetooth
//
//  Created by evan on 2024/7/12.
//

import Foundation
import CoreBluetooth

//MARK: - 中心模式扫描参数
public class CHOptions {
    /// 扫描设备参数
    public var scanForPeripheralsWithOptions: Dictionary<String, Any>? = nil
    /// 连接设备参数
    public var connectPeripheralWithOptions: Dictionary<String, Any>? = nil
    /// 扫描设备服务参数
    public var scanForPeripheralsWithServices: Array<CBUUID>? = nil
    /// 发现服务参数
    public var discoverWithServices: Array<CBUUID>? = nil
    /// 发现特征值参数
    public var discoverWithCharacteristics: Array<CBUUID>? = nil
    
}
