//
//  ArkaBreak
//  Created by M on 20/04/2025.

//  Fichier AudioFiles.swift


import Foundation

// MARK: - AudioFiles
/// Centralisation des fichiers audio avec extension pour sécurité et clarté.
struct AudioFiles {

    // Background Music
    static let funkyChiptune = (filename: "Funky-Chiptune", fileExtension: "mp3")
    static let arcadePuzzler = (filename: "ArcadePuzzler", fileExtension: "mp3")

    // Sound Effects (SFX)
    static let brickHit = (filename: "brick_hit", fileExtension: "wav")
    static let giftCollected = (filename: "Gift", fileExtension: "wav")
    static let maxiBonusCollected = (filename: "MaxiBonus", fileExtension: "wav")
    static let winMusic = (filename: "Win", fileExtension: "wav")
    static let gameOver = (filename: "GameOver", fileExtension: "wav")
}


/*
struct AudioFiles {

    // Background Music
    // static let backgroundMusic = "BackgroundMusic"
    static let funkyChiptune = "Funky-Chiptune"
    static let arcadePuzzler = "ArcadePuzzler"

    // Sound Effects (SFX)
    static let brickHit = "brick_hit"
    static let giftCollected = "Gift"
    static let maxiBonusCollected = "MaxiBonus"
    static let winMusic = "Win"
    static let gameOver = "GameOver"
}
*/
