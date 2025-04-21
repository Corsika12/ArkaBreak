//
//  ArkaBreak
//  Created by M on 19/04/2025.

//  Fichier gameModel.swift


import SwiftUI

// MARK: - BALL Model
struct Ball: Identifiable {
    let id = UUID()
    var pos: CGPoint
    var vel: CGVector
    static let radius: CGFloat = 8
}



// MARK: - Brick Model
struct Brick: Identifiable {
    let id = UUID()
    var rect: CGRect
    var hitsLeft: Int
    var color: Color
    var isBoss: Bool = false
}
