//
//  ArkaBreak
//  Created by M on 19/04/2025.

//  Fichier BallView.swift

import SwiftUI

// MARK: - Game Entities
struct Ball: Identifiable {
    let id = UUID()
    var pos: CGPoint
    var vel: CGVector
    static let radius: CGFloat = 8
}
