import Testing
import SwiftUI
@testable import ColorKit

final class ColorKitTests {
    @Test
    func testInitWithHex() {
        let color = Color(hex: 0xFF0000)
        let components = color.asTuple()
        #expect(components.red == 1.0)
        #expect(components.green == 0.0)
        #expect(components.blue == 0.0)
        #expect(components.alpha == 1.0)
    }

    @Test
    func testInitWithHexStringWithoutAlpha() {
        let color = Color(hexString: "#00FF00")
        #expect(color != nil)
        let components = color!.asTuple()
        #expect(components.red == 0.0)
        #expect(components.green == 1.0)
        #expect(components.blue == 0.0)
        #expect(components.alpha == 1.0)
    }

    @Test
    func testInitWithHexStringWithAlpha() {
        let color = Color(hexString: "#0000FF80")
        #expect(color != nil)
        let components = color!.asTuple()
        #expect(components.red == 0.0)
        #expect(components.green == 0.0)
        #expect(components.blue == 1.0)
        #expect(isApproximatelyEqual(components.alpha, Double(0x80)/255) )
    }

    @Test
    func testAsHexString() {
        let color = Color(hex: 0x123456)
        let hexString = color.asHexString()
        #expect(hexString == "#123456")
    }

    @Test
    func testAsHexStringWithAlpha() {
        let color = Color(hex: 0x123456, alpha: 0.5)
        let hexString = color.asHexStringWithAlpha()
        #expect(hexString.hasPrefix("#123456"))
    }

    @Test
    func testLuminance() {
        let white = Color(hex: 0xFFFFFF)
        let black = Color(hex: 0x000000)
        #expect(white.luminance() > black.luminance())
    }

    @Test
    func testIsLight() {
        let white = Color(hex: 0xFFFFFF)
        let black = Color(hex: 0x000000)
        #expect(white.isLight())
        #expect(!black.isLight())
    }

    @Test
    func testAdaptedTextColor() {
        let light = Color(hex: 0xFFFFFF)
        let dark = Color(hex: 0x000000)
        #expect(light.adaptedTextColor() == Color.black)
        #expect(dark.adaptedTextColor() == Color.white)
    }

    @Test
    func testValidHexWithoutAlpha() {
        #expect(Color(hexString: "#FF5733") != nil, "Color should initialize with 6-digit hex")
    }

    @Test
    func testValidHexWithAlpha() {
        #expect(Color(hexString: "#FF5733CC") != nil, "Color should initialize with 8-digit hex including alpha")
    }

    @Test
    func testInvalidHexPrefix() {
        #expect(Color(hexString: "FF5733") == nil, "Color should not initialize without '#' prefix")
    }

    @Test
    func testInvalidHexLength() {
        #expect(Color(hexString: "#FFF") == nil, "Color should not initialize with invalid hex length")
    }

    @Test
    func testNonHexCharacters() {
        #expect(Color(hexString: "#GGHHII") == nil, "Color should not initialize with non-hex characters")
    }

    @Test func testColorByName() {
        #expect(NamedColor("red", color: .red).color == .red)
        #expect(NamedColor("blue", color: .blue).color == .blue)
        #expect(NamedColor("green", color: .green).color == .green)
    }

    @Test func testColorByIntensity() {
        #expect(NamedColor(color: .red, intensity: .primary).color == Color.red.opacity(1.0))
        #expect(NamedColor(color: .red, intensity: .secondary).color == Color.red.opacity(0.8))
        #expect(NamedColor(color: .red, intensity: .tertiary).color == Color.red.opacity(0.6))
        #expect(NamedColor(color: .red, intensity: .quaternary).color == Color.red.opacity(0.4))
        #expect(NamedColor(color: .red, intensity: .quinary).color == Color.red.opacity(0.2))
    }

    @Test func testColorByMix() {
        let mix = NamedColor(color: .red, with: .blue, by: 0.5)
        let referenceColor = Color.red.mix(with: .blue, by: 0.5)
        #expect(mix.color == referenceColor, "Mix should produce the correct blended color")
    }

    @Test func testColorRepresentableName() {
        let red = NamedColor("red", color: .red)
        #expect(red.name == "red")
        #expect(red.color == .red)
    }

    @Test func testColorRepresentableIntensity() {
        let light = NamedColor("lightRed", color: .red, intensity: .quinary)
        #expect(light.name == "lightRed")
        #expect(light.color == Color.red.opacity(0.2))
    }

    @Test func testColorRepresentableMix() {
        let mix = NamedColor("Mix", color: .red, with: .green, by: 0.5)
        #expect(mix.name.contains("Mix"))
        #expect(mix.color == Color.red.mix(with: .green, by: 0.5))
    }
}

extension ColorKitTests {
    func isApproximatelyEqual(_ lhs: Double, _ rhs: Double, significantDigits: Int = 2) -> Bool {
        guard lhs != 0 && rhs != 0 else {
            return lhs == rhs
        }
        
        let scale = pow(10.0, Double(significantDigits - 1))
        let lhsScaled = round(lhs / pow(10, floor(log10(abs(lhs)))) * scale)
        let rhsScaled = round(rhs / pow(10, floor(log10(abs(rhs)))) * scale)
        
        return lhsScaled == rhsScaled
    }
}
