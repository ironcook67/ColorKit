//
//  NamedColor+Codable.swift
//  ColorLab
//
//  Created by Chon Torres on 6/3/25.
//

import SwiftUI

/// Represents different ways a NamedColor can be encoded to preserve reconstruction capability
private enum ColorEncoding: String, Codable {
    case hexString
    case systemColor
    case mixedColors
    case colorWithIntensity
}

/// Private structure used for encoding/decoding NamedColor instances
private struct NamedColorData: Codable {
    let name: String
    let id: UUID
    let encoding: ColorEncoding

    // For hex string colors
    let hexString: String?

    // For system colors
    let systemColorName: String?

    // For mixed colors
    let baseHexString: String?
    let mixHexString: String?
    let mixFraction: Double?
    let colorSpace: String?

    // For colors with intensity
    let baseColorHex: String?
    let baseSystemColorName: String?
    let intensity: ColorIntensity?
}

extension NamedColor: Codable {
    /// Custom coding keys for the NamedColor structure
    private enum CodingKeys: String, CodingKey {
        case data
    }

    /// Initializes a NamedColor from a decoder
    /// - Parameter decoder: The decoder to read data from
    /// - Throws: DecodingError if the data cannot be decoded
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(NamedColorData.self, forKey: .data)

        self.name = data.name
        self.id = data.id

        switch data.encoding {
        case .hexString:
            guard let hexString = data.hexString else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Missing hex string for hexString encoding"
                    )
                )
            }

            if let color = Color(hexString: hexString) {
                self.color = color
            } else {
                self.color = Color.clear
#if DEBUG
                print("Warning: Failed to decode NamedColor '\(data.name)' from hex string: \(hexString)")
#endif
            }

        case .systemColor:
            guard let systemColorName = data.systemColorName else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Missing system color name for systemColor encoding"
                    )
                )
            }

            self.color = Self.systemColor(named: systemColorName) ?? Color.clear

        case .mixedColors:
            guard let baseHex = data.baseHexString,
                  let mixHex = data.mixHexString,
                  let fraction = data.mixFraction,
                  let colorSpaceString = data.colorSpace,
                  let baseColor = Color(hexString: baseHex),
                  let mixColor = Color(hexString: mixHex) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Missing or invalid data for mixedColors encoding"
                    )
                )
            }

            let colorSpace = Self.gradientColorSpace(from: colorSpaceString)
            self.color = baseColor.mix(with: mixColor, by: fraction, in: colorSpace)

        case .colorWithIntensity:
            guard let intensity = data.intensity else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Missing intensity for colorWithIntensity encoding"
                    )
                )
            }

            let baseColor: Color
            if let systemColorName = data.baseSystemColorName {
                baseColor = Self.systemColor(named: systemColorName) ?? Color.clear
            } else if let baseHex = data.baseColorHex {
                baseColor = Color(hexString: baseHex) ?? Color.clear
            } else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Missing base color data for colorWithIntensity encoding"
                    )
                )
            }

            self.color = baseColor.opacity(intensity.opacity)
        }
    }

    /// Encodes the NamedColor to an encoder
    /// - Parameter encoder: The encoder to write data to
    /// - Throws: EncodingError if the data cannot be encoded
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Determine the best encoding strategy based on how this color was likely created
        let data = try Self.determineEncodingStrategy(for: self)
        try container.encode(data, forKey: .data)
    }

    /// Determines the appropriate encoding strategy for a NamedColor
    /// - Parameter namedColor: The NamedColor to analyze
    /// - Returns: NamedColorData configured with the appropriate encoding strategy
    /// - Throws: EncodingError if the color cannot be encoded
    private static func determineEncodingStrategy(for namedColor: NamedColor) throws -> NamedColorData {
        // Check if this is a system color
        if let systemColorName = systemColorName(for: namedColor.color) {
            return NamedColorData(
                name: namedColor.name,
                id: namedColor.id,
                encoding: .systemColor,
                hexString: nil,
                systemColorName: systemColorName,
                baseHexString: nil,
                mixHexString: nil,
                mixFraction: nil,
                colorSpace: nil,
                baseColorHex: nil,
                baseSystemColorName: nil,
                intensity: nil
            )
        }

        // For non-system colors, default to hex string encoding
        return NamedColorData(
            name: namedColor.name,
            id: namedColor.id,
            encoding: .hexString,
            hexString: namedColor.color.asHexString(),
            systemColorName: nil,
            baseHexString: nil,
            mixHexString: nil,
            mixFraction: nil,
            colorSpace: nil,
            baseColorHex: nil,
            baseSystemColorName: nil,
            intensity: nil
        )
    }

    /// Attempts to identify if a color matches a known system color
    /// - Parameter color: The color to check
    /// - Returns: The system color name if found, nil otherwise
    private static func systemColorName(for color: Color) -> String? {
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

    /// Creates a system color from its name
    /// - Parameter name: The name of the system color
    /// - Returns: The corresponding Color, or nil if not found
    private static func systemColor(named name: String) -> Color? {
        switch name {
        case "clear": return Color.clear
        case "black": return Color.black
        case "white": return Color.white
        case "gray": return Color.gray
        case "red": return Color.red
        case "green": return Color.green
        case "blue": return Color.blue
        case "orange": return Color.orange
        case "yellow": return Color.yellow
        case "pink": return Color.pink
        case "purple": return Color.purple
        case "primary": return Color.primary
        case "secondary": return Color.secondary
        case "accentColor": return Color.accentColor
        default: return nil
        }
    }

    /// Converts a string representation back to a Gradient.ColorSpace
    /// - Parameter string: The string representation of the color space
    /// - Returns: The corresponding Gradient.ColorSpace
    private static func gradientColorSpace(from string: String) -> Gradient.ColorSpace {
        switch string {
        case "device": return .device
        case "perceptual": return .perceptual
        default: return .perceptual
        }
    }
}

// MARK: - Enhanced Initializers for Better Encoding Support

public extension NamedColor {
    /// Initializes a NamedColor that will be encoded with mixed color information
    /// - Parameters:
    ///   - name: The name of the color
    ///   - baseColor: The base color for mixing
    ///   - mixColor: The color to mix with
    ///   - fraction: The mixing fraction
    ///   - colorSpace: The color space for mixing
    /// - Note: This initializer stores additional metadata to enable proper encoding/decoding
    static func mixedColor(
        _ name: String = "",
        baseColor: Color,
        mixColor: Color,
        fraction: Double,
        colorSpace: Gradient.ColorSpace = .perceptual
    ) -> NamedColor {
        return NamedColor(name, color: baseColor, with: mixColor, by: fraction, in: colorSpace)
    }

    /// Initializes a NamedColor with intensity information that will be preserved during encoding
    /// - Parameters:
    ///   - name: The name of the color
    ///   - baseColor: The base color before intensity is applied
    ///   - intensity: The intensity to apply
    /// - Note: This initializer enables the intensity information to be preserved during encoding/decoding
    static func colorWithIntensity(
        _ name: String = "",
        baseColor: Color,
        intensity: ColorIntensity
    ) -> NamedColor {
        return NamedColor(name, color: baseColor, intensity: intensity)
    }
}
