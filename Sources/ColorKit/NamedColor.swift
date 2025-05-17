//
//  NamedColor.swift
//  ColorLab
//
//  Created by Chon Torres on 5/10/25.
//

import SwiftUI

public struct NamedColor: Identifiable, Hashable, Sendable {
    public var name: String
    public var color: Color
    public var id: UUID = UUID()

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

    public init(name: String, color: Color) {
        self.name = name
        self.color = color
    }
}

public extension NamedColor {
    static let example = NamedColor(name: "Example", hexString: "#FF5733")
}

public extension NamedColor {
    static let namedColors: [NamedColor] = [
        NamedColor(name: "Licorice", hexString: "#000000"),
        NamedColor(name: "Lead", hexString: "#191919"),
        NamedColor(name: "Tungsten", hexString: "#333333"),
        NamedColor(name: "Iron", hexString: "#4c4c4c"),
        NamedColor(name: "Steel", hexString: "#666666"),
        NamedColor(name: "Tin", hexString: "#7f7f7f"),
        NamedColor(name: "Nickel", hexString: "#808080"),
        NamedColor(name: "Aluminum", hexString: "#999999"),
        NamedColor(name: "Magnesium", hexString: "#b3b3b3"),
        NamedColor(name: "Silver", hexString: "#cccccc"),
        NamedColor(name: "Mercury", hexString: "#e6e6e6"),
        NamedColor(name: "Snow", hexString: "#ffffff"),
        NamedColor(name: "Cayenne", hexString: "#800000"),
        NamedColor(name: "Mocha", hexString: "#804000"),
        NamedColor(name: "Asparagus", hexString: "#808000"),
        NamedColor(name: "Fern", hexString: "#408000"),
        NamedColor(name: "Clover", hexString: "#008000"),
        NamedColor(name: "Moss", hexString: "#008040"),
        NamedColor(name: "Teal", hexString: "#008080"),
        NamedColor(name: "Ocean", hexString: "#004080"),
        NamedColor(name: "Midnight", hexString: "#000080"),
        NamedColor(name: "Eggplant", hexString: "#400080"),
        NamedColor(name: "Plum", hexString: "#800080"),
        NamedColor(name: "Maroon", hexString: "#800040"),
        NamedColor(name: "Maraschino", hexString: "#ff0000"),
        NamedColor(name: "Tangerine", hexString: "#ff8000"),
        NamedColor(name: "Lemon", hexString: "#ffff00"),
        NamedColor(name: "Lime", hexString: "#80ff00"),
        NamedColor(name: "Spring", hexString: "#00ff00"),
        NamedColor(name: "Sea Foam", hexString: "#00ff80"),
        NamedColor(name: "Turquoise", hexString: "#00ffff"),
        NamedColor(name: "Aqua", hexString: "#0080ff"),
        NamedColor(name: "Blueberry", hexString: "#0000ff"),
        NamedColor(name: "Grape", hexString: "#8000ff"),
        NamedColor(name: "Magenta", hexString: "#ff00ff"),
        NamedColor(name: "Strawberry", hexString: "#ff0080"),
        NamedColor(name: "Salmon", hexString: "#ff6666"),
        NamedColor(name: "Cantaloupe", hexString: "#ffcc66"),
        NamedColor(name: "Banana", hexString: "#ffff66"),
        NamedColor(name: "Honeydew", hexString: "#ccff66"),
        NamedColor(name: "Flora", hexString: "#66ff66"),
        NamedColor(name: "Spindrift", hexString: "#66ffcc"),
        NamedColor(name: "Ice", hexString: "#66ffff"),
        NamedColor(name: "Sky", hexString: "#66ccff"),
        NamedColor(name: "Orchid", hexString: "#6666ff"),
        NamedColor(name: "Lavender", hexString: "#cc66ff"),
        NamedColor(name: "Bubblegum", hexString: "#ff66ff"),
        NamedColor(name: "Carnation", hexString: "#ff6fcf"),
    ]
}
