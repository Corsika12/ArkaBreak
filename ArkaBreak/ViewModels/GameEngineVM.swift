//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier GameEngineVM.swift


import SwiftUI
import Combine

final class GameEngineVM: ObservableObject {
    // Game State
    @Published var bricks: [Brick] = []
    @Published var balls: [Ball] = []
    @Published var lives: Int = 3
    @Published var score: Int = 0
    @Published var isGameOver = false
    @Published var showLivesOverlay = false
    @Published var playerName: String = ""
    @Published var countdownManager: CountdownManager

    private var gameStarted = false
    private var isPaused = false
    private var canvasSize: CGSize = .zero
    private var displayLink: CADisplayLink?

    // ViewModels
    var paddleVM: PaddleVM
    var levelManager: LevelsVM
    var bonusVM: BonusVM
    
    // Effects
    private var speedUpRemaining: Double = 0
    let generator = UIImpactFeedbackGenerator()

    init(paddleVM: PaddleVM, bonusVM: BonusVM, levelManager: LevelsVM) {
        self.paddleVM = paddleVM
        self.levelManager = levelManager
        self.bonusVM = bonusVM
        self.countdownManager = CountdownManager()
    }

    // MARK: - Lifecycle
    func start(size: CGSize) {
        stopDisplayLink() // ✅ Toujours arrêter proprement avant de reset
        
        canvasSize = size
        lives = 3
        score = 0
        isGameOver = false
        showLivesOverlay = false
        speedUpRemaining = 0
        gameStarted = false
        isPaused = false
        
        loadLevel()
        // createBricks()
        resetBalls()
        bonusVM.bonuses.removeAll()
        bonusVM.setCanvasSize(size)

        paddleVM.paddleX = size.width / 2

        countdownManager.startCountdown { [weak self] in
            self?.startDisplayLink()
            self?.gameStarted = true
        }
    }

    private func startDisplayLink() {
        stopDisplayLink() // ✅ Important : toujours invalider avant
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 30, maximum: 120, preferred: 60)
        displayLink?.add(to: .main, forMode: .common)
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    deinit {
        stopDisplayLink() // ✅ Clean deinit
    }

    // MARK: - Pause / Resume
    func pauseGame() {
        isPaused = true
        stopDisplayLink()
    }

    func resumeGame() {
        guard gameStarted, !isGameOver else { return }
        isPaused = false
        startDisplayLink()
    }

    // MARK: - Game Setup Level 1 (prévoir d'autres levels)
    private func loadLevel() {
            bricks = levelManager.generateLevelBricks(for: canvasSize)
        }
    /*
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
                if row == 0 && col == cols / 2 - 1 {
                    hits = 5
                    isBoss = true
                }
                bricks.append(Brick(rect: rect, hitsLeft: hits, color: color, isBoss: isBoss))
            }
        }
    }
    */

    private func resetBalls() {
        balls = [Ball(
            pos: CGPoint(x: canvasSize.width / 2, y: canvasSize.height - 60),
            vel: CGVector(dx: CGFloat.random(in: -4...4), dy: -4),
            effect: .none
        )]
        bonusVM.effetsBalls(&balls, effect: .none)
        bonusVM.sizeBalls(&balls, size: .regular)
    }

