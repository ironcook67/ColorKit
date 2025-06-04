# ColorKit

**ColorKit** is a lightweight Swift Package for advanced color management in SwiftUI applications. ColorKit provides comprehensive color utilities, named color management, and seamless JSON serialization for color palettes.

## Features

✨ **Named Color Management** - Create and manage collections of named colors with unique identifiers  
🎨 **Advanced Color Creation** - Multiple initialization methods including hex strings, color mixing, and intensity levels  
🔄 **JSON Serialization** - Full Codable support with smart encoding strategies  
🎯 **System Color Preservation** - Maintains dynamic behavior of system colors during serialization  
📱 **Cross-Platform** - Works on iOS, macOS, tvOS, and watchOS  
🔧 **Color Utilities** - Hex conversion, luminance calculation, and adaptive text colors  

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
    .package(url: "https://github.com/yourusername/ColorKit", from: "1.1.0")
]
```

## Quick Start

```swift
import SwiftUI
import ColorKit

struct ContentView: View {
    let colors = [
        NamedColor("Ocean Blue", hexString: "#006994"),
        NamedColor("Sunset", color: .orange, with: .red, by: 0.3),
        NamedColor("Faded Purple", color: .purple, intensity: .tertiary)
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
                    )
            }
        }
    }
}
```

## Core Components

### NamedColor

The heart of ColorKit - represents a color with metadata and serialization support.

```swift
// Create from hex string
let redColor = NamedColor("Cherry Red", hexString: "#DC143C")

// Create from SwiftUI Color
let blueColor = NamedColor("System Blue", color: .blue)

// Create with intensity (opacity)
let fadedGreen = NamedColor("Faded Green", color: .green, intensity: .secondary)

// Create by mixing colors
let sunset = NamedColor("Sunset", color: .orange, with: .red, by: 0.3, in: .perceptual)
```

### ColorIntensity

Enum for consistent opacity levels across your app:

```swift
public enum ColorIntensity: String, Codable, CaseIterable {
    case primary    // 1.0 opacity
    case secondary  // 0.8 opacity
    case tertiary   // 0.6 opacity
    case quaternary // 0.4 opacity
    case quinary    // 0.2 opacity
}
```

## Color Creation Methods

### From Hex Strings

```swift
// Standard hex format
let color1 = NamedColor("Red", hexString: "#FF0000")

// With alpha channel
let color2 = NamedColor("Semi-transparent Blue", hexString: "#0000FF80")

// Error handling - invalid hex becomes clear color
let color3 = NamedColor("Invalid", hexString: "not-a-hex") // Results in clear color
```

### Color Mixing

```swift
// Mix two colors with specified fraction
let purple = NamedColor("Purple Mix", 
                       color: .red, 
                       with: .blue, 
                       by: 0.5, 
                       in: .perceptual)

// Enhanced static method
let lavender = NamedColor.mixedColor("Lavender",
                                   baseColor: .purple,
                                   mixColor: .white,
                                   fraction: 0.7,
                                   colorSpace: .device)
```

### Intensity-Based Colors

```swift
// Apply intensity to any color
let subtleRed = NamedColor("Subtle Red", color: .red, intensity: .quaternary)

// Enhanced static method preserves encoding information
let mutedBlue = NamedColor.colorWithIntensity("Muted Blue",
                                            baseColor: .blue,
                                            intensity: .quinary)
```

## Color Extensions

ColorKit extends SwiftUI's `Color` with powerful utilities:

### Hex Conversion

```swift
// Create Color from hex
let color = Color(hexString: "#FF5733")

// Convert Color to hex
let hexString = color.asHexString()        // "#FF5733"
let hexWithAlpha = color.asHexStringWithAlpha() // "#FF5733FF"
```

### Luminance and Contrast

```swift
// Calculate luminance (0.0 to 1.0)
let luminance = color.luminance()

// Determine if color is light or dark
let isLight = color.isLight()

