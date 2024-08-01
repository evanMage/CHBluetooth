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
    private let bluetooth = CHBluetooth.sharedBluetooth
     
    private var peripheral: CBPeripheralManager?
    private var notifyCharacteristic: CBMutableCharacteristic?
    
    override init() {
        super.init()
        setPeripheral()
    }
    
    private func setPeripheral() -> Void {
        
        bluetooth.peripheralModeDidUpdateState { [self] peripheral in
            if peripheral.state == .poweredOn {
                let characteristic1 = bluetooth.makeCharacteristic(characteristicUUID: CBUUID(string: "DA18") , properties: [.notify], permissions: [.readable])
                self.notifyCharacteristic = characteristic1
                let characteristic2 = bluetooth.makeCharacteristic(characteristicUUID: CBUUID(string: "DA17"), properties: [.write], permissions: [.writeable])
                let characteristic3 = bluetooth.makeCharacteristic(characteristicUUID: CBUUID(string: "DA16"), properties: [.read], permissions: [.readable])
                let service = bluetooth.makeService(uuid: "EBA38950-0D9B-4DBA-B0DF-BC7196DD44FC", characteristics: [characteristic1, characteristic2, characteristic3])
                bluetooth.addService(services: [service])
            }
        }
        
        bluetooth.peripheralModeDidAddService { [self] peripheral, service, error in
            bluetooth.startAdvertising(localName: "iPhone", serverUuids: [CBUUID(string: "EBA38950-0D9B-4DBA-B0DF-BC7196DD44FC")])
        }
        
        bluetooth.peripheralModeDidStartAdvertising { peripheral, error in
            print("开始广播：\(peripheral)")
            self.peripheral = peripheral
        }
        
        bluetooth.peripheralModeDidReceiveReadRequest { peripheral, request in
            print("接收读请求：\(peripheral)")
            let data = "hello".stringToData
            request.value = data
            peripheral.respond(to: request, withResult: .success)
        }
        
        bluetooth.peripheralModeDidReceiveWriteRequests { peripheral, requests in
            print("接收写请求：\(peripheral)")
            for request in requests {
                let value = request.value
                print(value?.utf8Str ?? "")
            }
        }
        
        bluetooth.peripheralModeDidSubscribeToCharacteristic { [self] peripheral, central, characteristic in
            print("接收订阅通知：\(peripheral)")
            bluetooth.stopAdvertising()
        }
        
        bluetooth.peripheralModeDidUnSubscribeToCharacteristic { [self] peripheral, central, characteristic in
            print("接收订阅取消：\(peripheral)")
            bluetooth.startAdvertising(localName: "iPhone", serverUuids: [CBUUID(string: "EBA38950-0D9B-4DBA-B0DF-BC7196DD44FC")])
        }
        
        bluetooth.peripheralModeIsReadyToUpdateSubscribers { [self] peripheral in
            if let value = "update".stringToData, let notifyCharacteristic = notifyCharacteristic {
                peripheral.updateValue(value, for: notifyCharacteristic, onSubscribedCentrals: nil)
            }
        }
        
        bluetooth.startPeripheralManager()
    }
    
}
