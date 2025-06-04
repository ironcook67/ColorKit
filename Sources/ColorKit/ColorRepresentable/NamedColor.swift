//
//  NamedColor.swift
//  ColorLab
//
//  Created by Chon Torres on 5/10/25.
//

import SwiftUI

/// Represents the intensity of a color, which can be used to adjust its opacity.
public enum ColorIntensity: String, Codable, CaseIterable, Sendable {
    case primary
    case secondary
    case tertiary
    case quaternary
    case quinary

    public var opacity: Double {
        switch self {
        case .primary: 1.0
        case .secondary: 0.8
        case .tertiary: 0.6
        case .quaternary: 0.4
        case .quinary: 0.2
        }
    }
}

/// Internal enum to track how the color was created
// Making this enum private crashes the Swift compiler.
public enum NamedColorCreationMethod: Hashable, Sendable {
    case hexString(String)
    case directColor
    case systemColor(String)
    case mixedColors(baseHex: String, mixHex: String, fraction: Double, colorSpace: Gradient.ColorSpace)
    case colorWithIntensity(baseColor: Color, intensity: ColorIntensity)
}

public struct NamedColor: Hashable, Sendable {
    /// The name of the color.
    public var name: String

    /// The color represented by this instance.
    public var color: Color

    /// A unique identifier for this color.
    public var id: UUID = UUID()

    // MARK: - Private metadata for encoding support

    /// Stores the creation method for proper encoding
    // TODO: Make this private once encoding is stable
    public var creationMethod: NamedColorCreationMethod = .hexString("")

    /// Initializes a NamedColor with a name and a hex string.
    public init(_ name: String = "", hexString: String) {
        self.name = name
        self.creationMethod = .hexString(hexString)

        let colorFromHex = Color(hexString: hexString)
        if let color = colorFromHex {
            self.color = color
        } else {
            self.color = Color.clear
#if DEBUG
            print("Error: NamedColor \(name) failed to initialize with hexString: \(hexString)")
#endif // DEBUG
        }
    }

    /// Initializes a NamedColor with a name and a Color instance.
    public init(_ name: String = "", color: Color) {
        self.name = name
        self.color = color

        // Try to detect if this is a system color
        if let systemColorName = Self.systemColorName(for: color) {
            self.creationMethod = .systemColor(systemColorName)
        } else {
            self.creationMethod = .directColor
        }
    }

    /// Initializes a NamedColor by mixing two colors with a specified fraction.
    public init(
        _ name: String = "",
        color: Color,
        with color2: Color,
        by fraction: Double,
        in colorSpace: Gradient.ColorSpace = .perceptual
    ) {
        self.name = name
        self.color = color.mix(with: color2, by: fraction, in: colorSpace)
        self.creationMethod = .mixedColors(
            baseHex: color.asHexString(),
            mixHex: color2.asHexString(),
            fraction: fraction,
            colorSpace: colorSpace
        )
    }

    /// Initializes a NamedColor with a name, color, and intensity.
    public init(
        _ name: String = "",
        color: Color,
        intensity: ColorIntensity = .primary
    ) {
        self.name = name
        self.color = color.opacity(intensity.opacity)
        self.creationMethod = .colorWithIntensity(baseColor: color, intensity: intensity)
    }

    /// Attempts to identify if a color matches a known system color
    /// - Parameter color: The color to check
    /// - Returns: The system color name if found, nil otherwise
    public static func systemColorName(for color: Color) -> String? {
        let systemColors: [(String, Color)] = [
            ("clear", Color.clear),
            ("black", Color.black),
            ("white", Color.white),
            ("gray", Color.gray),
            ("red", Color.red),
            ("green", Color.green),
            ("blue", Color.blue),
            ("orange", Color.orange),
            ("yellow", Color.yellow),
            ("pink", Color.pink),
            ("purple", Color.purple),
            ("primary", Color.primary),
            ("secondary", Color.secondary),
            ("accentColor", Color.accentColor)
        ]

        let targetTuple = color.asTuple()

        for (name, systemColor) in systemColors {
            let systemTuple = systemColor.asTuple()

            // Compare with a small tolerance for floating point precision
            if abs(targetTuple.red - systemTuple.red) < 0.001 &&
                abs(targetTuple.green - systemTuple.green) < 0.001 &&
                abs(targetTuple.blue - systemTuple.blue) < 0.001 &&
                abs(targetTuple.alpha - systemTuple.alpha) < 0.001 {
                return name
            }
        }

        return nil
    }
}

/// Provides a default example instance of NamedColor and a collection of named colors.
public extension NamedColor {
    static let example = NamedColor("Example", hexString: "#FF5733")
    
    static let namedColors: [NamedColor] = [
        NamedColor("Licorice", hexString: "#000000"),
        NamedColor("Lead", hexString: "#191919"),
        NamedColor("Tungsten", hexString: "#333333"),
        NamedColor("Iron", hexString: "#4c4c4c"),
        NamedColor("Steel", hexString: "#666666"),
        NamedColor("Tin", hexString: "#7f7f7f"),
        NamedColor("Nickel", hexString: "#808080"),
        NamedColor("Aluminum", hexString: "#999999"),
        NamedColor("Magnesium", hexString: "#b3b3b3"),
        NamedColor("Silver", hexString: "#cccccc"),
        NamedColor("Mercury", hexString: "#e6e6e6"),
        NamedColor("Snow", hexString: "#ffffff"),
        NamedColor("Cayenne", hexString: "#800000"),
        NamedColor("Mocha", hexString: "#804000"),
        NamedColor("Asparagus", hexString: "#808000"),
        NamedColor("Fern", hexString: "#408000"),
        NamedColor("Clover", hexString: "#008000"),
        NamedColor("Moss", hexString: "#008040"),
        NamedColor("Teal", hexString: "#008080"),
        NamedColor("Ocean", hexString: "#004080"),
        NamedColor("Midnight", hexString: "#000080"),
        NamedColor("Eggplant", hexString: "#400080"),
        NamedColor("Plum", hexString: "#800080"),
        NamedColor("Maroon", hexString: "#800040"),
        NamedColor("Maraschino", hexString: "#ff0000"),
        NamedColor("Tangerine", hexString: "#ff8000"),
        NamedColor("Lemon", hexString: "#ffff00"),
        NamedColor("Lime", hexString: "#80ff00"),
        NamedColor("Spring", hexString: "#00ff00"),
        NamedColor("Sea Foam", hexString: "#00ff80"),
        NamedColor("Turquoise", hexString: "#00ffff"),
        NamedColor("Aqua", hexString: "#0080ff"),
        NamedColor("Blueberry", hexString: "#0000ff"),
        NamedColor("Grape", hexString: "#8000ff"),
        NamedColor("Magenta", hexString: "#ff00ff"),
        NamedColor("Strawberry", hexString: "#ff0080"),
        NamedColor("Salmon", hexString: "#ff6666"),
        NamedColor("Cantaloupe", hexString: "#ffcc66"),
        NamedColor("Banana", hexString: "#ffff66"),
        NamedColor("Honeydew", hexString: "#ccff66"),
        NamedColor("Flora", hexString: "#66ff66"),
        NamedColor("Spindrift", hexString: "#66ffcc"),
        NamedColor("Ice", hexString: "#66ffff"),
        NamedColor("Sky", hexString: "#66ccff"),
        NamedColor("Orchid", hexString: "#6666ff"),
        NamedColor("Lavender", hexString: "#cc66ff"),
        NamedColor("Bubblegum", hexString: "#ff66ff"),
        NamedColor("Carnation", hexString: "#ff6fcf"),
    ]
}
