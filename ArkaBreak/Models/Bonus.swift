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

    var color: Color {
        switch self {
        case .multiBall:      return .green
        case .extraLife:      return .yellow
        case .speedUp:        return .orange
        case .paddleShrink:   return .purple
        case .surpriseGift:   return .pink
        case .explosiveBomb:  return .red
        case .shield:         return .blue
        case .megaBall:       return .cyan
        case .slowMotion:     return .mint
        case .stickyPaddle:   return .indigo
        case .laserPaddle:    return .white
        case .scoreBoost:     return .orange
        }
    }

    var symbol: String {
        switch self {
        case .multiBall:      return "2x"
        case .extraLife:      return "+1"
        case .speedUp:        return "⚡️"
        case .paddleShrink:   return "⇵"
        case .surpriseGift:   return "🎁"
        case .explosiveBomb:  return "💣"
        case .shield:         return "🛡️"
        case .megaBall:       return "🟢"
        case .slowMotion:     return "🐢"
        case .stickyPaddle:   return "🎯"
        case .laserPaddle:    return "🔫"
        case .scoreBoost:     return "🏆"
        }
    }
}
*/



enum BonusType: CaseIterable {
    case multiBall, extraLife, speedUp, paddleShrink

    var color: Color {
        switch self {
        case .multiBall:      return .green
        case .extraLife:      return .yellow
        case .speedUp:        return .orange
        case .paddleShrink:   return .purple
        }
    }
    var symbol: String {
        switch self {
        case .multiBall:      return "2x"
        case .extraLife:      return "+1"
        case .speedUp:        return "⚡️"
        case .paddleShrink:   return "⇵"
        }
    }
}

struct Bonus: Identifiable {
    let id = UUID()
    var pos: CGPoint
    let type: BonusType
    static let size: CGFloat = 20
}

