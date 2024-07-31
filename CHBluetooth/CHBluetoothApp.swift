//
//  CHBluetoothApp.swift
//  CHBluetooth
//
//  Created by evan on 2024/4/15.
//

import SwiftUI

@main
struct CHBluetoothApp: App {
    
    @StateObject var example = CHExample()
    // 外设模式
    @StateObject var peripheralExample = CHPeripheralExample.manager
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(example)
                .environmentObject(peripheralExample)
        }
    }
}
