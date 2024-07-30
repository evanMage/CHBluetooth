//
//  CHPeripheralExample.swift
//  CHBluetooth
//
//  Created by skraBgoDyhW on 2024/7/29.
//

import Foundation
import CoreBluetooth

class CHPeripheralExample: NSObject, ObservableObject {
    
    static let manager = CHPeripheralExample()
    private let bluetooth = CHBluetooth.instance
    
    override init() {
        super.init()
        setPeripheral()
    }
    
    private func setPeripheral() -> Void {
        
        bluetooth.peripheralModeDidUpdateState { [self] peripheral in
            if peripheral.state == .poweredOn {
                let characteristic1 = bluetooth.makeCharacteristic(characteristicUUID: CBUUID(string: "DA18") , properties: [.notify], permissions: [.readable])
                let characteristic2 = bluetooth.makeCharacteristic(characteristicUUID: CBUUID(string: "DA17"), properties: [.write], permissions: [.writeable])
                let characteristic3 = bluetooth.makeCharacteristic(characteristicUUID: CBUUID(string: "DA16"), properties: [.read], permissions: [.readable])
                let service = bluetooth.makeService(uuid: "EBA38950-0D9B-4DBA-B0DF-BC7196DD44FC", characteristics: [characteristic1, characteristic2, characteristic3])
                bluetooth.addService(services: [service])
            }
        }
        
        bluetooth.peripheralModeDidAddService { [self] peripheral, service, error in
            bluetooth.startAdvertising(localName: "evan", serverUuids: [CBUUID(string: "EBA38950-0D9B-4DBA-B0DF-BC7196DD44FC")])
        }
        
        bluetooth.peripheralModeDidStartAdvertising { peripheral, error in
            print("开始广播：\(peripheral)")
        }
        
        bluetooth.peripheralModeDidReceiveReadRequest { peripheral, request in
            print("接收读请求：\(peripheral)")
            let data = "1234".hexToData
            request.value = data
            peripheral.respond(to: request, withResult: .success)
        }
        
        bluetooth.peripheralModeDidReceiveWriteRequests { peripheral, requests in
            print("接收写请求：\(peripheral)")
        }
        
        bluetooth.peripheralModeDidSubscribeToCharacteristic { peripheral, central, characteristic in
            print("接收订阅通知：\(peripheral)")
        }
        
        bluetooth.peripheralModeDidUnSubscribeToCharacteristic { peripheral, central, characteristic in
            print("接收订阅取消：\(peripheral)")
        }
        
        bluetooth.startPeripheralManager()
    }
    
}
