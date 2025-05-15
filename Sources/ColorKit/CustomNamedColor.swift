//
//  CustomNamedColor.swift
//  ColorLab
//
//  Created by Chon Torres on 5/10/25.
//

import SwiftUI

public protocol CustomColor {
    var name: String { set get }
    var hexString: String { set get }
    var color: Color { get }
}

public struct CustomNamedColor: Identifiable, Hashable, CustomColor, Sendable {
    public var name: String
    public var hexString: String

    public var id: UUID = UUID()

    public var color: Color {
        Color(hexString: hexString) ?? Color.clear
    }
}

public extension CustomNamedColor {
    static let example = CustomNamedColor(name: "Example", hexString: "#FF5733")
}

public extension CustomNamedColor {
    static let namedColors: [CustomNamedColor] = [
        CustomNamedColor(name: "Licorice", hexString: "#000000"),
        CustomNamedColor(name: "Lead", hexString: "#191919"),
        CustomNamedColor(name: "Tungsten", hexString: "#333333"),
        CustomNamedColor(name: "Iron", hexString: "#4c4c4c"),
        CustomNamedColor(name: "Steel", hexString: "#666666"),
        CustomNamedColor(name: "Tin", hexString: "#7f7f7f"),
        CustomNamedColor(name: "Nickel", hexString: "#808080"),
        CustomNamedColor(name: "Aluminum", hexString: "#999999"),
        CustomNamedColor(name: "Magnesium", hexString: "#b3b3b3"),
        CustomNamedColor(name: "Silver", hexString: "#cccccc"),
        CustomNamedColor(name: "Mercury", hexString: "#e6e6e6"),
        CustomNamedColor(name: "Snow", hexString: "#ffffff"),
        CustomNamedColor(name: "Cayenne", hexString: "#800000"),
        CustomNamedColor(name: "Mocha", hexString: "#804000"),
        CustomNamedColor(name: "Asparagus", hexString: "#808000"),
        CustomNamedColor(name: "Fern", hexString: "#408000"),
        CustomNamedColor(name: "Clover", hexString: "#008000"),
        CustomNamedColor(name: "Moss", hexString: "#008040"),
        CustomNamedColor(name: "Teal", hexString: "#008080"),
        CustomNamedColor(name: "Ocean", hexString: "#004080"),
        CustomNamedColor(name: "Midnight", hexString: "#000080"),
        CustomNamedColor(name: "Eggplant", hexString: "#400080"),
        CustomNamedColor(name: "Plum", hexString: "#800080"),
        CustomNamedColor(name: "Maroon", hexString: "#800040"),
        CustomNamedColor(name: "Maraschino", hexString: "#ff0000"),
        CustomNamedColor(name: "Tangerine", hexString: "#ff8000"),
        CustomNamedColor(name: "Lemon", hexString: "#ffff00"),
        CustomNamedColor(name: "Lime", hexString: "#80ff00"),
        CustomNamedColor(name: "Spring", hexString: "#00ff00"),
        CustomNamedColor(name: "Sea Foam", hexString: "#00ff80"),
        CustomNamedColor(name: "Turquoise", hexString: "#00ffff"),
        CustomNamedColor(name: "Aqua", hexString: "#0080ff"),
        CustomNamedColor(name: "Blueberry", hexString: "#0000ff"),
        CustomNamedColor(name: "Grape", hexString: "#8000ff"),
        CustomNamedColor(name: "Magenta", hexString: "#ff00ff"),
        CustomNamedColor(name: "Strawberry", hexString: "#ff0080"),
        CustomNamedColor(name: "Salmon", hexString: "#ff6666"),
        CustomNamedColor(name: "Cantaloupe", hexString: "#ffcc66"),
        CustomNamedColor(name: "Banana", hexString: "#ffff66"),
        CustomNamedColor(name: "Honeydew", hexString: "#ccff66"),
        CustomNamedColor(name: "Flora", hexString: "#66ff66"),
        CustomNamedColor(name: "Spindrift", hexString: "#66ffcc"),
        CustomNamedColor(name: "Ice", hexString: "#66ffff"),
        CustomNamedColor(name: "Sky", hexString: "#66ccff"),
        CustomNamedColor(name: "Orchid", hexString: "#6666ff"),
        CustomNamedColor(name: "Lavender", hexString: "#cc66ff"),
        CustomNamedColor(name: "Bubblegum", hexString: "#ff66ff"),
        CustomNamedColor(name: "Carnation", hexString: "#ff6fcf"),
    ]
}
