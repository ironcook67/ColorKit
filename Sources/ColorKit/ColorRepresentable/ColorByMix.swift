//
//  ColorMix.swift
//  ColorKit
//
//  Created by Chon Torres on 5/31/25.
//

import SwiftUI

/// A named color created by mixing two colors with a specified blending factor.
public struct ColorByMix: ColorRepresentable {
    /// Name of the mixed color.
    public let name: String

    /// The first color to mix.
    public let color1: Color

    /// The second color to mix.
    public let color2: Color

    /// The interpolation factor between color1 and color2, in the range 0.0 to 1.0.
    public let mixFactor: Double

    /// The resulting color from mixing color1 and color2 by the mixFactor.
    public var color: Color { _mixedColor }

    public let id = UUID()

    // The resulting color from mixing color1 and color2 by the mixFactor.
    private var _mixedColor: Color {
        color1.mix(with: color2, by: mixFactor)
    }

    public init(name: String = "", color1: Color, color2: Color, mixFactor: Double) {
        self.name = name
        self.color1 = color1
        self.color2 = color2
        self.mixFactor = mixFactor
    }
}
