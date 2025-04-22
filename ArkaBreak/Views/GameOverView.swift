//
//  ArkaBreak
//  Created by M on 19/04/2025.


//  Fichier GameOverView.swift


import SwiftUI

struct GameOverView: View {
    var playerName: String
    var score: Int
    var didWin: Bool

    @Environment(\.dismiss) private var dismiss
    @State private var navigateToReplay = false
    @State private var animateTitle = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 32) {
                    // Titre animé
                    Text(didWin
                         ? (!playerName.isEmpty ? "Félicitations \(playerName) !" : "Félicitations !")
                         : "Perdu…"
                    )
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(animateTitle ? 1.0 : 0.8)
                    .opacity(animateTitle ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6), value: animateTitle)
                    .padding(.top, 40)

                    Text("Score : \(score)")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 8)

                    VStack(spacing: 16) {
                        // Bouton Rejouer
                        Button(action: {
                            navigateToReplay = true
                        }) {
                            Text("Rejouer")
                                .font(.title3)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 14)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Capsule())
                                .foregroundColor(.black)
                                .shadow(radius: 5)
                        }
                        .buttonStyle(.plain)
                        .scaleEffectOnTap()

                        // Bouton Menu Principal
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Menu Principal")
                                .font(.title3)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 14)
                                .background(Color.white.opacity(0.7))
                                .clipShape(Capsule())
                                .foregroundColor(.black)
                                .shadow(radius: 3)
                        }
                        .buttonStyle(.plain)
                        .scaleEffectOnTap()
                    }

                    Spacer()
                }
                .padding()
                .navigationDestination(isPresented: $navigateToReplay) {
                    GameView()
                }
            }
            .onAppear {
                animateTitle = true
                if !didWin {
                        AudioManager.shared.fadeOutBackgroundMusic()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            AudioManager.shared.playBackgroundMusic(
                                filename: AudioFiles.gameOver.filename,
                                fileExtension: AudioFiles.gameOver.fileExtension,
                                shouldLoop: false
                            )
                        }
                }
            }
        }
    }
}


#Preview {
    GameOverView(playerName: "Test", score: 999, didWin: false)
}
