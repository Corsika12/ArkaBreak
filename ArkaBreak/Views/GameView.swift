//
//  ArkaBreak
//  Created by M on 19/04/2025.

//  Fichier GameView.swift

import SwiftUI
import Combine

// MARK: - GameView
struct GameView: View {
    @StateObject private var bonusVM = BonusVM()
    @StateObject private var paddleVM = PaddleVM()
    @StateObject private var gameEngineVM: GameEngineVM
    @ObservedObject private var countdownManager: CountdownManager

    @State private var isPaused = false
    @State private var didStartGame = false
    @Environment(\.dismiss) private var dismiss

    @AppStorage("playerName") private var playerName: String = ""

    init() {
        let paddleVM = PaddleVM()
        let bonusVM = BonusVM()
        let gameEngineVM = GameEngineVM(paddleVM: paddleVM, bonusVM: bonusVM)

        _paddleVM = StateObject(wrappedValue: paddleVM)
        _bonusVM = StateObject(wrappedValue: bonusVM)
        _gameEngineVM = StateObject(wrappedValue: gameEngineVM)
        _countdownManager = ObservedObject(wrappedValue: gameEngineVM.countdownManager)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()
                
                if gameEngineVM.isGameOver {
                    gameOverContent(geo: geo)
                } else {
                    gameContent(geo: geo)
                }

                pauseButton

                if isPaused {
                    pauseOverlay(geo: geo)
                }
            }
            .animation(.easeInOut, value: isPaused)
            .onChange(of: geo.size) {
                guard !didStartGame, geo.size.width > 0, geo.size.height > 0 else { return }

                if gameEngineVM.playerName.isEmpty {
                    gameEngineVM.playerName = playerName
                }
                gameEngineVM.start(size: geo.size)
                AudioManager.shared.playBackgroundMusic(filename: AudioFiles.backgroundMusic)
                didStartGame = true
            }
            .onDisappear {
                AudioManager.shared.stopBackgroundMusic()
                gameEngineVM.countdownManager.cancel()
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private func gameContent(geo: GeometryProxy) -> some View {
        Group {
            if let countdown = countdownManager.text {
                Text(countdown)
                    .font(.system(size: countdown == "GO!" ? 90 : 80, weight: .black))
                    .foregroundColor(.white)
                    .scaleEffect(countdown == "GO!" ? 1.5 : 1.0)
                    .opacity(countdown == "GO!" ? 1.0 : 0.9)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: countdown)
                    .transition(.scale)
            } else {
                activeGameView(geo: geo)
            }
        }
    }

    @ViewBuilder
    private func gameOverContent(geo: GeometryProxy) -> some View {
        Group {
            if gameEngineVM.lives <= 0 {
                GameOverView(playerName: gameEngineVM.playerName, score: gameEngineVM.score, didWin: false)
            } else {
                VictoryView(playerName: gameEngineVM.playerName, score: gameEngineVM.score) { action in
                    switch action {
                    case .newGame:
                        gameEngineVM.start(size: geo.size)
                    case .menu:
                        dismiss()
                    }
                }
            }
        }
        .transition(.opacity)
    }

    private var pauseButton: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: togglePause) {
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(12)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
            }
            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    private func pauseOverlay(geo: GeometryProxy) -> some View {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
        
        VStack(spacing: 20) {
            Text("Pause")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)

            Button("Reprendre", action: togglePause)
                .buttonStyle(PauseMenuButtonStyle())

            Button("Rejouer") {
                gameEngineVM.start(size: geo.size)
                isPaused = false
            }
            .buttonStyle(PauseMenuButtonStyle())

            Button("Quitter", action: dismiss.callAsFunction)
                .buttonStyle(PauseMenuButtonStyle())
        }
        .transition(.scale)
    }

    @ViewBuilder
    private func activeGameView(geo: GeometryProxy) -> some View {
        Group {
            ForEach(gameEngineVM.bricks) { brick in
                RoundedRectangle(cornerRadius: 4)
                    .fill(brick.isBoss ? Color.red : brick.color)
                    .overlay(
                        brick.isBoss ? Text("Enzo")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.white) : nil
                    )
                    .frame(width: brick.rect.width, height: brick.rect.height)
                    .position(x: brick.rect.midX, y: brick.rect.midY)
            }

            ForEach(bonusVM.bonuses) { bonus in
                Circle()
                    .fill(bonus.type.color)
                    .frame(width: Bonus.size, height: Bonus.size)
                    .overlay(Text(bonus.type.symbol)
                        .font(.caption)
                        .bold())
                    .position(bonus.pos)
            }

            ForEach(gameEngineVM.balls) { ball in
                Circle()
                    .fill(Color.white)
                    .frame(width: Ball.radius * 2, height: Ball.radius * 2)
                    .position(ball.pos)
            }

            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue)
                .frame(width: paddleVM.paddleCurrentSize.width, height: paddleVM.paddleCurrentSize.height)
                .position(x: paddleVM.paddleX, y: geo.size.height - paddleVM.paddleCurrentSize.height - 12)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            paddleVM.movePaddle(to: value.location.x, canvasWidth: geo.size.width)
                        }
                )

            VStack {
                HStack {
                    Text("Vies : \(gameEngineVM.lives)")
                    Spacer()
                    Text("Score : \(gameEngineVM.score)")
                }
                .padding(.horizontal)
                Spacer()
            }

            if gameEngineVM.showLivesOverlay {
                VStack {
                    Text("Vies restantes : \(gameEngineVM.lives)")
                        .font(.title)
                        .bold()
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                }
            }
        }
    }

    // MARK: - Actions

    private func togglePause() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        if isPaused {
            gameEngineVM.resumeGame()
        } else {
            gameEngineVM.pauseGame()
        }
        isPaused.toggle()
    }
}

// MARK: - Pause Menu Button Style
struct PauseMenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Color.white.opacity(configuration.isPressed ? 0.6 : 0.8))
            .clipShape(Capsule())
            .foregroundColor(.black)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
