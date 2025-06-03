//
//  NamedColorCodableTests.swift
//  ColorLabTests
//
//  Created by Chon Torres on 6/3/25.
//

import Testing
import SwiftUI
@testable import ColorKit

/// Test suite for NamedColor Codable conformance
struct NamedColorCodableTests {

    // MARK: - Helper Functions

    /// Compares two Double values with a default tolerance of 0.001
    /// - Parameters:
    ///   - lhs: Left-hand side value
    ///   - rhs: Right-hand side value
    ///   - tolerance: The tolerance for comparison (default: 0.001)
    /// - Returns: True if the values are within tolerance, false otherwise
    fileprivate func areEqual(_ lhs: Double, _ rhs: Double, tolerance: Double = 0.001) -> Bool {
        abs(lhs - rhs) < tolerance
    }

    /// Compares two color tuples for equality within tolerance
    /// - Parameters:
    ///   - color1: First color tuple
    ///   - color2: Second color tuple
    ///   - tolerance: The tolerance for comparison (default: 0.001)
    /// - Returns: True if all RGBA components are within tolerance
    fileprivate func areColorsEqual(
        _ color1: (red: Double, green: Double, blue: Double, alpha: Double),
        _ color2: (red: Double, green: Double, blue: Double, alpha: Double),
        tolerance: Double = 0.001
    ) -> Bool {
        areEqual(color1.red, color2.red, tolerance: tolerance) &&
        areEqual(color1.green, color2.green, tolerance: tolerance) &&
        areEqual(color1.blue, color2.blue, tolerance: tolerance) &&
        areEqual(color1.alpha, color2.alpha, tolerance: tolerance)
    }

    // MARK: - Hex String Encoding Tests

    @Test("Hex string color encoding and decoding")
    func testHexStringColorCoding() throws {
        // Given
        let originalColor = NamedColor("Test Red", hexString: "#FF0000")

        // When
        let encodedData = try JSONEncoder().encode(originalColor)
        let decodedColor = try JSONDecoder().decode(NamedColor.self, from: encodedData)

        // Then
        #expect(decodedColor.name == originalColor.name)
        #expect(decodedColor.id == originalColor.id)

        let originalTuple = originalColor.color.asTuple()
        let decodedTuple = decodedColor.color.asTuple()

        #expect(areColorsEqual(originalTuple, decodedTuple))
    }

    @Test("Hex string with alpha encoding and decoding")
    func testHexStringWithAlphaCoding() throws {
        // Given
        let originalColor = NamedColor("Semi-transparent Blue", hexString: "#0000FF80")

        // When
        let encodedData = try JSONEncoder().encode(originalColor)
        let decodedColor = try JSONDecoder().decode(NamedColor.self, from: encodedData)

        // Then
        #expect(decodedColor.name == originalColor.name)
        #expect(decodedColor.id == originalColor.id)

        let originalTuple = originalColor.color.asTuple()
        let decodedTuple = decodedColor.color.asTuple()

        #expect(areEqual(originalTuple.red, decodedTuple.red))
        #expect(areEqual(originalTuple.green, decodedTuple.green))
        #expect(areEqual(originalTuple.blue, decodedTuple.blue))
        #expect(areEqual(originalTuple.alpha, decodedTuple.alpha, tolerance: 0.01)) // Slightly higher tolerance for alpha
    }

    @Test("Invalid hex string handling")
    func testInvalidHexStringHandling() throws {
        // Given
        let originalColor = NamedColor("Invalid Color", hexString: "invalid")

        // When
        let encodedData = try JSONEncoder().encode(originalColor)
        let decodedColor = try JSONDecoder().decode(NamedColor.self, from: encodedData)

        // Then
        #expect(decodedColor.name == originalColor.name)
        #expect(decodedColor.id == originalColor.id)

        // Should decode to clear color for invalid hex
        let decodedTuple = decodedColor.color.asTuple()
        let clearTuple = Color.clear.asTuple()

        #expect(areColorsEqual(decodedTuple, clearTuple))
    }

    // MARK: - System Color Encoding Tests

    @Test("System color encoding and decoding", arguments: [
        ("Primary", Color.primary),
        ("Secondary", Color.secondary),
        ("Accent", Color.accentColor),
        ("Red", Color.red),
        ("Green", Color.green),
        ("Blue", Color.blue),
        ("Orange", Color.orange),
        ("Yellow", Color.yellow),
        ("Pink", Color.pink),
        ("Purple", Color.purple),
        ("Black", Color.black),
        ("White", Color.white),
        ("Gray", Color.gray),
        ("Clear", Color.clear)
    ])
    func testSystemColorCoding(name: String, systemColor: Color) throws {
        // Given
        let originalColor = NamedColor(name, color: systemColor)

        // When
        let encodedData = try JSONEncoder().encode(originalColor)
        let decodedColor = try JSONDecoder().decode(NamedColor.self, from: encodedData)

        // Then
        #expect(decodedColor.name == originalColor.name)
        #expect(decodedColor.id == originalColor.id)

        let originalTuple = originalColor.color.asTuple()
        let decodedTuple = decodedColor.color.asTuple()

        #expect(areColorsEqual(originalTuple, decodedTuple))
    }

