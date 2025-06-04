//
//  NamedColor+Codable.swift
//  ColorLab
//
//  Created by Chon Torres on 6/3/25.
//

import SwiftUI

/// Private structure used for encoding/decoding NamedColor instances
public struct NamedColorData: Codable {
    let name: String
    let id: String
    let encoding: NamedColorEncoding

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

/// Represents different ways a NamedColor can be encoded to preserve reconstruction capability
public enum NamedColorEncoding: String, Codable {
    case hexString
    case systemColor
    case mixedColors
    case colorWithIntensity
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

            self.creationMethod = .hexString(hexString)

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
            self.creationMethod = .systemColor(systemColorName)

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
            self.creationMethod = .mixedColors(
                baseHex: baseHex,
                mixHex: mixHex,
                fraction: fraction,
                colorSpace: colorSpace
            )

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
            self.creationMethod = .colorWithIntensity(baseColor: baseColor, intensity: intensity)
        }
    }

    /// Encodes the NamedColor to an encoder
    /// - Parameter encoder: The encoder to write data to
    /// - Throws: EncodingError if the data cannot be encoded
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        let data = try createEncodingData()
        try container.encode(data, forKey: .data)
    }

    /// Creates the appropriate NamedColorData based on the creation method
    /// - Returns: NamedColorData configured with the appropriate encoding strategy
    /// - Throws: EncodingError if the color cannot be encoded
    private func createEncodingData() throws -> NamedColorData {
        switch creationMethod {
        case .hexString(let hexString):
            return NamedColorData(
                name: name,
                id: id,
                encoding: .hexString,
                hexString: hexString,
                systemColorName: nil,
                baseHexString: nil,
                mixHexString: nil,
                mixFraction: nil,
                colorSpace: nil,
                baseColorHex: nil,
                baseSystemColorName: nil,
                intensity: nil
            )

        case .directColor:
            // For direct colors, try to detect if it's a system color, otherwise use hex
            if let systemColorName = Self.systemColorName(for: color) {
                return NamedColorData(
                    name: name,
                    id: id,
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
            } else {
                return NamedColorData(
                    name: name,
                    id: id,
                    encoding: .hexString,
                    hexString: color.asHexString(),
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

        case .systemColor(let systemColorName):
            return NamedColorData(
                name: name,
                id: id,
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

        case .mixedColors(let baseHex, let mixHex, let fraction, let colorSpace):
            return NamedColorData(
                name: name,
                id: id,
                encoding: .mixedColors,
                hexString: nil,
                systemColorName: nil,
                baseHexString: baseHex,
                mixHexString: mixHex,
                mixFraction: fraction,
                colorSpace: colorSpace == .device ? "device" : "perceptual",
                baseColorHex: nil,
                baseSystemColorName: nil,
                intensity: nil
            )

        case .colorWithIntensity(let baseColor, let intensity):
            // Check if base color is a system color
            if let systemColorName = Self.systemColorName(for: baseColor) {
                return NamedColorData(
                    name: name,
                    id: id,
                    encoding: .colorWithIntensity,
                    hexString: nil,
                    systemColorName: nil,
                    baseHexString: nil,
                    mixHexString: nil,
                    mixFraction: nil,
                    colorSpace: nil,
                    baseColorHex: nil,
                    baseSystemColorName: systemColorName,
                    intensity: intensity
                )
            } else {
                return NamedColorData(
                    name: name,
                    id: id,
                    encoding: .colorWithIntensity,
                    hexString: nil,
                    systemColorName: nil,
                    baseHexString: nil,
                    mixHexString: nil,
                    mixFraction: nil,
                    colorSpace: nil,
                    baseColorHex: baseColor.asHexString(),
                    baseSystemColorName: nil,
                    intensity: intensity
                )
            }
        }
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
