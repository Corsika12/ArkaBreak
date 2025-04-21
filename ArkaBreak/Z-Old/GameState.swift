//
//  ArkaBreak
//  Created by M on 19/04/2025.

//  Fichier GameState.swift



// Old - fonctionnel le 20 avril 2025, avant split des VM


//  Fichier GameState.swift

/*
import SwiftUI
import Combine

// MARK: - ViewModel
final class GameState: ObservableObject {
    // Published state
    @Published var bricks: [Brick] = []
    @Published var balls: [Ball] = []
    @Published var bonuses: [Bonus] = []
    @Published var paddleX: CGFloat = 0
    @Published var lives: Int = 3
    @Published var score: Int = 0
    @Published var isGameOver = false
    @Published var playerName: String = ""
    @Published var showLivesOverlay = false

    // Timers & Combine
    private var displayLink: CADisplayLink?

    // Scene dimensions
    private var canvasSize: CGSize = .zero

    // Constants
    var paddleBaseSize: CGSize = CGSize(width: 100, height: 16)
    var paddleCurrentSize: CGSize {
        paddleShrinkRemaining > 0 ? CGSize(width: paddleBaseSize.width * 0.6, height: paddleBaseSize.height) : paddleBaseSize
    }

    // Active effect durations (in seconds)
    private var speedUpRemaining: Double = 0
    private var paddleShrinkRemaining: Double = 0

    // MARK: - Lifecycle
    func start(size: CGSize) {
        canvasSize = size
        paddleX = size.width / 2
        lives = 3
        score = 0
        isGameOver = false
        speedUpRemaining = 0
        paddleShrinkRemaining = 0
        showLivesOverlay = false
        createBricks()
        resetBalls()
        bonuses.removeAll()
        startDisplayLink()
    }

    private func startDisplayLink() {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 30, maximum: 120, preferred: 60)
        displayLink?.add(to: .main, forMode: .common)
    }

    deinit { displayLink?.invalidate() }

    // MARK: - Game Setup
    private func createBricks() {
        bricks.removeAll()
        let rows = 5
        let cols = 8
        let spacing: CGFloat = 4
        let topOffset: CGFloat = 40
        let brickWidth = (canvasSize.width - spacing * CGFloat(cols + 1)) / CGFloat(cols)
        let brickHeight: CGFloat = 20

        for row in 0..<rows {
            for col in 0..<cols {
                let x = spacing + CGFloat(col) * (brickWidth + spacing)
                let y = topOffset + spacing + CGFloat(row) * (brickHeight + spacing)
                let rect = CGRect(x: x, y: y, width: brickWidth, height: brickHeight)
                let color = Color(hue: Double(row) / Double(rows), saturation: 0.7, brightness: 0.9)
                var hits = 1
                var isBoss = false
                if row == 0 && col == cols / 2 - 1 { hits = 5; isBoss = true }
                bricks.append(Brick(rect: rect, hitsLeft: hits, color: color, isBoss: isBoss))
            }
        }
    }

    private func resetBalls() {
        balls = [Ball(pos: CGPoint(x: canvasSize.width / 2, y: canvasSize.height - 60), vel: CGVector(dx: CGFloat.random(in: -4...4), dy: -4))]
    }

    // MARK: - Game Loop
    @objc private func step(link: CADisplayLink) {
        guard !isGameOver else { return }
        let dt = link.targetTimestamp - link.timestamp
        if speedUpRemaining > 0 { speedUpRemaining -= dt }
        if paddleShrinkRemaining > 0 { paddleShrinkRemaining -= dt }
        let speedMultiplier: CGFloat = speedUpRemaining > 0 ? 1.5 : 1.0

        // Move balls
        for i in balls.indices.reversed() {
            balls[i].pos.x += balls[i].vel.dx * speedMultiplier
            balls[i].pos.y += balls[i].vel.dy * speedMultiplier
            if balls[i].pos.x - Ball.radius <= 0 || balls[i].pos.x + Ball.radius >= canvasSize.width { balls[i].vel.dx *= -1 }
            if balls[i].pos.y - Ball.radius <= 0 { balls[i].vel.dy *= -1 }
            if balls[i].pos.y + Ball.radius >= canvasSize.height { balls.remove(at: i) }
        }
        if balls.isEmpty { loseLife(); return }

        // Paddle rect
        let paddleRect = CGRect(x: paddleX - paddleCurrentSize.width / 2, y: canvasSize.height - paddleCurrentSize.height - 12, width: paddleCurrentSize.width, height: paddleCurrentSize.height)

        // Paddle collision
        for i in balls.indices {
            if paddleRect.contains(balls[i].pos) && balls[i].vel.dy > 0 {
                balls[i].vel.dy *= -1
                let offset = (balls[i].pos.x - paddleRect.midX) / (paddleCurrentSize.width / 2)
                balls[i].vel.dx = offset * 6
            }
        }

        // Brick collisions
        for ballIdx in balls.indices {
            // enumerate with index to remove safely
            for brickIdx in (0..<bricks.count).reversed() {
                if bricks[brickIdx].rect.contains(balls[ballIdx].pos) {
                    balls[ballIdx].vel.dy *= -1
                    bricks[brickIdx].hitsLeft -= 1
                    if bricks[brickIdx].hitsLeft <= 0 {
                        // ✅ BUG FIX 1: CGPoint center property via extension
                        maybeSpawnBonus(at: bricks[brickIdx].rect.center)
                        if bricks[brickIdx].isBoss { score += 500; winGame() } else { score += 100 }
                        bricks.remove(at: brickIdx)
                    }
                    break
                }
            }
        }

        // Update bonuses fall
        for i in (0..<bonuses.count).reversed() {
            bonuses[i].pos.y += 3
            if paddleRect.contains(bonuses[i].pos) { applyBonus(bonuses[i].type); bonuses.remove(at: i) }
            else if bonuses[i].pos.y > canvasSize.height + Bonus.size { bonuses.remove(at: i) }
        }
    }

    // MARK: - Mechanics helpers
    private func maybeSpawnBonus(at point: CGPoint) {
        guard Int.random(in: 0..<4) == 0 else { return }
        let type = BonusType.allCases.randomElement()!
        bonuses.append(Bonus(pos: point, type: type))
    }

    private func applyBonus(_ type: BonusType) {
        switch type {
        case .multiBall:
            balls.append(contentsOf: balls.map { Ball(pos: $0.pos, vel: CGVector(dx: -$0.vel.dx, dy: $0.vel.dy)) })
        case .extraLife:
            lives += 1
        case .speedUp:
            speedUpRemaining = 20
        case .paddleShrink:
            paddleShrinkRemaining = 20
        }
    }

    private func loseLife() {
        lives -= 1
        showLivesOverlay = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in self?.showLivesOverlay = false }
        if lives <= 0 { isGameOver = true } else { resetBalls() }
    }

    private func winGame() { isGameOver = true }

    // Paddle movement
    func movePaddle(to x: CGFloat) {
        paddleX = min(max(x, paddleCurrentSize.width / 2), canvasSize.width - paddleCurrentSize.width / 2)
    }
}
*/
