//
//  ArkaBreak
//  Created by M on 21/04/2025.


//  Fichier LaunchScreenView.swift

import SwiftUI

struct LaunchScreenView: View {
    @Binding var showLaunchScreen: Bool
    @State private var animateLogo = false
    @State private var animateText = false
    @State private var animateExit = false

    var body: some View {
        ZStack {
            // Background Color
            LinearGradient(gradient: Gradient(colors: [
                Color.black,
                Color(red: 0.1, green: 0.1, blue: 0.3)
            ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "gamecontroller.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: animateLogo ? 160 : 100, height: animateLogo ? 160 : 100)
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.8), radius: 20, x: 0, y: 0)
                    .scaleEffect(animateExit ? 1.5 : 1.0)
                    .opacity(animateExit ? 0.0 : 1.0)
                    .animation(.easeInOut(duration: 0.6), value: animateExit)

                Text("ArkaBreak")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundStyle(LinearGradient(
                        colors: [Color.white, Color.yellow.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .shadow(color: .yellow.opacity(0.7), radius: 10, x: 0, y: 0)
                    .scaleEffect(animateExit ? 1.2 : 1.0)
                    .opacity(animateExit ? 0.0 : 1.0)
                    .animation(.easeInOut(duration: 0.6).delay(0.1), value: animateExit)
            }
        }
        .onAppear {
            animateLogo = true
            animateText = true

            // Lancement de l'animation de sortie après délai
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                animateExit = true

                // Après animation de sortie ➔ passer au HomeView
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    showLaunchScreen = false
                }
            }
        }
    }
}


/*
import SwiftUI

struct LaunchScreenView: View {
    @State private var animateLogo = false
    @State private var animateText = false

    var body: some View {
        ZStack {
            // Background Color
            LinearGradient(gradient: Gradient(colors: [
                Color.black,
                Color(red: 0.1, green: 0.1, blue: 0.3)
            ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "gamecontroller.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: animateLogo ? 160 : 100, height: animateLogo ? 160 : 100)
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.8), radius: 20, x: 0, y: 0)
                    .scaleEffect(animateLogo ? 1.0 : 0.6)
                    .opacity(animateLogo ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 1.2), value: animateLogo)

                Text("ArkaBreak")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundStyle(LinearGradient(
                        colors: [
                            Color.white,
                            Color.yellow.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .shadow(color: .yellow.opacity(0.7), radius: 10, x: 0, y: 0)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                    .animation(.easeOut(duration: 1.0).delay(0.5), value: animateText)
            }
        }
        .onAppear {
            animateLogo = true
            animateText = true
        }
    }
}

#Preview {
    LaunchScreenView()
}
*/
