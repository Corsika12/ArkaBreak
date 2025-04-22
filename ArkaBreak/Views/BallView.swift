//
//  ArkaBreak
//  Created by M on 22/04/2025.

//  Fichier BallView.swift


import SwiftUI

struct BallView: View {
    let ball: Ball
    static let baseRadius: CGFloat = Ball.radius

    var body: some View {
        ZStack {
            Circle()
                .fill(ball.effect.color)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.9), lineWidth: 0.8)
                        .blur(radius: 1)
                )
        }
        .frame(
            width: BallView.baseRadius * 2 * ball.sizeBall.sizeMultiplier,
            height: BallView.baseRadius * 2 * ball.sizeBall.sizeMultiplier
        )
    }
}


#Preview {
    VStack(spacing: 20) {
        BallView(ball: Ball(pos: .zero, vel: .zero, effect: .none))
        BallView(ball: Ball(pos: .zero, vel: .zero, effect: .fire))
        BallView(ball: Ball(pos: .zero, vel: .zero, effect: .electric))
        BallView(ball: Ball(pos: .zero, vel: .zero, effect: .smoke))
    }
    .padding()
    .background(Color.black)
}


