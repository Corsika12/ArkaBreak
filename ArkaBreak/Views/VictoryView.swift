//
//  ArkaBreak
//  Created by M on 21/04/2025.

//  Fichier VictoryView.swift


import SwiftUI

struct VictoryView: View {
    var playerName: String
    var score: Int
    var onAction: (VictoryAction) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var animateTitle = false
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.85, green: 0.65, blue: 0.13), // Gold
                    Color(red: 0.2, green: 0.2, blue: 0.2) // Dark Gray
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if showConfetti {
                ConfettiBackgroundView()
                    .transition(.opacity)
            }

            VStack(spacing: 32) {
                
                VStack(spacing: 8) {
                          
                Text("Bravo")
                    .font(.system(size: 48, weight: .heavy))
                if playerName.trimmingCharacters(in: .whitespacesAndNewlines).count > 1 {
                    Text("\(playerName) !")
                        .font(.system(size: 40, weight: .semibold))
                }
            }
                .foregroundColor(.white)
                .scaleEffect(animateTitle ? 1.0 : 0.7)
                .opacity(animateTitle ? 1.0 : 0.0)
                .shadow(color: .yellow.opacity(0.7), radius: 10, x: 0, y: 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: animateTitle)
                .padding(.top, 50)
                
                Text("Score : \(score)")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.95))
                    .padding(.top, 8)

                VStack(spacing: 20) {
                    Button(action: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onAction(.newGame)
                        }
                    }) {
                        Text("Nouvelle Partie")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Capsule())
                            .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.1))
                            .shadow(radius: 5)
                    }
                    .buttonStyle(.plain)
                    .scaleEffectOnTap()

                    Button(action: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onAction(.menu)
                        }
                    }) {
                        Text("Menu Principal")
                            .font(.title3)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Capsule())
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .shadow(radius: 5)
                    }
                    .buttonStyle(.plain)
                    .scaleEffectOnTap()
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            animateTitle = true
            withAnimation(.easeInOut(duration: 1.2)) {
                showConfetti = true
            }
        }
    }
}

// MARK: - ConfettiBackgroundView with Blur
struct ConfettiBackgroundView: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<50) { i in
                    Circle()
                        .fill(randomColor())
                        .frame(width: 6, height: 6)
                        .position(x: CGFloat.random(in: 0...geo.size.width), y: animate ? geo.size.height + 50 : -50)
                        .animation(
                            Animation.linear(duration: Double.random(in: 2...4))
                                .repeatForever(autoreverses: false)
                                .delay(Double.random(in: 0...1)),
                            value: animate
                        )
                }
            }
            .blur(radius: 2)
        }
        .onAppear {
            animate = true
        }
        .ignoresSafeArea()
    }

    func randomColor() -> Color {
        let colors: [Color] = [.yellow, .white, .orange, .pink]
        return colors.randomElement() ?? .white
    }
}

// MARK: - Action Enum pour Victory
enum VictoryAction {
    case newGame
    case menu
}

#Preview {
    VictoryView(playerName: "Test", score: 999) { _ in }
}
