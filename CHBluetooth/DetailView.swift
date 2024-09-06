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
                                        NavigationLink {
                                            CharacteristicView(peripheral: peripheral, characteristic: characteristic)
                                        } label: {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("\(characteristic.uuid.uuidString)")
                                                    .font(.system(size: 15))
                                                Text(example.properties(characteristic: characteristic).joined(separator: " - "))
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.green)
                                            }
                                        }
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

enum CHProperties: String {
    case read
    case write
    case notify
}

struct CharacteristicView: View {
    @EnvironmentObject var example: CHExample
    let peripheral: CBPeripheral
    let characteristic: CBCharacteristic
    
    @State var readValue = ""
    @State var writeValue = ""
    @State var notifyValue = ""
    
    var body: some View {
        VStack {
            if characteristic.properties.contains(.read) {
                Button("read") {
                    CHBluetooth.sharedBluetooth.onReadValueForCharacteristic { peripheral, characteristic, error in
                        if let data = characteristic.value {
                            readValue = data.utf8Str ?? ""
                            print(readValue)
                        }
                    }
                    CHBluetooth.sharedBluetooth.readValue(peripheral, characteristic)
                }
                Text(readValue)
            }
            if characteristic.properties.contains(.write) {
                TextField(text: $writeValue) {
                    Text("write")
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    if let value = writeValue.stringToData {
                        example.write(peripheral, characteristic: characteristic, value: "1".stringToData!)
                        example.write(peripheral, characteristic: characteristic, value: "value".stringToData!)
                    }
                }
            }
            if characteristic.properties.contains(.notify) || characteristic.properties.contains(.indicate) {
                Button("notify") {
                    CHBluetooth.sharedBluetooth.notify(peripheral, characteristic) { peripheral, characteristic, error in
                        if let data = characteristic.value {
                            notifyValue = data.utf8Str ?? ""
                            print(notifyValue)
                        }
                    }
                }
                Text(notifyValue)
            }
            Spacer()
        }
        .padding()
    }
    
    private func properties() -> [CHProperties] {
        var result: [CHProperties] = []
        if characteristic.properties.contains(.read) {
            result.append(.read)
        }
        if characteristic.properties.contains(.write) {
            result.append(.write)
        }
        if characteristic.properties.contains(.notify) || characteristic.properties.contains(.indicate) {
            result.append(.notify)
        }
        return result
    }
}