// Get contrasting text color (black or white)
let textColor = color.adaptedTextColor()
```

### Color Components

```swift
// Get RGBA tuple
let (red, green, blue, alpha) = color.asTuple()
```

## JSON Serialization

ColorKit provides intelligent JSON serialization that preserves the advantages of different color types:

### Encoding Strategies

- **System Colors**: Saved by name to maintain dynamic behavior
- **Hex Colors**: Saved as hex strings for custom colors  
- **Mixed Colors**: Preserves base colors, mixing ratios, and color space
- **Intensity Colors**: Preserves base color and intensity level

### Usage Example

```swift
// Create colors
let colors = [
    NamedColor("System Red", color: .red),
    NamedColor("Custom Blue", hexString: "#0066CC"),
    NamedColor("Faded Green", color: .green, intensity: .tertiary)
]

// Export to JSON
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let jsonData = try encoder.encode(colors)

// Import from JSON
let decoder = JSONDecoder()
let importedColors = try decoder.decode([NamedColor].self, from: jsonData)
```

### JSON Structure Example

```json
[
  {
    "data": {
      "name": "System Red",
      "id": "12345678-1234-1234-1234-123456789012",
      "encoding": "systemColor",
      "systemColorName": "red"
    }
  },
  {
    "data": {
      "name": "Custom Blue",
      "id": "87654321-4321-4321-4321-210987654321",
      "encoding": "hexString",
      "hexString": "#0066CC"
    }
  }
]
```

## Predefined Colors

ColorKit includes a curated set of predefined colors:

```swift
// Access predefined colors
let example = NamedColor.example
let allPredefined = NamedColor.namedColors

// Some examples:
// - Licorice (#000000)
// - Snow (#FFFFFF)  
// - Maraschino (#FF0000)
// - Ocean (#004080)
// - And many more...
```

## Error Handling

ColorKit handles errors gracefully:

- **Invalid Hex Strings**: Automatically fallback to `Color.clear`
- **JSON Decoding Errors**: Descriptive error messages for debugging
- **Debug Logging**: Console warnings in debug builds for invalid operations

## Advanced Usage

### Color Palette Management

```swift
@MainActor
class ColorPalette: ObservableObject {
    @Published var colors: [NamedColor] = []
    
    func addColor(_ color: NamedColor) {
        // Avoid duplicates based on color values
        let colorTuple = color.color.asTuple()
        let isDuplicate = colors.contains { existing in
            let existingTuple = existing.color.asTuple()
            return abs(colorTuple.red - existingTuple.red) < 0.001 &&
                   abs(colorTuple.green - existingTuple.green) < 0.001 &&
                   abs(colorTuple.blue - existingTuple.blue) < 0.001 &&
                   abs(colorTuple.alpha - existingTuple.alpha) < 0.001
        }
        
        if !isDuplicate {
            colors.append(color)
        }
    }
}
```

### Custom Color Spaces

```swift
// Use different color spaces for mixing
let warmSunset = NamedColor("Warm Sunset",
                          color: .orange,
                          with: .red,
                          by: 0.4,
                          in: .device)

let coolSunset = NamedColor("Cool Sunset",
                          color: .orange,
                          with: .red,
                          by: 0.4,
                          in: .perceptual)
```

## Platform Support

| Platform | Minimum Version |
|----------|----------------|
| iOS      | 14.0+          |
| macOS    | 11.0+          |
| tvOS     | 14.0+          |
| watchOS  | 7.0+           |

## Documentation

Full documentation is available through DocC. Build documentation in Xcode:

1. Select your target
2. Go to **Product** → **Build Documentation**
3. Access through **Window** → **Developer Documentation**

## Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests for any improvements.

## License

ColorKit is available under the MIT license. See the LICENSE file for more info.

## Changelog

### Version 1.0.0
- Initial release
- Color extensions for hex conversion and utilities
- Predefined color collection
- Cross-platform support

### Version 1.1.0
- NamedColor with multiple initialization methods
- Full Codable support with intelligent encoding strategies

---
**Made with ❤️ for the SwiftUI community**

### License

MIT License.

Copyright (c) 2025 Chon Torres.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

