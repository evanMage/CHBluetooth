//
//  CHExample.swift
//  CHBluetooth
//
//  Created by evan on 2024/7/12.
//

import Foundation
import CoreBluetooth

class CHExample {
    
    let bluetooth = CHBluetooth.instance
    
    func centralSettings() -> Void {
        
        bluetooth.onStateChange { central in
            if central.state == .poweredOn {
                self.bluetooth.startScanPeripherals()
            }
        }
        bluetooth.onDiscoverPeripherals { peripheral, advertisementData, rssi in
            debugPrint("--- \(peripheral) - \(rssi)")
        }
        bluetooth.onConnectedPeripheral { peripheral in
            
        }
        bluetooth.onFailToConnect { peripheral, error in
            
        }
        bluetooth.onDisconnect { peripheral, error in
            
        }
        let sancOption: Dictionary<String, Any> = [CBCentralManagerScanOptionAllowDuplicatesKey: false, CBCentralManagerOptionShowPowerAlertKey: true]
        bluetooth.optionsConfig(scanOptions: sancOption)
    }
    
}
