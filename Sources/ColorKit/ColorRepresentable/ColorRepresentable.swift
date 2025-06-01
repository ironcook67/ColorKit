//
//  ColorRepresentable.swift
//  ColorKit
//
//  Created by Chon Torres on 5/31/25.
//

import SwiftUI

public protocol ColorRepresentable: Identifiable {
    var name: String { get }
    var color: Color { get }
    var id: UUID { get }
}
