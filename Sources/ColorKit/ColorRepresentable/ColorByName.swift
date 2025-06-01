//
//  NamedColor.swift
//  ColorLab
//
//  Created by Chon Torres on 5/10/25.
//

import SwiftUI

public struct ColorByName: Hashable, Sendable, ColorRepresentable {
    /// The name of the color.
    public var name: String

    /// The color represented by this instance.
    public var color: Color

    /// A unique identifier for this color.
    public var id: UUID = UUID()

    /// Initializes a NamedColor with a name and a hex string.
    public init(name: String, hexString: String) {
        self.name = name
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
    public init(name: String, color: Color) {
        self.name = name
        self.color = color
    }
}

public extension ColorByName {
    static let example = ColorByName(name: "Example", hexString: "#FF5733")

    static let namedColors: [ColorByName] = [
        ColorByName(name: "Licorice", hexString: "#000000"),
        ColorByName(name: "Lead", hexString: "#191919"),
        ColorByName(name: "Tungsten", hexString: "#333333"),
        ColorByName(name: "Iron", hexString: "#4c4c4c"),
        ColorByName(name: "Steel", hexString: "#666666"),
        ColorByName(name: "Tin", hexString: "#7f7f7f"),
        ColorByName(name: "Nickel", hexString: "#808080"),
        ColorByName(name: "Aluminum", hexString: "#999999"),
        ColorByName(name: "Magnesium", hexString: "#b3b3b3"),
        ColorByName(name: "Silver", hexString: "#cccccc"),
        ColorByName(name: "Mercury", hexString: "#e6e6e6"),
        ColorByName(name: "Snow", hexString: "#ffffff"),
        ColorByName(name: "Cayenne", hexString: "#800000"),
        ColorByName(name: "Mocha", hexString: "#804000"),
        ColorByName(name: "Asparagus", hexString: "#808000"),
        ColorByName(name: "Fern", hexString: "#408000"),
        ColorByName(name: "Clover", hexString: "#008000"),
        ColorByName(name: "Moss", hexString: "#008040"),
        ColorByName(name: "Teal", hexString: "#008080"),
        ColorByName(name: "Ocean", hexString: "#004080"),
        ColorByName(name: "Midnight", hexString: "#000080"),
        ColorByName(name: "Eggplant", hexString: "#400080"),
        ColorByName(name: "Plum", hexString: "#800080"),
        ColorByName(name: "Maroon", hexString: "#800040"),
        ColorByName(name: "Maraschino", hexString: "#ff0000"),
        ColorByName(name: "Tangerine", hexString: "#ff8000"),
        ColorByName(name: "Lemon", hexString: "#ffff00"),
        ColorByName(name: "Lime", hexString: "#80ff00"),
        ColorByName(name: "Spring", hexString: "#00ff00"),
        ColorByName(name: "Sea Foam", hexString: "#00ff80"),
        ColorByName(name: "Turquoise", hexString: "#00ffff"),
        ColorByName(name: "Aqua", hexString: "#0080ff"),
        ColorByName(name: "Blueberry", hexString: "#0000ff"),
        ColorByName(name: "Grape", hexString: "#8000ff"),
        ColorByName(name: "Magenta", hexString: "#ff00ff"),
        ColorByName(name: "Strawberry", hexString: "#ff0080"),
        ColorByName(name: "Salmon", hexString: "#ff6666"),
        ColorByName(name: "Cantaloupe", hexString: "#ffcc66"),
        ColorByName(name: "Banana", hexString: "#ffff66"),
        ColorByName(name: "Honeydew", hexString: "#ccff66"),
        ColorByName(name: "Flora", hexString: "#66ff66"),
        ColorByName(name: "Spindrift", hexString: "#66ffcc"),
        ColorByName(name: "Ice", hexString: "#66ffff"),
        ColorByName(name: "Sky", hexString: "#66ccff"),
        ColorByName(name: "Orchid", hexString: "#6666ff"),
        ColorByName(name: "Lavender", hexString: "#cc66ff"),
        ColorByName(name: "Bubblegum", hexString: "#ff66ff"),
        ColorByName(name: "Carnation", hexString: "#ff6fcf"),
    ]
}