    // MARK: - Color Intensity Encoding Tests

    @Test("Color with intensity encoding and decoding", arguments: ColorIntensity.allCases)
    func testColorWithIntensityCoding(intensity: ColorIntensity) throws {
        // Given
        let baseColor = Color.blue
        let originalColor = NamedColor("Blue with Intensity", color: baseColor, intensity: intensity)

        // When
        let encodedData = try JSONEncoder().encode(originalColor)

        print("TDB: Encoded Data: \(String(data: encodedData, encoding: .utf8) ?? "nil")")

        let decodedColor = try JSONDecoder().decode(NamedColor.self, from: encodedData)

        print("TDB: Decoded Color: \(decodedColor)")

        // Then
        #expect(decodedColor.name == originalColor.name)
        #expect(decodedColor.id == originalColor.id)

        let originalTuple = originalColor.color.asTuple()
        let decodedTuple = decodedColor.color.asTuple()

        #expect(areColorsEqual(originalTuple, decodedTuple))
    }

    @Test("System color with intensity encoding and decoding")
    func testSystemColorWithIntensityCoding() throws {
        // Given
        let originalColor = NamedColor("Faded Primary", color: Color.primary, intensity: .tertiary)

        // When
        let encodedData = try JSONEncoder().encode(originalColor)
        let decodedColor = try JSONDecoder().decode(NamedColor.self, from: encodedData)

        // Then
        #expect(decodedColor.name == originalColor.name)
        #expect(decodedColor.id == originalColor.id)

        let originalTuple = originalColor.color.asTuple()
        let decodedTuple = decodedColor.color.asTuple()

        #expect(areColorsEqual(originalTuple, decodedTuple))
    }

    // MARK: - Mixed Color Encoding Tests

    @Test("Mixed colors encoding and decoding with perceptual color space")
    func testMixedColorsPerceptualCoding() throws {
        // Given
        let baseColor = Color.red
        let mixColor = Color.blue
        let fraction = 0.3
        let originalColor = NamedColor("Purple Mix", color: baseColor, with: mixColor, by: fraction, in: .perceptual)

        // When
        let encodedData = try JSONEncoder().encode(originalColor)
        let decodedColor = try JSONDecoder().decode(NamedColor.self, from: encodedData)

        // Then
        #expect(decodedColor.name == originalColor.name)
        #expect(decodedColor.id == originalColor.id)

        let originalTuple = originalColor.color.asTuple()
        let decodedTuple = decodedColor.color.asTuple()

        // Mixed colors may have slight variations due to color space calculations
        #expect(areColorsEqual(originalTuple, decodedTuple, tolerance: 0.01))
    }

    @Test("Mixed colors encoding and decoding with device color space")
    func testMixedColorsDeviceCoding() throws {
        // Given
        let baseColor = Color.green
        let mixColor = Color.yellow
        let fraction = 0.7
        let originalColor = NamedColor("Lime Mix", color: baseColor, with: mixColor, by: fraction, in: .device)

        // When
        let encodedData = try JSONEncoder().encode(originalColor)
        let decodedColor = try JSONDecoder().decode(NamedColor.self, from: encodedData)

        // Then
        #expect(decodedColor.name == originalColor.name)
        #expect(decodedColor.id == originalColor.id)

        let originalTuple = originalColor.color.asTuple()
        let decodedTuple = decodedColor.color.asTuple()

        // Mixed colors may have slight variations due to color space calculations
        #expect(areColorsEqual(originalTuple, decodedTuple, tolerance: 0.01))
    }

    // MARK: - Enhanced Static Methods Tests

    @Test("Enhanced mixedColor static method")
    func testEnhancedMixedColorMethod() throws {
        // Given
        let originalColor = NamedColor.mixedColor(
            "Enhanced Mix",
            baseColor: Color.orange,
            mixColor: Color.pink,
            fraction: 0.5,
            colorSpace: .perceptual
        )

        // When
        let encodedData = try JSONEncoder().encode(originalColor)
        let decodedColor = try JSONDecoder().decode(NamedColor.self, from: encodedData)

        // Then
        #expect(decodedColor.name == originalColor.name)
        #expect(decodedColor.id == originalColor.id)

        let originalTuple = originalColor.color.asTuple()
        let decodedTuple = decodedColor.color.asTuple()

        #expect(areColorsEqual(originalTuple, decodedTuple, tolerance: 0.01))
    }

