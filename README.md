# ColorKit

**ColorKit** is a powerful Swift Package for advanced color management in SwiftUI applications. ColorKit provides comprehensive color utilities, named color management, intelligent JSON serialization, and seamless cross-platform support.

## Features

✨ **Named Color Management** - Create and manage collections of named colors with unique identifiers  
🎨 **Advanced Color Creation** - Multiple initialization methods including hex strings, color mixing, and intensity levels  
🔄 **Intelligent JSON Serialization** - Smart Codable support that preserves color creation methods and system color behavior  
🎯 **System Color Preservation** - Maintains dynamic behavior of system colors during serialization  
📱 **Cross-Platform** - Works seamlessly on iOS, macOS, tvOS, and watchOS  
🔧 **Color Utilities** - Hex conversion, luminance calculation, adaptive text colors, and RGBA extraction  
🎛️ **Color Mixing** - Advanced color blending with support for different color spaces  
💫 **Intensity Levels** - Predefined opacity levels for consistent design systems  

## Installation

### Swift Package Manager

Add ColorKit to your project using Xcode:

1. Open your project in Xcode
2. Go to **File** → **Add Package Dependencies**
3. Enter the repository URL: `https://github.com/ironcook67/ColorKit`
4. Click **Add Package**

Or add it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/ironcook67/ColorKit", from: "1.1.1")
]
```

## Quick Start

```swift
import SwiftUI
import ColorKit

struct ContentView: View {
    let colors = [
        NamedColor("Ocean Blue", hexString: "#006994"),
        NamedColor("Sunset Blend", color: .orange, with: .red, by: 0.3),
        NamedColor("Faded Purple", color: .purple, intensity: .tertiary),
        NamedColor("System Accent", color: .blue) // Preserves system color behavior
    ]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(colors, id: \.id) { namedColor in
                RoundedRectangle(cornerRadius: 8)
                    .fill(namedColor.color)
                    .frame(height: 60)
                    .overlay(
                        Text(namedColor.name)
                            .foregroundColor(namedColor.color.adaptedTextColor())
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    )
            }
        }
        .padding()
    }
}
```

## Core Components

### NamedColor

The heart of ColorKit - represents a color with metadata and intelligent serialization support.

```swift
// Create from hex string
let redColor = NamedColor("Cherry Red", hexString: "#DC143C")

// Create from SwiftUI Color (automatically detects system colors)
let systemBlue = NamedColor("System Blue", color: .blue)

// Create with intensity (opacity levels)
let fadedGreen = NamedColor("Faded Green", color: .green, intensity: .secondary)

// Create by mixing colors with different color spaces
let sunset = NamedColor("Sunset", color: .orange, with: .red, by: 0.3, in: .perceptual)
```

### ColorIntensity

Enum for consistent opacity levels across your design system:

```swift
public enum ColorIntensity: String, Codable, CaseIterable {
    case primary    // 1.0 opacity - Full intensity
    case secondary  // 0.8 opacity - Slightly reduced
    case tertiary   // 0.6 opacity - Medium intensity
    case quaternary // 0.4 opacity - Low intensity
    case quinary    // 0.2 opacity - Very subtle
}

// Usage
let subtleAccent = NamedColor("Subtle Accent", color: .accentColor, intensity: .quaternary)
```

## Color Creation Methods

### From Hex Strings

```swift
// Standard 6-character hex format
let crimson = NamedColor("Crimson", hexString: "#DC143C")

// 8-character hex with alpha channel
let semiTransparent = NamedColor("Semi Blue", hexString: "#0066CC80")

// Error handling - invalid hex automatically becomes clear color
let invalid = NamedColor("Invalid", hexString: "not-a-hex") // Results in Color.clear
```

### Advanced Color Mixing

```swift
// Mix colors with specified fraction and color space
let purple = NamedColor("Custom Purple", 
                       color: .red, 
                       with: .blue, 
                       by: 0.5, 
                       in: .perceptual)

// Enhanced static method for explicit mixing
let lavender = NamedColor.mixedColor("Lavender",
                                   baseColor: .purple,
                                   mixColor: .white,
                                   fraction: 0.7,
                                   colorSpace: .device)
