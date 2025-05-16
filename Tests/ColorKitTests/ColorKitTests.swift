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
