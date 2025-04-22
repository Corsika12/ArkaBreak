//
//  ArkaBreak
//  Created by M on 19/04/2025.

//  Fichier GameModel.swift


import SwiftUI

// MARK: - BALL Model
struct Ball: Identifiable {
    let id = UUID()
    var pos: CGPoint
    var vel: CGVector
    var effect: BallEffect = .none
    var sizeBall: BallSize = .regular
    static let radius: CGFloat = 8
}

enum BallEffect: String, CaseIterable, Codable {
    case none       // Pas d'effet visuel particulier
    case fire       // 🔥 Effet flamme
    case electric   // ⚡️ Effet électrique
    case smoke      // 💨 Effet fumée / brouillard
    case fast       // ⚡️ Speed bonus

    // Couleur de la balle
    var color: Color {
        switch self {
        case .none:      return Color.white
        case .fire:      return Color("RedParis")
        case .electric:  return Color("PalatinateBlue")
        case .smoke:     return Color.black.opacity(0.2)
        case .fast:      return Color("SquashParis")
        }
    }
}

enum BallSize: String, CaseIterable, Codable {
    // Nouvelle propriété : Facteur de taille
    
    case xl
    case regular
    case small
    
    
    var sizeMultiplier: CGFloat {
        switch self {
        case .xl: return 1.4
        case .regular: return 1.0
        case .small: return 0.4
        }
    }
}

// MARK: - Brick Model
struct Brick: Identifiable {
    let id = UUID()
    var rect: CGRect
    var hitsLeft: Int
    var color: Color
    var isBoss: Bool = false
}