```

### Intensity-Based Colors

```swift
// Apply predefined intensity levels
let subtleRed = NamedColor("Subtle Red", color: .red, intensity: .quaternary)

// Enhanced static method that preserves encoding information
let mutedBlue = NamedColor.colorWithIntensity("Muted Blue",
                                            baseColor: .blue,
                                            intensity: .quinary)
```

## Color Extensions

ColorKit extends SwiftUI's `Color` with powerful utilities:

### Hex Conversion

```swift
// Create Color from hex string
let color = Color(hexString: "#FF5733")

// Convert Color to hex representations
let hexString = color.asHexString()           // "#FF5733"
let hexWithAlpha = color.asHexStringWithAlpha() // "#FF5733FF"
```

### Luminance and Contrast Analysis

```swift
// Calculate relative luminance (0.0 to 1.0)
let luminance = color.luminance()

// Determine if color is light or dark
let isLight = color.isLight()

// Get optimal contrasting text color (black or white)
let textColor = color.adaptedTextColor()
```

### Color Component Access

```swift
// Extract RGBA components as Double tuple
let (red, green, blue, alpha) = color.asTuple()

// Example: red = 0.8, green = 0.2, blue = 0.4, alpha = 1.0
```

## Intelligent JSON Serialization

ColorKit provides sophisticated JSON serialization that preserves the creation method and advantages of different color types:

### Encoding Strategies

ColorKit automatically chooses the optimal encoding strategy based on how colors were created:

- **System Colors**: Saved by name to maintain dynamic appearance behavior across light/dark modes
- **Hex Colors**: Saved as hex strings for precise custom colors  
- **Mixed Colors**: Preserves base colors, mixing ratios, and color space information
- **Intensity Colors**: Preserves base color and intensity level for consistent design systems

### Serialization Example

```swift
// Create diverse color collection
let colorPalette = [
    NamedColor("System Red", color: .red),           // Encoded as system color
    NamedColor("Brand Blue", hexString: "#0066CC"),  // Encoded as hex string
    NamedColor("Warm Sunset", color: .orange, with: .red, by: 0.4), // Encoded as mixed color
    NamedColor("Subtle Green", color: .green, intensity: .tertiary)  // Encoded with intensity
]

// Export to JSON with pretty formatting
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let jsonData = try encoder.encode(colorPalette)

// Import from JSON - fully reconstructs original color creation methods
let decoder = JSONDecoder()
let restoredPalette = try decoder.decode([NamedColor].self, from: jsonData)
```

### JSON Structure Examples

**System Color:**
```json
{
  "data": {
    "name": "System Red",
    "id": "System Red",
    "encoding": "systemColor",
    "systemColorName": "red"
  }
}
```

**Mixed Color:**
```json
{
  "data": {
    "name": "Warm Sunset",
    "id": "Warm Sunset",
    "encoding": "mixedColors",
    "baseHexString": "#FF8000",
    "mixHexString": "#FF0000",
    "mixFraction": 0.4,
    "colorSpace": "perceptual"
  }
}
```

**Intensity Color:**
```json
{
  "data": {
    "name": "Subtle Green",
    "id": "Subtle Green",
    "encoding": "colorWithIntensity",
    "baseSystemColorName": "green",
    "intensity": "tertiary"
  }
}
```

## Predefined Color Collection

ColorKit includes a comprehensive collection of carefully curated named colors:

```swift
// Access the example color
let example = NamedColor.example

// Access the full predefined collection (46 colors)
let allPredefined = NamedColor.namedColors

// Examples from the collection:
// Grayscale: Licorice, Tungsten, Steel, Silver, Snow
// Vibrant: Maraschino, Tangerine, Lime, Turquoise, Magenta
// Pastels: Salmon, Cantaloupe, Honeydew, Lavender, Bubblegum
```

## Error Handling and Robustness

ColorKit handles edge cases gracefully:

- **Invalid Hex Strings**: Automatically fallback to `Color.clear` with debug logging
- **JSON Decoding Errors**: Descriptive error messages for debugging and recovery
- **Missing Data**: Graceful degradation with sensible defaults
- **Debug Logging**: Console warnings in debug builds for invalid operations

## Advanced Usage Patterns

### Building a Color Palette Manager

```swift
@MainActor
class ColorPalette: ObservableObject {
    @Published var colors: [NamedColor] = []
    