    @Test("Enhanced colorWithIntensity static method")
    func testEnhancedColorWithIntensityMethod() throws {
        // Given
        let originalColor = NamedColor.colorWithIntensity(
            "Enhanced Intensity",
            baseColor: Color.purple,
            intensity: .quaternary
        )

        // When
        let encodedData = try JSONEncoder().encode(originalColor)
        let decodedColor = try JSONDecoder().decode(NamedColor.self, from: encodedData)

        // Then
        #expect(decodedColor.name == originalColor.name)
        #expect(decodedColor.id == originalColor.id)

        let originalTuple = originalColor.color.asTuple()
        let decodedTuple = decodedColor.color.asTuple()

        #expect(areColorsEqual(originalTuple, decodedTuple))
    }

    // MARK: - Predefined NamedColors Tests

    @Test("Predefined named colors encoding and decoding")
    func testPredefinedNamedColorsCoding() throws {
        // Test a selection of predefined colors
        let testColors = [
            NamedColor.namedColors[0], // Licorice
            NamedColor.namedColors[11], // Snow
            NamedColor.namedColors[24], // Maraschino
            NamedColor.namedColors[35], // Strawberry
            NamedColor.example
        ]

        for originalColor in testColors {
            // When
            let encodedData = try JSONEncoder().encode(originalColor)
            let decodedColor = try JSONDecoder().decode(NamedColor.self, from: encodedData)

            // Then
            #expect(decodedColor.name == originalColor.name)
            #expect(decodedColor.id == originalColor.id)

            let originalTuple = originalColor.color.asTuple()
            let decodedTuple = decodedColor.color.asTuple()

            #expect(areColorsEqual(originalTuple, decodedTuple))
        }
    }

    // MARK: - Array Encoding Tests

    @Test("Array of NamedColors encoding and decoding")
    func testNamedColorArrayCoding() throws {
        // Given
        let originalColors = [
            NamedColor("Red", hexString: "#FF0000"),
            NamedColor("System Blue", color: Color.blue),
            NamedColor("Faded Green", color: Color.green, intensity: .secondary),
            NamedColor("Mixed Orange", color: Color.red, with: Color.yellow, by: 0.5)
        ]

        // When
        let encodedData = try JSONEncoder().encode(originalColors)
        let decodedColors = try JSONDecoder().decode([NamedColor].self, from: encodedData)

        // Then
        #expect(decodedColors.count == originalColors.count)

        for (original, decoded) in zip(originalColors, decodedColors) {
            #expect(decoded.name == original.name)
            #expect(decoded.id == original.id)

            let originalTuple = original.color.asTuple()
            let decodedTuple = decoded.color.asTuple()

            #expect(areColorsEqual(originalTuple, decodedTuple, tolerance: 0.01))
        }
    }

    // MARK: - Error Handling Tests

    @Test("Decoding with corrupted data throws appropriate error")
    func testCorruptedDataDecoding() throws {
        // Given
        let corruptedJSON = """
        {
            "data": {
                "name": "Test",
                "id": "12345678-1234-1234-1234-123456789012",
                "encoding": "hexString"
            }
        }
        """.data(using: .utf8)!

        // When/Then
        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder().decode(NamedColor.self, from: corruptedJSON)
        }
    }

    @Test("Decoding with invalid encoding type throws appropriate error")
    func testInvalidEncodingTypeDecoding() throws {
        // Given
        let invalidJSON = """
        {
            "data": {
                "name": "Test",
                "id": "12345678-1234-1234-1234-123456789012",
                "encoding": "invalidType",
                "hexString": "#FF0000"
            }
        }
        """.data(using: .utf8)!

        // When/Then
        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder().decode(NamedColor.self, from: invalidJSON)
        }
    }

    // MARK: - JSON Structure Validation Tests

    @Test("Encoded JSON contains expected structure for hex color")
    func testEncodedJSONStructureForHexColor() throws {
        // Given
        let color = NamedColor("Test", hexString: "#FF0000")

        // When
        let encodedData = try JSONEncoder().encode(color)
        let jsonObject = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]
        let dataObject = jsonObject?["data"] as? [String: Any]

        // Then
        #expect(dataObject != nil)
        #expect(dataObject?["name"] as? String == "Test")
        #expect(dataObject?["encoding"] as? String == "hexString")
        #expect(dataObject?["hexString"] as? String == "#FF0000")
        #expect(dataObject?["systemColorName"] == nil)
    }

    @Test("Encoded JSON contains expected structure for system color")
    func testEncodedJSONStructureForSystemColor() throws {
        // Given
        let color = NamedColor("Primary", color: Color.primary)

        // When
        let encodedData = try JSONEncoder().encode(color)
        let jsonObject = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]
        let dataObject = jsonObject?["data"] as? [String: Any]

        // Then
        #expect(dataObject != nil)
        #expect(dataObject?["name"] as? String == "Primary")
        #expect(dataObject?["encoding"] as? String == "systemColor")
        #expect(dataObject?["systemColorName"] as? String == "primary")
        #expect(dataObject?["hexString"] == nil)
    }
}
