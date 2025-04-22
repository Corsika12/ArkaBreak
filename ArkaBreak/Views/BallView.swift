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
            visualEffect(for: ball.effect)
        }
        .frame(width: BallView.baseRadius * 2, height: BallView.baseRadius * 2)
    }

    @ViewBuilder
    private func visualEffect(for effect: BallEffect) -> some View {
        switch effect {
        case .none:
            Circle()
                .fill(Color.white.opacity(0.95))

        case .fire:
            ZStack {
                Circle()
                    .fill(Color("RedParis"))
                Circle()
                    .stroke(Color.white.opacity(0.8), lineWidth: 0.8)
                    .blur(radius: 1)
            }

        case .electric:
            ZStack {
                Circle()
                    .fill(Color("BlueParis"))
                Circle()
                    .stroke(Color.white.opacity(0.8), lineWidth: 0.8)
                    .blur(radius: 1)
            }

        case .smoke:
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                Circle()
                    .stroke(Color.white.opacity(0.8), lineWidth: 0.8)
                    .blur(radius: 1)
            }
        }
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


