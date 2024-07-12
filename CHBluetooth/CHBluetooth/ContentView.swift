//
//  ContentView.swift
//  CHBluetooth
//
//  Created by evan on 2024/4/15.
//

import SwiftUI

struct ContentView: View {
    let example = CHExample()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear(perform: {
            example.centralSettings()
        })
    }
}

#Preview {
    ContentView()
}
