//
//  ColorDemoView.swift
//  ColorKitDemo
//
//  Created by Chon Torres on 5/14/25.
//

import ColorKit
import SwiftUI

struct ColorDemoView: View {
    let colors: [Color] = [
        Color(hex: 0x3498db),
        Color(hex: 0xe74c3c, alpha: 0.8),
        Color(hexString: "#2ecc71") ?? .green,
        Color(hexString: "#9b59b6ff") ?? .purple
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0..<colors.count, id: \.self) { index in
                    let color = colors[index]
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color)
                            .frame(height: 100)
                            .overlay(
                                Text("\(color.asHexStringWithAlpha())")
                                    .foregroundColor(color.adaptedTextColor())
                                    .padding(), alignment: .bottomTrailing
                            )
                        Text("Luminance: \(String(format: "%.3f", color.luminance()))")
                            .foregroundColor(.gray)
                        let rgba = color.asTuple()
                        Text("RGBA: R=\(rgba.red), G=\(rgba.green), B=\(rgba.blue), A=\(rgba.alpha)")
                            .font(.caption)
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}
