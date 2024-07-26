//
//  ContentView.swift
//  CHBluetooth
//
//  Created by evan on 2024/4/15.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var example = CHExample()
    
    var body: some View {
        VStack {
            List(example.scanPeripherals, id: \.self) { peripheral in
                Section {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(peripheral.name ?? "未命名设备")
                        Text(peripheral.identifier.uuidString)
                            .font(.system(size: 12))
                    }
                }
            }
        }
        .onAppear(perform: {
            example.centralSettings()
        })
    }
}

#Preview {
    ContentView()
}
