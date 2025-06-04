//
//  Color+Ext.swift
//  ColorLab
//
//  Created by Chon Torres on 2/26/25.
//

#if os(macOS)
import AppKit
#endif // macOS
import SwiftUI

public extension Color {
    /// - Create a SwiftUI Color View using a numeric value for the rgb values.:
    ///   - hex:  RGB value in the format 0xRRGGBB
    ///   - alpha: Opacity value from 0.0 to 1.0. Default is 1.0.
    init(hex: UInt64, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }

    /// Initializes a `Color` from a hexadecimal string in the formats "#RRGGBB" or "#RRGGBBAA".
    /// - Parameter hexString: A string in hexadecimal format, starting with "#".
    init?(hexString: String) {
        let cleanedHex = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        guard cleanedHex.hasPrefix("#") else { return nil }

        let hex = String(cleanedHex.dropFirst())
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0

        guard scanner.scanHexInt64(&hexNumber) else { return nil }

        switch hex.count {
        case 6: // RRGGBB
            let r = Double((hexNumber & 0xFF0000) >> 16) / 255
            let g = Double((hexNumber & 0x00FF00) >> 8) / 255
            let b = Double(hexNumber & 0x0000FF) / 255
            self.init(red: r, green: g, blue: b)
        case 8: // RRGGBBAA
            let r = Double((hexNumber & 0xFF000000) >> 24) / 255
            let g = Double((hexNumber & 0x00FF0000) >> 16) / 255
            let b = Double((hexNumber & 0x0000FF00) >> 8) / 255
            let a = Double(hexNumber & 0x000000FF) / 255
            self.init(red: r, green: g, blue: b, opacity: a)
        default:
            return nil
        }
    }

    /// Convert a Color to a hex string in the format "#RRGGBB"
    /// - Returns: A string in the format "#RRGGBB"
    func asHexString() -> String {
#if os(macOS)
        let nsColor = NSColor(self)
        let rgba = nsColor.rgba()
#else
        let uiColor = UIColor(self)
        let rgba = uiColor.rgba()
#endif // macOS

        let redHex = componentToHexString(rgba.red)
        let greenHex = componentToHexString(rgba.green)
        let blueHex = componentToHexString(rgba.blue)

        return "#" + redHex + greenHex + blueHex
    }

    /// Convert a Color to a hex string in the format "#RRGGBBAA"
    /// - Returns: A string in the format "#RRGGBBAA"
    func asHexStringWithAlpha() -> String {
#if os(macOS)
        let nsColor = NSColor(self)
        let rgba = nsColor.rgba()
#else
        let uiColor = UIColor(self)
        let rgba = uiColor.rgba()
#endif // macOS

        let redHex = componentToHexString(rgba.red)
        let greenHex = componentToHexString(rgba.green)
        let blueHex = componentToHexString(rgba.blue)
        let alphaHex = componentToHexString(rgba.alpha)

        return "#" + redHex + greenHex + blueHex + alphaHex
    }

    /// Return a tuple with rgba as Ints ranging from 0 to 1.0
    /// - Returns: A tuple with the red, green, blue, and alpha values.
    func asTuple() -> (red: Double, green: Double, blue: Double, alpha: Double) {
#if os(macOS)
        let nsColor = NSColor(self)
        return nsColor.rgba()
#else
        let uiColor = UIColor(self)
        return uiColor.rgba()
#endif // macOS
    }

    /// Methods to calculate the luminance of a color and pick white or black depending on the contrast.
    /// - Returns: A Double representing the luminance of the color as a value between 0 and 1.0.
    func luminance() -> Double {
#if os(macOS)
        NSColor(self).luminance()
#else
        UIColor(self).luminance()
#endif
    }
    
    /// Description: Determins if the color is light or dark based on its luminance.
    /// - Returns: A Boolean value indicating whether the color is light (true) or dark (false).
    func isLight() -> Bool {
        luminance() > 0.5
    }

    /// Description: Returns a contrasting text color based on the luminance of the color.
    /// - Returns: A SwiftUI Color that is either black or white, depending on the luminance of the color to maximize contrast.
    func adaptedTextColor() -> Color {
        isLight() ? Color.black : Color.white
    }

    // Take a rgba component between 0 and 1.0 and convert to a 8-bit hex string.
    private func componentToHexString(_ component: Double) -> String {
        let int = Int((component * 255).rounded())
        return String(format: "%02X", int)
    }
}

#if os(macOS)
public extension NSColor {
    /// Description: Calculate the luminance of an NSColor using the formula:
    /// Luminance = 0.2126 * R + 0.7152 * G + 0.0722 * B
    /// - Returns: A Double representing the luminance of the color as a value between 0 and 1.0.
    func luminance() -> Double {
        let rgbColor = self.usingColorSpace(.deviceRGB) ?? self
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        rgbColor.getRed(&red, green: &green, blue: &blue, alpha: nil)

        return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
    }

    func rgba() -> (red: Double, green: Double, blue: Double, alpha: Double) {
        let rgbColor = self.usingColorSpace(.deviceRGB) ?? self
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        rgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (Double(red), Double(green), Double(blue), Double(alpha))
    }
}
#else
public extension UIColor {
    /// Description: Calculate the luminance of a UIColor using the formula:
    /// Luminance = 0.2126 * R + 0.7152 * G + 0.0722 * B
    /// - Returns: A Double representing the luminance of the color as a value between 0 and 1.0.
    func luminance() -> Double {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)

        return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
    }

    func rgba() -> (red: Double, green: Double, blue: Double, alpha: Double) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}
#endif // macOS

