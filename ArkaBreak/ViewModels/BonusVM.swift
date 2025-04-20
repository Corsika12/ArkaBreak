//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier BonusVM.swift


import SwiftUI
import Combine

final class BonusVM: ObservableObject {
    @Published var bonuses: [Bonus] = []
    
    private var canvasSize: CGSize = .zero
    
    // Setter pour la taille du canvas
    func setCanvasSize(_ size: CGSize) {
        canvasSize = size
    }
    
    // Bonus spawning
    func maybeSpawnBonus(at point: CGPoint) {
        guard Int.random(in: 0..<4) == 0 else { return }
        let type = BonusType.allCases.randomElement()!
        bonuses.append(Bonus(pos: point, type: type))
    }
    
    // Mise à jour de la chute des bonus
    func updateBonuses(paddleRect: CGRect, apply: (BonusType) -> Void) {
        for i in (0..<bonuses.count).reversed() {
            bonuses[i].pos.y += 3
            if paddleRect.contains(bonuses[i].pos) {
                apply(bonuses[i].type)
                bonuses.remove(at: i)
            } else if bonuses[i].pos.y > canvasSize.height + Bonus.size {
                bonuses.remove(at: i)
            }
        }
    }
}
