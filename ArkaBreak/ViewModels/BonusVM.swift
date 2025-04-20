//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier BonusVM.swift


import SwiftUI

final class BonusVM: ObservableObject {
    @Published var bonuses: [Bonus] = []

    func spawnBonus(at position: CGPoint) {
        guard Int.random(in: 0..<4) == 0 else { return }
        let type = BonusType.allCases.randomElement()!
        bonuses.append(Bonus(pos: position, type: type))
    }

    func updateBonusesFall(canvasHeight: CGFloat, paddleRect: CGRect, apply: (BonusType) -> Void) {
        for i in (0..<bonuses.count).reversed() {
            bonuses[i].pos.y += 3
            if paddleRect.contains(bonuses[i].pos) {
                apply(bonuses[i].type)
                bonuses.remove(at: i)
            } else if bonuses[i].pos.y > canvasHeight + Bonus.size {
                bonuses.remove(at: i)
            }
        }
    }

    func reset() {
        bonuses.removeAll()
    }
}
