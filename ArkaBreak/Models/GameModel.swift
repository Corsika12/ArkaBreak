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
    var effect: BallEffect = .none
    static let radius: CGFloat = 8
}

enum BallEffect: String, CaseIterable, Codable {
    case none       // Pas d'effet visuel particulier
    case fire       // 🔥 Effet flamme
    case electric   // ⚡️ Effet électrique
    case smoke      // 💨 Effet fumée / brouillard
}


// MARK: - Brick Model
struct Brick: Identifiable {
    let id = UUID()
    var rect: CGRect
    var hitsLeft: Int
    var color: Color
    var isBoss: Bool = false
}
