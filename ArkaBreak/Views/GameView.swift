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
    @State private var nameInput: String = ""

    @State private var isPaused = false
    @Environment(\.dismiss) private var dismiss
    
    // Récupération du prénom depuis OptionsView
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

                Group {
                    
                    if gameEngineVM.playerName.isEmpty {
                        // Écran de Bienvenue
                        VStack(spacing: 16) {
                            Text("Bienvenue !")
                                .font(.largeTitle)
                                .bold()

                            TextField("Entre ton prénom", text: $nameInput)
                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: 200)

                            Button("Jouer") {
                                guard !nameInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                                gameEngineVM.playerName = nameInput
                                gameEngineVM.start(size: geo.size)
                            }
                            
                        }
                        .transition(.opacity)
                    }
                    else if let countdown = countdownManager.text {
                        // Compte à rebours
                        
                        Text(countdown)
                            .font(.system(size: 80, weight: .black))
                            .foregroundColor(.white)
                            .scaleEffect(countdown == "GO!" ? 1.4 : 1.0)
                            .opacity(countdown == "GO!" ? 1.0 : 0.9)
                            .animation(.easeInOut(duration: 0.5), value: countdown)
                            .id(countdown)
                            .transition(.scale)
                    }
                    else {
                        // Jeu actif
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
                                .overlay(
                                    Text(bonus.type.symbol)
                                        .font(.caption)
                                        .bold()
                                )
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

                        if gameEngineVM.isGameOver {
                            VStack(spacing: 12) {
                                Text(gameEngineVM.lives <= 0 ? "Perdu…" : "Félicitations \(gameEngineVM.playerName) !\nTu as vaincu Enzo !")
                                    .multilineTextAlignment(.center)
                                    .font(.largeTitle)
                                    .bold()
                                    .padding()

                                Button("Rejouer") {
                                    gameEngineVM.start(size: geo.size)
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Capsule())
                            }
                        }
                    }
                }

                // 🎛 Contrôles
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

                // 🎨 Overlay de pause
                if isPaused {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Text("Pause")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()

                        Button("Reprendre") {
                            togglePause()
                        }
                        .buttonStyle(PauseMenuButtonStyle())

                        Button("Rejouer") {
                            gameEngineVM.start(size: geo.size)
                            isPaused = false
                        }
                        .buttonStyle(PauseMenuButtonStyle())

                        Button("Quitter") {
                            dismiss()
                        }
                        .buttonStyle(PauseMenuButtonStyle())
                    }
                    .transition(.scale)
                }
            }
            .animation(.easeInOut, value: isPaused)
        }
        .onAppear {
            AudioManager.shared.playBackgroundMusic(filename: AudioFiles.backgroundMusic)
        }
        .onDisappear {
            AudioManager.shared.stopBackgroundMusic()
        }
    }

    private func togglePause() {
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





// Old - version V1 OK mais à optimiser
/*
import SwiftUI
import Combine

// MARK: - Views
struct GameView: View {
    @StateObject private var bonusVM = BonusVM()
    @StateObject private var paddleVM = PaddleVM()
    @StateObject private var gameEngineVM: GameEngineVM
    @ObservedObject private var countdownManager: CountdownManager
    @State private var nameInput: String = ""
    
    init() {
        let paddleVM = PaddleVM()
        let bonusVM = BonusVM()
        let gameEngineVM = GameEngineVM(paddleVM: paddleVM, bonusVM: bonusVM)

        _paddleVM = StateObject(wrappedValue: paddleVM)
        _bonusVM = StateObject(wrappedValue: bonusVM)
        _gameEngineVM = StateObject(wrappedValue: gameEngineVM)
        _countdownManager = ObservedObject(wrappedValue: gameEngineVM.countdownManager) // ✅ Important pour observer les changements
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()
                
                // 1. Ecran de Bienvenue
                if gameEngineVM.playerName.isEmpty {
                    VStack(spacing: 16) {
                        Text("Bienvenue !")
                            .font(.largeTitle)
                            .bold()
                            .transition(.opacity)
                        
                        TextField("Entre ton prénom", text: $nameInput)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 200)
                        
                        Button("Jouer") {
                            guard !nameInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                            gameEngineVM.playerName = nameInput
                            gameEngineVM.start(size: geo.size)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Capsule())
                        .transition(.scale)
                    }
                    .transition(.opacity)
                }
                
                // 2. Compte à rebours
                else if let countdown = countdownManager.text {
                    Text(countdown)
                        .font(.system(size: 80, weight: .black))
                        .foregroundColor(.white)
                        .scaleEffect(countdown == "GO!" ? 1.4 : 1.0)
                        .opacity(countdown == "GO!" ? 1.0 : 0.9)
                        .animation(.easeInOut(duration: 0.5), value: countdown)
                        .transition(.scale)
                        .id(countdown) // Permet l'animation de transition à chaque changement
                }
                
                // 3. Jeu actif après le compte à rebours
                else {
                    ForEach(gameEngineVM.bricks) { brick in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(brick.isBoss ? Color.red : brick.color)
                            .overlay(
                                brick.isBoss ?
                                Text("Enzo")
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
                            .overlay(
                                Text(bonus.type.symbol)
                                    .font(.caption)
                                    .bold()
                            )
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
                        .transition(.opacity)
                    }
                    
                    if gameEngineVM.isGameOver {
                        VStack(spacing: 12) {
                            Text(gameEngineVM.lives <= 0 ? "Perdu…" : "Félicitations \(gameEngineVM.playerName) !\nTu as vaincu Enzo !")
                                .multilineTextAlignment(.center)
                                .font(.largeTitle)
                                .bold()
                                .padding()
                            
                            Button("Rejouer") {
                                gameEngineVM.start(size: geo.size)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Capsule())
                        }
                        .transition(.scale)
                    }
                }
            }
            .animation(.easeInOut, value: countdownManager.text) // Global animation des changements
        }
        .onAppear {
            AudioManager.shared.playBackgroundMusic(filename: AudioFiles.backgroundMusic)
        }
        .onDisappear {
            AudioManager.shared.stopBackgroundMusic()
        }
    }
}
*/
