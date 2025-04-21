//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier OptionsView.swift

import SwiftUI
import UserNotifications

struct OptionsView: View {
    @AppStorage("playerName") private var playerName: String = ""
    @AppStorage("selectedMusic") private var selectedMusic: MusicChoice = .funky
    @AppStorage("difficultyLevel") private var difficultyLevel: DifficultyLevel = .normal
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Options")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 12) {
                    Group {
                        Text("Ton prénom")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))

                        TextField("Entre ton prénom", text: $playerName)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 250)
                    }

                    Divider().background(Color.white.opacity(0.5))

                    Group {
                        Text("Musique du jeu")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))

                        Picker("Sélection musique", selection: $selectedMusic) {
                            ForEach(MusicChoice.allCases) { choice in
                                Text(choice.rawValue).tag(choice)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: 250)
                    }

                    Divider().background(Color.white.opacity(0.5))

                    Group {
                        Text("Niveau de difficulté")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))

                        Picker("Sélection difficulté", selection: $difficultyLevel) {
                            ForEach(DifficultyLevel.allCases) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 300)
                    }

                    Divider().background(Color.white.opacity(0.5))

                    Group {
                        Text("Thème")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))

                        Text("Mode jour/nuit automatique 📱🌙 (à venir)")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.6))
                            .italic()
                    }
                    
                    Divider().background(Color.white.opacity(0.5))

                    Group {
                        Toggle(isOn: $notificationsEnabled) {
                            Text("Notifications")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: 300)
                        .onChange(of: notificationsEnabled) {
                            if notificationsEnabled {
                                requestNotificationPermission()
                            }
                        }

                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)

                
                
                
                Spacer()
            }
            .padding(.top, 80)
        }
    }

    // MARK: - Notification Permission Request
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Erreur permission notifications: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.notificationsEnabled = granted
            }
        }
    }
}

#Preview {
    OptionsView()
}


/*
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
*/
