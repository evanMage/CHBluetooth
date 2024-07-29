//
//  CHExample.swift
//  CHBluetooth
//
//  Created by evan on 2024/7/12.
//

import Foundation
import CoreBluetooth

class CHExample: NSObject, ObservableObject {
    
    let bluetooth = CHBluetooth.instance
    
    @Published var scanPeripherals: Array<CBPeripheral> = []
    @Published var discoverCharacteristics: Dictionary<String, Array<CBService>> = [:]
    
    private var discoverServices: Array<CBService> = []
    
    func centralSettings() -> Void {
        
        bluetooth.onStateChange { central in
            if central.state == .poweredOn {
                self.bluetooth.startScanPeripherals()
            }
        }
        bluetooth.onDiscoverPeripherals { [self] peripheral, advertisementData, rssi in
            if !scanPeripherals.contains(peripheral) {
                scanPeripherals.append(peripheral)
                print("--- 1 --- Discovered: \(peripheral.name ?? "Unknown")")
            }
        }
        bluetooth.onConnectedPeripheral { [self] peripheral in
            print("---- 连接成功：\(peripheral)")
            bluetooth.startDiscoverServices(peripheral)
        }
        bluetooth.onFailToConnect { [self] peripheral, error in
            print("---- 连接失败：\(peripheral)")
            discoverCharacteristics.removeValue(forKey: peripheral.identifier.uuidString)
        }
        bluetooth.onDisconnect { peripheral, error in
            print("---- 连接断开：\(peripheral)")
        }
        bluetooth.onDiscoverServices { [self] peripheral, error in
            if let sercices = peripheral.services {
                print("---- 发现服务：\(peripheral)")
                discoverServices.append(contentsOf: sercices)
                bluetooth.startDiscoverCharacteristic(peripheral)
            }
        }
        bluetooth.onDiscoverCharacteristics { [self] peripheral, service, error in
            discoverServices.removeLast()
            if !discoverServices.isEmpty {
                return
            }
            print("---- 发现特征：\(peripheral)")
            if let sercices = peripheral.services {
                discoverCharacteristics[peripheral.identifier.uuidString] = sercices
            }
        }
        bluetooth.onDisconnect { peripheral, error in
            
        }
        let sancOption: Dictionary<String, Any> = [CBCentralManagerOptionShowPowerAlertKey: true]
        bluetooth.optionsConfig(scanOptions: sancOption)
    }
    
    func startConnect(_ peripheral: CBPeripheral) -> Void {
        print("---- 开始连接：\(peripheral)")
        bluetooth.startConnect(peripheral)
    }
    
    func properties(characteristic: CBCharacteristic) -> [String] {
        var res: Array<String> = []
        if characteristic.properties.contains(.read) {
            res.append("read")
        }
        if characteristic.properties.contains(.write) {
            res.append("write")
        }
        if characteristic.properties.contains(.notify) || characteristic.properties.contains(.indicate) {
            res.append("notify")
        }
        return res
    }
    
}

//class CHExample2: NSObject, ObservableObject {
//    
//    let bluetooth = CHBluetooth()
//    
//    @Published var scanPeripherals: Array<CBPeripheral> = []
//    @Published var discoverCharacteristics: Dictionary<String, Array<CBService>> = [:]
//    
//    private var discoverServices: Array<CBService> = []
//    
//    func centralSettings() -> Void {
//        
//        bluetooth.onStateChange { central in
//            if central.state == .poweredOn {
//                self.bluetooth.startScanPeripherals()
//            }
//        }
//        bluetooth.onDiscoverPeripherals { [self] peripheral, advertisementData, rssi in
//            if !scanPeripherals.contains(peripheral) {
//                scanPeripherals.append(peripheral)
//                print("--- 2 --- Discovered: \(peripheral.name ?? "Unknown")")
//            }
//        }
//        bluetooth.onConnectedPeripheral { [self] peripheral in
//            print("---- 连接成功：\(peripheral)")
//            bluetooth.startDiscoverServices(peripheral)
//        }
//        bluetooth.onFailToConnect { [self] peripheral, error in
//            print("---- 连接失败：\(peripheral)")
//            discoverCharacteristics.removeValue(forKey: peripheral.identifier.uuidString)
//        }
//        bluetooth.onDisconnect { peripheral, error in
//            print("---- 连接断开：\(peripheral)")
//        }
//        bluetooth.onDiscoverServices { [self] peripheral, error in
//            if let sercices = peripheral.services {
//                print("---- 发现服务：\(peripheral)")
//                discoverServices.append(contentsOf: sercices)
//                bluetooth.startDiscoverCharacteristic(peripheral)
//            }
//        }
//        bluetooth.onDiscoverCharacteristics { [self] peripheral, service, error in
//            discoverServices.removeLast()
//            if !discoverServices.isEmpty {
//                return
//            }
//            print("---- 发现特征：\(peripheral)")
//            if let sercices = peripheral.services {
//                discoverCharacteristics[peripheral.identifier.uuidString] = sercices
//            }
//        }
//        bluetooth.onDisconnect { peripheral, error in
//            
//        }
//        let sancOption: Dictionary<String, Any> = [CBCentralManagerOptionShowPowerAlertKey: true]
//        bluetooth.optionsConfig(scanOptions: sancOption)
//    }
//    
//    func startConnect(_ peripheral: CBPeripheral) -> Void {
//        print("---- 开始连接：\(peripheral)")
//        bluetooth.startConnect(peripheral)
//    }
//    
//    func properties(characteristic: CBCharacteristic) -> [String] {
//        var res: Array<String> = []
//        if characteristic.properties.contains(.read) {
//            res.append("read")
//        }
//        if characteristic.properties.contains(.write) {
//            res.append("write")
//        }
//        if characteristic.properties.contains(.notify) || characteristic.properties.contains(.indicate) {
//            res.append("notify")
//        }
//        return res
//    }
//    
//}

