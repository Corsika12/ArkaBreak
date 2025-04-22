//
//  ArkaBreak
//  Created by M on 19/04/2025.

//  Fichier AudioManager.swift

import Foundation
import AVFoundation

// MARK: - AudioManager
final class AudioManager: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioManager()

    private var backgroundPlayer: AVAudioPlayer?
    private var sfxPlayers: [AVAudioPlayer] = []
    private var isMuted: Bool = false

    private override init() {
        super.init()
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Erreur configuration AVAudioSession : \(error.localizedDescription)")
        }
    }

    func playBackgroundMusic(filename: String = "background_music", fileExtension: String = "mp3", shouldLoop: Bool = true) {
        guard !isMuted else { return }
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("Fichier audio \(filename).\(fileExtension) introuvable.")
            return
        }

        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = shouldLoop ? -1 : 0
            backgroundPlayer?.volume = 0.4
            backgroundPlayer?.prepareToPlay()
            backgroundPlayer?.play()
        } catch {
            print("Erreur lors de la lecture audio : \(error.localizedDescription)")
        }
    }

    func setBackgroundMusicVolume(_ volume: Double) {
        backgroundPlayer?.volume = Float(volume)
    }
    
    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
    }

    func toggleMute() {
        isMuted.toggle()
        if isMuted {
            stopBackgroundMusic()
        } else {
            playBackgroundMusic()
        }
    }

    func playSFX(named soundName: String, withExtension ext: String = "wav") {
        guard !isMuted else { return }
        guard let url = Bundle.main.url(forResource: soundName, withExtension: ext) else {
            print("SFX \(soundName).\(ext) introuvable.")
            return
        }

        do {
            let sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer.volume = 0.8  // 🔊 Plein volume (max = 1.0)
            sfxPlayers.append(sfxPlayer)
            sfxPlayer.delegate = self
            sfxPlayer.play()

        } catch {
            print("Erreur SFX \(soundName) : \(error.localizedDescription)")
        }
    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = sfxPlayers.firstIndex(of: player) {
            sfxPlayers.remove(at: index)
        }
    }
    
    // MARK: - Fade Out
    func fadeOutBackgroundMusic(duration: TimeInterval = 1.5) {
        guard let player = backgroundPlayer, player.isPlaying else { return }
        
        let fadeSteps = 30
        let fadeInterval = duration / Double(fadeSteps)
        let volumeStep = player.volume / Float(fadeSteps)
        
        var steps = fadeSteps

        Timer.scheduledTimer(withTimeInterval: fadeInterval, repeats: true) { timer in
            player.volume -= volumeStep
            steps -= 1
            
            if steps <= 0 || player.volume <= 0 {
                timer.invalidate()
                player.stop()
            }
        }
    }    
}


extension AudioManager {
    func playSelectedBackgroundMusic() {
        let choice = MusicChoice(rawValue: UserDefaults.standard.string(forKey: "selectedMusic") ?? MusicChoice.funky.rawValue) ?? .funky

        guard choice != .nothing else {
            fadeOutBackgroundMusic() // Transition douce si "Silencieux"
            return
        }

        let audioFile: (filename: String, fileExtension: String)
        switch choice {
        case .funky:
            audioFile = AudioFiles.funkyChiptune
        case .arcade:
            audioFile = AudioFiles.arcadePuzzler
        case .random:
            audioFile = Bool.random() ? AudioFiles.funkyChiptune : AudioFiles.arcadePuzzler
        case .nothing:
            return // déjà géré au-dessus
        }

        playBackgroundMusic(filename: audioFile.filename, fileExtension: audioFile.fileExtension)
    }
}




/*
extension AudioManager {
    // Utiliser directement un tuple (nom + extension)
    func playBackgroundMusic(from audioFile: (filename: String, fileExtension: String), shouldLoop: Bool = true) {
        playBackgroundMusic(filename: audioFile.filename, fileExtension: audioFile.fileExtension, shouldLoop: shouldLoop)
    }

    func playSelectedBackgroundMusic() {
        let choice = MusicChoice(rawValue: UserDefaults.standard.string(forKey: "selectedMusic") ?? MusicChoice.funky.rawValue) ?? .funky

        let audioFile: (filename: String, fileExtension: String)
        switch choice {
        case .funky:
            audioFile = AudioFiles.funkyChiptune
        case .arcade:
            audioFile = AudioFiles.arcadePuzzler
        case .random:
            audioFile = Bool.random() ? AudioFiles.funkyChiptune : AudioFiles.arcadePuzzler
        case .nothing:
            audioFile = AudioFiles.funkyChiptune
            // à remplacer par nil ?
        }

           playBackgroundMusic(from: audioFile)

   }
}
*/
