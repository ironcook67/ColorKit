//
//  NamedColors.swift
//  ColorLab
//
//  Created by Chon Torres on 5/11/25.
//

import SwiftUI

public struct NamedColor: Hashable, Identifiable {
    let name: String
    let color: Color

    public var id: UUID = UUID()
}
