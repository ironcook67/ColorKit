//
//  ColorByIntensity.swift
//  ColorKit
//
//  Created by Chon Torres on 5/31/25.
//

import SwiftUI

/// Represents the intensity of a color, which can be used to adjust its opacity.
public enum ColorIntensity: String, Codable, CaseIterable, Sendable {
    case primary
    case secondary
    case tertiary
    case quaternary
    case quinary
}

public struct ColorByIntensity: ColorRepresentable {
    /// The name of the color, used for identification.
    public let name: String

    /// The intensity of the color, which determines its opacity.
    public let intensity: ColorIntensity

    /// A unique identifier for the color instance.
    public var id: UUID = UUID()

    private let _color: Color

    /// The color value, adjusted based on the intensity.
    public var color: Color {
        switch intensity {
        case .primary: _color
        case .secondary: _color.opacity(0.8)
        case .tertiary: _color.opacity(0.6)
        case .quaternary: _color.opacity(0.4)
        case .quinary: _color.opacity(0.2)
        }
    }

    public init(name: String = "", color: Color, intensity: ColorIntensity = .primary) {
        self.name = name
        self._color = color
        self.intensity = intensity
    }
}
