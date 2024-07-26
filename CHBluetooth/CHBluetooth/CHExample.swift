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
    
    func centralSettings() -> Void {
        
        bluetooth.onStateChange { central in
            if central.state == .poweredOn {
                self.bluetooth.startScanPeripherals()
            }
        }
        bluetooth.onDiscoverPeripherals { [self] peripheral, advertisementData, rssi in
            if !scanPeripherals.contains(peripheral) {
                scanPeripherals.append(peripheral)
                print("Discovered: \(peripheral.name ?? "Unknown")")
            }
        }
        bluetooth.onConnectedPeripheral { peripheral in
            
        }
        bluetooth.onFailToConnect { peripheral, error in
            
        }
        bluetooth.onDisconnect { peripheral, error in
            
        }
        let sancOption: Dictionary<String, Any> = [CBCentralManagerOptionShowPowerAlertKey: true]
        bluetooth.optionsConfig(scanOptions: sancOption)
    }
    
}
