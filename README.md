# ColorKit

**ColorKit** is a lightweight Swift package for managing colors in SwiftUI and UIKit/AppKit. It provides utilities for creating colors from hexadecimal strings, extracting color components, calculating luminance, and working with named color sets.

## Features

- Initialize `Color`, `UIColor`, or `NSColor` from hex strings.
- Extract RGBA components from colors.
- Compute luminance from a color.
- Manage and decode named colors with `NamedColor`.

## Installation

Add ColorKit to your project using Swift Package Manager:

```swift
https://github.com/ironcook67/ColorKit.git
```

## Usage

### Create a Color from a Hex String

```swift
import ColorKit
import SwiftUI

let color = Color(hexString: "#FF5733") // RGB
let colorWithAlpha = Color(hexString: "#FF5733CC") // RGBA
```

### UIColor / NSColor Extensions

```swift
let uiColor = UIColor.red
let luminance = uiColor.luminance()
let rgba = uiColor.rgba()

let nsColor = NSColor.green
let nsLuminance = nsColor.luminance()
let nsRgba = nsColor.rgba()
```

### Named Colors

```swift
let namedColor = NamedColor(name: "Ocean Blue", hex: "#1CA9C9")
let swiftUIColor = namedColor.color
```

### Named Colors from JSON

Load and decode your own list of named colors:

```swift
let json = """
[
    { "name": "Sky Blue", "hex": "#87CEEB" },
    { "name": "Sunset Orange", "hex": "#FD5E53" }
]
"""
let namedColors = try JSONDecoder().decode([NamedColor].self, from: Data(json.utf8))
```
### License

MIT License.

Copyright (c) 2025 Chon Torres.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

