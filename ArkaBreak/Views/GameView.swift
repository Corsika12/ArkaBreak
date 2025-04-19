//
//  GameView.swift
//  ArkaBreak
//
//  Created by M on 19/04/2025.
//

import SwiftUI
import Combine

// MARK: - Helpers
extension CGRect {
    /// Centre du rectangle (syntaxe plus concise que `CGPoint(x: midX, y: midY)`)
    var center: CGPoint { CGPoint(x: midX, y: midY) }
}

// MARK: - Game Entities
struct Ball: Identifiable {
    let id = UUID()
    var pos: CGPoint
    var vel: CGVector
    static let radius: CGFloat = 8
}

enum BonusType: CaseIterable {
    case multiBall, extraLife, speedUp, paddleShrink

    var color: Color {
        switch self {
        case .multiBall:      return .green
        case .extraLife:      return .yellow
        case .speedUp:        return .orange
        case .paddleShrink:   return .purple
        }
    }
    var symbol: String {
        switch self {
        case .multiBall:      return "2x"
        case .extraLife:      return "+1"
        case .speedUp:        return "⚡️"
        case .paddleShrink:   return "⇵"
        }
    }
}

struct Bonus: Identifiable {
    let id = UUID()
    var pos: CGPoint
    let type: BonusType
    static let size: CGFloat = 20
}

struct Brick: Identifiable {
    let id = UUID()
    var rect: CGRect
    var hitsLeft: Int
    var color: Color
    var isBoss: Bool = false
}

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

// MARK: - Views
struct GameView: View {
    @StateObject private var game = GameState()
    @State private var nameInput: String = ""

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()
                if game.playerName.isEmpty {
                    VStack(spacing: 16) {
                        Text("Bienvenue !").font(.largeTitle).bold()
                        TextField("Entre ton prénom", text: $nameInput).textFieldStyle(.roundedBorder).frame(maxWidth: 200)
                        Button("Jouer") {
                            guard !nameInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                            game.playerName = nameInput; game.start(size: geo.size)
                        }.padding(.horizontal, 24).padding(.vertical, 8).background(Color.white.opacity(0.8)).clipShape(Capsule())
                    }
                } else {
                    ForEach(game.bricks) { brick in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(brick.isBoss ? Color.red : brick.color)
                            .overlay(brick.isBoss ? Text("Enzo").font(.caption2).bold().foregroundColor(.white) : nil)
                            .frame(width: brick.rect.width, height: brick.rect.height)
                            .position(x: brick.rect.midX, y: brick.rect.midY)
                    }
                    ForEach(game.bonuses) { bonus in
                        Circle().fill(bonus.type.color).frame(width: Bonus.size, height: Bonus.size).overlay(Text(bonus.type.symbol).font(.caption).bold()).position(bonus.pos)
                    }
                    ForEach(game.balls) { ball in
                        Circle().fill(Color.white).frame(width: Ball.radius * 2, height: Ball.radius * 2).position(ball.pos)
                    }
                    RoundedRectangle(cornerRadius: 8).fill(Color.blue).frame(width: game.paddleCurrentSize.width, height: game.paddleCurrentSize.height).position(x: game.paddleX, y: geo.size.height - game.paddleCurrentSize.height - 12).gesture(DragGesture().onChanged { value in game.movePaddle(to: value.location.x) })
                    VStack {
                        HStack { Text("Vies : \(game.lives)"); Spacer(); Text("Score : \(game.score)") }.padding(.horizontal)
                        Spacer()
                    }
                    if game.showLivesOverlay {
                        VStack { Text("Vies restantes : \(game.lives)").font(.title).bold().padding().background(Color.white.opacity(0.8)).cornerRadius(12) }.transition(.opacity)
                    }
                    if game.isGameOver {
                        VStack(spacing: 12) {
                            Text(game.lives <= 0 ? "Perdu…" : "Félicitations \(game.playerName) !\nTu as vaincu Enzo !").multilineTextAlignment(.center).font(.largeTitle).bold().padding()
                            Button("Rejouer") { game.start(size: geo.size) }.padding(.horizontal, 24).padding(.vertical, 8).background(Color.white.opacity(0.8)).clipShape(Capsule())
                        }.transition(.scale)
                    }
                }
            }
        }
    }
}

// A ajouter à l’appel dès que le jeu commence :
    /*
    .onAppear {
    AudioManager.shared.playBackgroundMusic()
}
.onDisappear {
    AudioManager.shared.stopBackgroundMusic()
}
*/

// MARK: - App entry point
@main struct BreakoutEnzoApp: App { var body: some Scene { WindowGroup { GameView() } } }
