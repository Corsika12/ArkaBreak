//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier HomeView.swift


import SwiftUI

struct HomeView: View {
    @State private var navigateToGame = false
    @State private var navigateToScores = false
    @State private var navigateToOptions = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()

                    // Titre du jeu
                    Text("ArkaBreak")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 10)

                    Spacer()

                    // Bouton "Jouer"
                    Button(action: {
                        navigateToGame = true
                    }) {
                        Text("Jouer")
                            .font(.title2)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Capsule())
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                    }
                    .buttonStyle(.plain)
                    .scaleEffectOnTap()

                    // Bouton "Scores"
                    Button(action: {
                        navigateToScores = true
                    }) {
                        Text("Scores")
                            .font(.title2)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.7))
                            .clipShape(Capsule())
                            .foregroundColor(.black)
                            .shadow(radius: 3)
                    }
                    .buttonStyle(.plain)
                    .scaleEffectOnTap()

                    // Bouton "Options"
                    Button(action: {
                        navigateToOptions = true
                    }) {
                        Text("Options")
                            .font(.title2)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.7))
                            .clipShape(Capsule())
                            .foregroundColor(.black)
                            .shadow(radius: 3)
                    }
                    .buttonStyle(.plain)
                    .scaleEffectOnTap()

                    Spacer()

                    Text("v1.0 © 2025")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 20)
                }
                .padding()
            }

            // 🎯 Navigation pour chaque bouton
            .navigationDestination(isPresented: $navigateToGame) {
                GameView()
            }
            .navigationDestination(isPresented: $navigateToScores) {
                ScoresView()
            }
            .navigationDestination(isPresented: $navigateToOptions) {
                OptionsView()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}



/*
import SwiftUI

struct HomeView: View {
    @State private var navigateToGame = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()

                    // Titre du jeu
                    Text("ArkaBreak")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 10)

                    Spacer()

                    // Bouton "Jouer"
                    Button(action: {
                        navigateToGame = true
                    }) {
                        Text("Jouer")
                            .font(.title2)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Capsule())
                            .foregroundColor(.black)
                            .shadow(radius: 5)
                    }
                    .buttonStyle(.plain)
                    .scaleEffectOnTap()

                    // Boutons "Scores" et "Options" (futurs)
                    Button(action: {
                        // TODO: Leaderboard futur
                    }) {
                        Text("Scores")
                            .font(.title2)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.7))
                            .clipShape(Capsule())
                            .foregroundColor(.black)
                            .shadow(radius: 3)
                    }
                    .buttonStyle(.plain)
                    .scaleEffectOnTap()

                    Button(action: {
                        // TODO: Paramètres futur
                    }) {
                        Text("Options")
                            .font(.title2)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.7))
                            .clipShape(Capsule())
                            .foregroundColor(.black)
                            .shadow(radius: 3)
                    }
                    .buttonStyle(.plain)
                    .scaleEffectOnTap()

                    Spacer()

                    Text("v1.0 © 2025")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 20)
                }
                .padding()
            }
            
            .navigationDestination(isPresented: $navigateToGame) {
                GameView()
            }
        }
    }
}


// MARK: - Preview
#Preview {
    HomeView()
}
*/
