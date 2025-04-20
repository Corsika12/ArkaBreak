//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier ScoresView.swift


import SwiftUI

struct ScoresView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Classement")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Text("Bientôt disponible...")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
}

#Preview {
    ScoresView()
}
