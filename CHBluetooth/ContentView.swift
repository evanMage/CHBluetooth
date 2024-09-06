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
    private let queue = DispatchQueue(label: "com.evan.queue")
    
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
//            example2.centralSettings()
            example.centralSettings()
            for index in 0...20 {
                queue.async {
                    sleep(2)
                    print("----1------ \(index)")
                }
            }
//            queue.async {
                
//            }
        })
    }
}

#Preview {
    ContentView()
}
