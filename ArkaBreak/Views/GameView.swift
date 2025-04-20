//
//  ArkaBreak
//  Created by M on 19/04/2025.

//  Fichier GameView.swift


import SwiftUI
import Combine

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
        // Appel AudioManager
        .onAppear {
            AudioManager.shared.playBackgroundMusic()
        }
        .onDisappear {
            AudioManager.shared.stopBackgroundMusic()
        }
    }
}
