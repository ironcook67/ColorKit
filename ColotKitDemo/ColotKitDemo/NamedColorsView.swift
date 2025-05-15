//
//  CustomColorsView.swift
//  ColorKitDemo
//
//  Created by Chon Torres on 5/14/25.
//

import ColorKit
import SwiftUI

struct NamedColorsView: View {
    let columns = [GridItem(.adaptive(minimum: 100))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(CustomNamedColor.namedColors) { namedColor in
                    VStack {
                        namedColor.color
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                        Text(namedColor.name)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}
