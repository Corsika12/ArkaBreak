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
