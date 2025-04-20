//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier PaddleVM.swift

import SwiftUI
import Combine

final class PaddleVM: ObservableObject {
    // Paddle position
    @Published var paddleX: CGFloat = 0
    
    // Constants
    var paddleBaseSize: CGSize = CGSize(width: 100, height: 16)
    
    // Dynamic paddle size (shrink effect)
    private var paddleShrinkRemaining: Double = 0
    
    var paddleCurrentSize: CGSize {
        paddleShrinkRemaining > 0
            ? CGSize(width: paddleBaseSize.width * 0.6, height: paddleBaseSize.height)
            : paddleBaseSize
    }
    
    // Methods
    func movePaddle(to x: CGFloat, canvasWidth: CGFloat) {
        paddleX = min(max(x, paddleCurrentSize.width / 2), canvasWidth - paddleCurrentSize.width / 2)
    }
    
    // Used to activate shrink bonus
    func activatePaddleShrink(duration: Double = 20) {
        paddleShrinkRemaining = duration
    }
    
    // Call every frame
    func updatePaddleShrink(deltaTime: Double) {
        if paddleShrinkRemaining > 0 {
            paddleShrinkRemaining -= deltaTime
        }
    }
}
