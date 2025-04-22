//
//  ArkaBreak
//  Created by M on 19/04/2025.

//  Fichier Bonus.swift

import SwiftUI

/*
enum BonusType: CaseIterable {
    case multiBall
    case extraLife
    case speedUp
    case paddleShrink
    case surpriseGift
    case explosiveBomb
    case shield
    case megaBall      // 🔥 Balle agrandie
    case slowMotion    // 🧊 Ralentit tout
    case stickyPaddle  // 🎯 La balle colle à la raquette
    case laserPaddle   // 🔫 La raquette tire des lasers
    case scoreBoost    // 🏆 Score X2 pendant quelques secondes
 🎃
    var color: Color {
        switch self {
        case .shield:         return .blue
        case .megaBall:       return .cyan
        case .slowMotion:     return .mint
        case .stickyPaddle:   return .indigo
        case .laserPaddle:    return .white

        }
    }

    var symbol: String {
        switch self {
        case .shield:         return "🛡️"
        case .megaBall:       return "🟢"
        case .slowMotion:     return "🐢"
        case .stickyPaddle:   return "🎯"
        case .laserPaddle:    return "🔫"

        }
    }
}
*/


enum BonusType: CaseIterable {
    case multiBall, megaBall, extraLife, speedUp, paddleShrink, explosiveBomb, scoreBoost, surpriseGift, largePaddle

    var color: Color {
        switch self {
        case .multiBall:      return Color("Dune")
        case .megaBall:       return Color("Dune")
        case .extraLife:      return Color("Dune")
        case .speedUp:        return Color("Dune").opacity(0.9)
        case .paddleShrink:   return Color("PalatinateBlue").opacity(0.95)
        case .largePaddle:    return Color("Gold").opacity(0.1)
        case .explosiveBomb:  return Color("RedParis").opacity(0.95)
        case .scoreBoost:     return Color("PalatinateBlue")
        case .surpriseGift:   return Color("Gold").opacity(0.1)
        }
    }
    
    var symbol: String {
        switch self {
        case .multiBall:      return "✨"
        case .megaBall:       return "🔆"
        case .extraLife:      return "+1"
        case .speedUp:        return "⚡️"
        case .paddleShrink:   return "❄️"
        case .largePaddle:    return "🛡️"
        case .explosiveBomb:  return "💣"
        case .scoreBoost:     return "🏆"
        case .surpriseGift:   return "🎁"

        }
    }
}

struct Bonus: Identifiable {
    let id = UUID()
    var pos: CGPoint
    let type: BonusType
    static let size: CGFloat = 20
}
