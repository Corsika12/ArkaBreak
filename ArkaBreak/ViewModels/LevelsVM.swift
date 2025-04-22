//
//  ArkaBreak
//  Created by M on 22/04/2025.

//  Fichier LevelsVM.swift


import SwiftUI

final class LevelsVM: ObservableObject {
    @Published var currentLevel: Int = 1
    let maxLevel: Int = 10

    // Méthode pour augmenter de niveau
    func nextLevel() {
        if currentLevel < maxLevel {
            currentLevel += 1
        }
    }

    // Reset total (ex: game over)
    func resetLevels() {
        currentLevel = 1
    }
    
    // Construction de la map selon le niveau actuel
    func generateLevelBricks(for size: CGSize) -> [Brick] {
        var bricks: [Brick] = []
        let rows = 4 + min(currentLevel, 6) // +1 ligne toutes les 2 levels
        let cols = 8
        let spacing: CGFloat = 4
        let topOffset: CGFloat = 40
        let brickWidth = (size.width - spacing * CGFloat(cols + 1)) / CGFloat(cols)
        let brickHeight: CGFloat = 20

        for row in 0..<rows {
            for col in 0..<cols {
                let x = spacing + CGFloat(col) * (brickWidth + spacing)
                let y = topOffset + spacing + CGFloat(row) * (brickHeight + spacing)
                let rect = CGRect(x: x, y: y, width: brickWidth, height: brickHeight)

                // Définir la difficulté : +1 hit tous les 3 niveaux
                let baseHits = 1 + (currentLevel / 3)
                var hits = baseHits
                var isBoss = false
                var color = Color(hue: Double(row) / Double(rows), saturation: 0.7, brightness: 0.9)

                // Ajouter quelques briques indestructibles à partir du niveau 4
                if currentLevel >= 4 && Bool.random() && row % 2 == 0 && col % 3 == 0 {
                    hits = Int.max // Indestructible
                    color = .gray.opacity(0.8)
                }

                // Boss au centre haut au level 1 uniquement
                if currentLevel == 1 && row == 0 && col == cols / 2 - 1 {
                    hits = 5
                    isBoss = true
                }

                bricks.append(Brick(rect: rect, hitsLeft: hits, color: color, isBoss: isBoss))
            }
        }
        return bricks
    }
}