    // MARK: - Game Loop
    @objc private func step(link: CADisplayLink) {
        guard gameStarted, !isGameOver, !isPaused else { return }

        let dt = link.targetTimestamp - link.timestamp

        if speedUpRemaining > 0 { speedUpRemaining -= dt }
        paddleVM.updateBonusTimers(deltaTime: dt)

        let speedMultiplier: CGFloat = speedUpRemaining > 0 ? 1.5 : 1.0

        // Move balls
        for i in balls.indices.reversed() {
            balls[i].pos.x += balls[i].vel.dx * speedMultiplier
            balls[i].pos.y += balls[i].vel.dy * speedMultiplier

            if balls[i].pos.x - Ball.radius <= 0 || balls[i].pos.x + Ball.radius >= canvasSize.width {
                balls[i].vel.dx *= -1
            }
            if balls[i].pos.y - Ball.radius <= 0 {
                balls[i].vel.dy *= -1
            }
            if balls[i].pos.y + Ball.radius >= canvasSize.height {
                balls.remove(at: i)
            }
        }

        if balls.isEmpty {
            loseLife()
            return
        }

        let paddleRect = CGRect(
            x: paddleVM.paddleX - paddleVM.paddleCurrentSize.width / 2,
            y: canvasSize.height - paddleVM.paddleCurrentSize.height - 12,
            width: paddleVM.paddleCurrentSize.width,
            height: paddleVM.paddleCurrentSize.height
        )

        // Paddle collisions
        for i in balls.indices {
            if paddleRect.contains(balls[i].pos) && balls[i].vel.dy > 0 {
                balls[i].vel.dy *= -1
                let offset = (balls[i].pos.x - paddleRect.midX) / (paddleVM.paddleCurrentSize.width / 2)
                balls[i].vel.dx = offset * 6
            }
        }

        // Brick collisions
        for ballIdx in balls.indices {
            for brickIdx in (0..<bricks.count).reversed() {
                if bricks[brickIdx].rect.contains(balls[ballIdx].pos) {
                    balls[ballIdx].vel.dy *= -1
                    bricks[brickIdx].hitsLeft -= 1
                    if bricks[brickIdx].hitsLeft <= 0 {
                        bonusVM.maybeSpawnBonus(at: bricks[brickIdx].rect.center)
                        if bricks[brickIdx].isBoss {
                            score += 500
                            winGame()
                        } else {
                            score += 100
                        }
                        bricks.remove(at: brickIdx)
                    }
                    break
                }
            }
        }

        // Bonus falling
        bonusVM.updateBonuses(paddleRect: paddleRect) { [weak self] bonusType in
            self?.applyBonus(bonusType)
        }
    }

    // MARK: - Mechanics helpers
    private func applyBonus(_ type: BonusType) {
        switch type {
        case .multiBall:
            let newBalls = bonusVM.createMultiBalls(from: balls, count: 1)
            balls.append(contentsOf: newBalls)
            bonusVM.effetsBalls(&balls, effect: .fast)
            speedUpRemaining += 10
            UIImpactFeedbackGenerator(style: .light).impactOccurred()

        case .explosiveBomb:
            let newBalls = bonusVM.createMultiBalls(from: balls, count: 8)
            balls.append(contentsOf: newBalls)
            bonusVM.effetsBalls(&balls, effect: .fire)
            bonusVM.sizeBalls(&balls, size: .small)
            speedUpRemaining += 10
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        
        case .megaBall:
            bonusVM.sizeBalls(&balls, size: .xl)
            bonusVM.effetsBalls(&balls, effect: .smoke)
                speedUpRemaining = 10
        case .extraLife:
            lives += 1
            AudioManager.shared.playSFX(named: "MaxiBonus")
            speedUpRemaining = 30
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            // mettre un fond dynamique (ex. feu d’artifice rapide derrière ?)
        case .speedUp:
            bonusVM.effetsBalls(&balls, effect: .fast)
            bonusVM.sizeBalls(&balls, size: .small)
            speedUpRemaining += 20
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        case .paddleShrink:
            paddleVM.activatePaddleShrink()
            bonusVM.effetsBalls(&balls, effect: .electric)
            speedUpRemaining += 15
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        case .largePaddle:
            paddleVM.activateLargePaddle()
            bonusVM.effetsBalls(&balls, effect: .smoke)
            speedUpRemaining += 10
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .scoreBoost:
            score += 250
            AudioManager.shared.playSFX(named: "Gift")
            bonusVM.sizeBalls(&balls, size: .small)
            bonusVM.effetsBalls(&balls, effect: .fast)
            speedUpRemaining += 8
        case .surpriseGift:
            // 🎁 Surprise : appliquer un autre bonus au hasard sauf surpriseGift
            let otherBonuses = BonusType.allCases.filter { $0 != .surpriseGift }
            if let randomBonus = otherBonuses.randomElement() {
                applyBonus(randomBonus)
            }
            speedUpRemaining += 5
            AudioManager.shared.playSFX(named: "Gift")
        }
    }


    private func loseLife() {
        lives -= 1
        showLivesOverlay = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.showLivesOverlay = false
        }
        if lives <= 0 {
            isGameOver = true
            stopDisplayLink() // ✅ important : arrêter la boucle en cas de fin de partie
        } else {
            resetBalls()
        }
    }

    private func winGame() {
        isGameOver = true
        stopDisplayLink() // ✅ arrêter sur victoire aussi
    }
}



/*
case .multiBall:
balls.append(contentsOf: balls.map {
    Ball(pos: $0.pos, vel: CGVector(dx: -$0.vel.dx, dy: $0.vel.dy))
})
speedUpRemaining += 10
UIImpactFeedbackGenerator(style: .light).impactOccurred()
 
 case .explosiveBomb:
     speedUpRemaining += 5
     UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
*/
