//
//  ContentView.swift
//  CHBluetooth
//
//  Created by evan on 2024/4/15.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var example: CHExample
//    @StateObject var example2: CHExample2 = CHExample2()

    var body: some View {
        NavigationStack {
            List(example.scanPeripherals, id: \.self) { peripheral in
                Section {
                    NavigationLink {
                        DetailView(peripheral: peripheral)
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(peripheral.name ?? "未命名设备")
                            if peripheral.state == .connected {
                                Text("已连接")
                                    .foregroundColor(.red)
                            }
                            Text(peripheral.identifier.uuidString)
                                .font(.system(size: 12))
                        }
                    }
                }
            }
            .navigationTitle("首页")
        }
        .onAppear(perform: {
            example.centralSettings()
//            example2.centralSettings()
        })
    }
}

#Preview {
    ContentView()
}
