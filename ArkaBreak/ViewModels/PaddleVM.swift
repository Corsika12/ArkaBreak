//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier PaddleVM.swift

import SwiftUI
import Combine

final class PaddleVM: ObservableObject {
    @Published var paddleX: CGFloat = 0
    @AppStorage("difficultyLevel") private var difficultyLevel: DifficultyLevel = .normal

    // Base size dépendante de la difficulté
    var paddleBaseSize: CGSize {
        let width: CGFloat
        switch difficultyLevel {
        case .easy: width = 120
        case .normal: width = 100
        case .hard: width = 80
        }
        return CGSize(width: width, height: 16)
    }

    private var paddleShrinkStacks: Int = 0 // ✅ nombre de shrinks actifs
    private var paddleEnlargeStacks: Int = 0 // ✅ nombre de enlarges actifs
    private var paddleSizeRemaining: Double = 0 // ✅ Timer unique partagé

    var paddleCurrentSize: CGSize {
        var widthMultiplier: CGFloat = 1.0

        // Shrink : chaque stack multiplie par 0.8
        if paddleShrinkStacks > 0 {
            widthMultiplier *= pow(0.8, CGFloat(paddleShrinkStacks))
        }

        // Enlarge : chaque stack multiplie par 1.2
        if paddleEnlargeStacks > 0 {
            widthMultiplier *= pow(1.2, CGFloat(paddleEnlargeStacks))
        }

        let width = paddleBaseSize.width * widthMultiplier
        return CGSize(width: width, height: paddleBaseSize.height)
    }

    // MARK: - Methods

    func movePaddle(to x: CGFloat, canvasWidth: CGFloat) {
        paddleX = min(max(x, paddleCurrentSize.width / 2), canvasWidth - paddleCurrentSize.width / 2)
    }

    func activateLargePaddle(duration: Double = 8) {
        paddleEnlargeStacks += 1
        paddleSizeRemaining += duration // ✅ cumule la durée
    }

    func activatePaddleShrink(duration: Double = 10) {
        paddleShrinkStacks += 1
        paddleSizeRemaining += duration // ✅ cumule aussi
    }

    func updateBonusTimers(deltaTime: Double) {
        if paddleSizeRemaining > 0 {
            paddleSizeRemaining -= deltaTime
            if paddleSizeRemaining <= 0 {
                paddleSizeRemaining = 0
                paddleShrinkStacks = 0
                paddleEnlargeStacks = 0
            }
        }
    }

    func resetPaddleSize() {
        paddleShrinkStacks = 0
        paddleEnlargeStacks = 0
        paddleSizeRemaining = 0
    }
}



/*
import SwiftUI
import Combine

final class PaddleVM: ObservableObject {
    // Paddle position
    @Published var paddleX: CGFloat = 0
    
    // Constants
    var paddleBaseSize: CGSize = CGSize(width: 100, height: 16)
    
    // Dynamic paddle size (bonus effect)
    private var paddleShrinkRemaining: Double = 0
    private var paddleEnlargeRemaining: Double = 0
    
    var paddleCurrentSize: CGSize {
        var widthMultiplier: CGFloat = 1.0

        if paddleShrinkRemaining > 0 {
            widthMultiplier *= 0.6
        }
        if paddleEnlargeRemaining > 0 {
            widthMultiplier *= 1.4
        }

        let width = paddleBaseSize.width * widthMultiplier
        return CGSize(width: width, height: paddleBaseSize.height)
    }

    
    // Methods
    func movePaddle(to x: CGFloat, canvasWidth: CGFloat) {
        paddleX = min(max(x, paddleCurrentSize.width / 2), canvasWidth - paddleCurrentSize.width / 2)
    }
    
    // Used to activate Large bonus
    func activateLargePaddle(duration: Double = 20) {
        paddleEnlargeRemaining = duration
    }
    
    // Used to activate shrink bonus
    func activatePaddleShrink(duration: Double = 20) {
        paddleShrinkRemaining = duration
    }
    
    func updateBonusTimers(deltaTime: Double) {
        if paddleShrinkRemaining > 0 {
            paddleShrinkRemaining -= deltaTime
        }
        if paddleEnlargeRemaining > 0 {
            paddleEnlargeRemaining -= deltaTime
        }
    }

}
*/