    func addColor(_ color: NamedColor) {
        // Prevent duplicates based on actual color values
        let newTuple = color.color.asTuple()
        let isDuplicate = colors.contains { existing in
            let existingTuple = existing.color.asTuple()
            return abs(newTuple.red - existingTuple.red) < 0.001 &&
                   abs(newTuple.green - existingTuple.green) < 0.001 &&
                   abs(newTuple.blue - existingTuple.blue) < 0.001 &&
                   abs(newTuple.alpha - existingTuple.alpha) < 0.001
        }
        
        if !isDuplicate {
            colors.append(color)
        }
    }
    
    func exportToJSON() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(colors)
    }
    
    func importFromJSON(_ data: Data) throws {
        let decoder = JSONDecoder()
        let importedColors = try decoder.decode([NamedColor].self, from: data)
        colors = importedColors
    }
}
```

### Working with Different Color Spaces

```swift
// Compare mixing in different color spaces
let deviceSpaceMix = NamedColor("Device Mix",
                              color: .orange,
                              with: .purple,
                              by: 0.5,
                              in: .device)

let perceptualSpaceMix = NamedColor("Perceptual Mix",
                                  color: .orange,
                                  with: .purple,
                                  by: 0.5,
                                  in: .perceptual)
```

### Design System Integration

```swift
extension NamedColor {
    // Brand color definitions
    static let brandPrimary = NamedColor("Brand Primary", hexString: "#007AFF")
    static let brandSecondary = NamedColor("Brand Secondary", hexString: "#FF9500")
    
    // Intensity variants for consistent design
    static let primarySubtle = NamedColor.colorWithIntensity("Primary Subtle", 
                                                           baseColor: .blue, 
                                                           intensity: .tertiary)
    static let secondarySubtle = NamedColor.colorWithIntensity("Secondary Subtle", 
                                                             baseColor: .orange, 
                                                             intensity: .tertiary)
}
```

## Platform Support

| Platform | Minimum Version | Features |
|----------|----------------|----------|
| iOS      | 14.0+          | Full support including UIColor utilities |
| macOS    | 11.0+          | Full support including NSColor utilities |
| tvOS     | 14.0+          | Complete color management |
| watchOS  | 7.0+           | Optimized for watch interfaces |

## Performance Considerations

ColorKit is designed for efficiency:

- **Lightweight**: Minimal memory footprint with lazy color evaluation
- **Fast**: Optimized hex parsing and color space conversions
- **Smart Encoding**: Only stores necessary data for each color type
- **Thread Safe**: All types conform to `Sendable` for concurrent environments

## Documentation

Full API documentation is available through DocC:

1. Open your project in Xcode
2. Select **Product** → **Build Documentation**
3. Access through **Window** → **Developer Documentation**

The documentation includes comprehensive guides, code examples, and API reference for all public interfaces.

## What's New in Version 1.1.1

### Enhanced JSON Serialization
- **Intelligent Encoding**: Automatic detection of optimal encoding strategy for each color
- **System Color Preservation**: System colors maintain their dynamic behavior across serialization
- **Mixed Color Support**: Full preservation of color mixing parameters and color spaces
- **Intensity Preservation**: Maintains intensity levels and base color information

### Improved API Design
- **Enhanced Initializers**: New static methods for explicit creation patterns
- **Better Error Handling**: More descriptive error messages and graceful fallbacks
- **Cross-Platform Utilities**: Unified color utilities across all supported platforms

### Developer Experience
- **Comprehensive Documentation**: Full DocC documentation with examples
- **Debug Support**: Enhanced logging and error reporting in debug builds
- **Thread Safety**: Full `Sendable` conformance for modern Swift concurrency

## Contributing

We welcome contributions! Please feel free to submit issues, feature requests, or pull requests. Make sure to:

- Follow the existing code style and documentation patterns
- Include tests for new features
- Update documentation for API changes
- Ensure cross-platform compatibility

## License

ColorKit is available under the MIT License. See the LICENSE file for more information.

---

**ColorKit v1.1.1** - Advanced color management for modern SwiftUI applications  
Made with ❤️ for the Swift community by Chon Torres
