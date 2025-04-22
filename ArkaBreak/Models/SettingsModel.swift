//
//  ArkaBreak
//  Created by M on 21/04/2025.

//  Fichier SettingsModels.swift

import Foundation

enum MusicChoice: String, CaseIterable, Identifiable, Codable {
    case funky = "Funky Chiptune"
    case arcade = "Arcade Puzzler"
    case random = "Aléatoire"
    case nothing = "Silencieux"

    var id: String { self.rawValue }
}


enum DifficultyLevel: String, CaseIterable, Identifiable {
    case easy = "Facile"
    case normal = "Normal"
    case hard = "Difficile"

    var id: String { self.rawValue }
}


enum Language: String, CaseIterable, Identifiable, Codable {
    case french = "Français"
    case english = "English"

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .french: return "🇫🇷 Français"
        case .english: return "🇬🇧 English"
        }
    }
}
