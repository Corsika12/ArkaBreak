//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier BallVM.swift


import SwiftUI

final class BallVM: ObservableObject {
    @Published var balls: [Ball] = []

    func resetBalls(canvasSize: CGSize) {
        balls = [Ball(pos: CGPoint(x: canvasSize.width / 2, y: canvasSize.height - 60),
                      vel: CGVector(dx: CGFloat.random(in: -4...4), dy: -4))]
    }

    func moveBalls(speedMultiplier: CGFloat, canvasSize: CGSize) {
        for i in balls.indices.reversed() {
            balls[i].pos.x += balls[i].vel.dx * speedMultiplier
            balls[i].pos.y += balls[i].vel.dy * speedMultiplier

            if balls[i].pos.x - Ball.radius <= 0 || balls[i].pos.x + Ball.radius >= canvasSize.width {
                balls[i].vel.dx *= -1
            }
            if balls[i].pos.y - Ball.radius <= 0 {
                balls[i].vel.dy *= -1
            }
        }
    }

    func removeBallsOutOfBounds(canvasHeight: CGFloat) {
        balls.removeAll { $0.pos.y + Ball.radius >= canvasHeight }
    }

    func paddleCollision(paddleRect: CGRect) {
        for i in balls.indices {
            if paddleRect.contains(balls[i].pos) && balls[i].vel.dy > 0 {
                balls[i].vel.dy *= -1
                let offset = (balls[i].pos.x - paddleRect.midX) / (paddleRect.width / 2)
                balls[i].vel.dx = offset * 6
            }
        }
    }

    func duplicateBalls() {
        let newBalls = balls.map { Ball(pos: $0.pos, vel: CGVector(dx: -$0.vel.dx, dy: $0.vel.dy)) }
        balls.append(contentsOf: newBalls)
    }
}
