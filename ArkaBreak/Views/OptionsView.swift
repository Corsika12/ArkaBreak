//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier OptionsView.swift

import SwiftUI

struct OptionsView: View {
    @AppStorage("playerName") private var playerName: String = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Options")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Ton prénom")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))

                    TextField("Entre ton prénom", text: $playerName)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 250)
                }

                Spacer()
            }
            .padding(.top, 80)
        }
    }
}

#Preview {
    OptionsView()
}
