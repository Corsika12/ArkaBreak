//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier ExtensionsGame.swift



import SwiftUI

// MARK: - CGRect Extension

public extension CGRect {
    /// Centre du rectangle (position centrale)
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}

// MARK: - CGPoint Extension

public extension CGPoint {
    /// Renvoie un point aléatoire dans la taille donnée
    static func random(in size: CGSize) -> CGPoint {
        CGPoint(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height))
    }
}

// MARK: - CGFloat Extension

public extension CGFloat {
    /// Clamp une valeur entre deux bornes
    func clamped(min lower: CGFloat, max upper: CGFloat) -> CGFloat {
        Swift.max(lower, Swift.min(self, upper))
    }
}


extension View {
    /// Animation d'appui simple pour donner un effet tactile aux boutons
    func scaleEffectOnTap() -> some View {
        self.scaleEffect(1)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    _ = true
                }
            }
    }
}
