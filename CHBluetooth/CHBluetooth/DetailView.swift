//
//  DetailView.swift
//  CHBluetooth
//
//  Created by skraBgoDyhW on 2024/7/26.
//

import SwiftUI
import CoreBluetooth

struct DetailView: View {
    
    @EnvironmentObject var example: CHExample
    let peripheral: CBPeripheral
    
    var body: some View {
        VStack {
            if peripheral.state == .connected {
                List {
                    if let services = peripheral.services {
                        ForEach(services, id: \.self) { service in
                            Section {
                                if let characteristics = service.characteristics {
                                    ForEach(characteristics, id: \.self) { characteristic in
                                        Text("\(characteristic.uuid.uuidString)")
                                            .font(.system(size: 15))
                                        Text(example.properties(characteristic: characteristic).joined(separator: " - "))
                                            .font(.system(size: 14))
                                            .foregroundColor(.green)
                                    }
                                }
                            } header: {
                                Text("服务：\(service.uuid.uuidString)")
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            if peripheral.state != .connected {
                example.startConnect(peripheral)
            }
        })
    }
}
