//
//  ContentView.swift
//  ColorKitDemo
//
//  Created by Chon Torres on 5/14/25.
//

import ColorKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NamedColorsView()
                .tabItem {
                    Label("Named Colors", systemImage: "paintbrush")
                }

            ColorDemoView()
                .tabItem {
                    Label("Color Demo", systemImage: "paintpalette")
                }
        }
    }
}

#Preview {
    ContentView()
}
