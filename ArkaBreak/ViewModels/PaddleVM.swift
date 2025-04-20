//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier PaddleVM.swift


import SwiftUI

final class PaddleVM: ObservableObject {
    @Published var paddleX: CGFloat = 0
    private(set) var baseSize: CGSize = CGSize(width: 100, height: 16)
    private var shrinkRemaining: Double = 0

    var currentSize: CGSize {
        shrinkRemaining > 0 ? CGSize(width: baseSize.width * 0.6, height: baseSize.height) : baseSize
    }

    func updateShrinkEffect(deltaTime: Double) {
        if shrinkRemaining > 0 {
            shrinkRemaining -= deltaTime
        }
    }

    func applyShrink(duration: Double) {
        shrinkRemaining = duration
    }

    func move(to x: CGFloat, canvasWidth: CGFloat) {
        paddleX = min(max(x, currentSize.width / 2), canvasWidth - currentSize.width / 2)
    }

    func reset(canvasWidth: CGFloat) {
        paddleX = canvasWidth / 2
        shrinkRemaining = 0
    }
}
