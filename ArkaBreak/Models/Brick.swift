//
//  ArkaBreak
//  Created by M on 19/04/2025.

//  Fichier Brick.swift

import SwiftUI

struct Brick: Identifiable {
    let id = UUID()
    var rect: CGRect
    var hitsLeft: Int
    var color: Color
    var isBoss: Bool = false
}
