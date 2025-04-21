//
//  ArkaBreak
//  Created by M on 19/04/2025.

//  Fichier Bonus.swift

import SwiftUI

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
