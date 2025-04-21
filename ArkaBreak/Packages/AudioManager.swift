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

    func playBackgroundMusic(filename: String = "background_music", fileExtension: String = "mp3") {
        guard !isMuted else { return }
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("Fichier audio \(filename).\(fileExtension) introuvable.")
            return
        }

        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = -1 // Boucle infinie
            backgroundPlayer?.volume = 0.5
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
}



extension AudioManager {
    func playSelectedBackgroundMusic() {
        let choice = MusicChoice(rawValue: UserDefaults.standard.string(forKey: "selectedMusic") ?? MusicChoice.funky.rawValue) ?? .funky

        let filename: String
        switch choice {
        case .funky:
            filename = AudioFiles.funkyChiptune
        case .arcade:
            filename = AudioFiles.arcadePuzzler
        case .random:
            filename = Bool.random() ? AudioFiles.funkyChiptune : AudioFiles.arcadePuzzler
        }

        playBackgroundMusic(filename: filename)
    }
}
