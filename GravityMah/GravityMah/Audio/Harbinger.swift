import AVFoundation
import UIKit

final class Harbinger {
    static let shared = Harbinger()

    private var bgPlayer: AVAudioPlayer?
    private var sfxPlayers: [String: AVAudioPlayer] = [:]

    private init() {
        configureSession()
    }

    private func configureSession() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    func igniteMusic() {
        guard Reliquary.shared.musicOn else { return }
        guard bgPlayer == nil else { bgPlayer?.play(); return }
        // NOTE: background music file optional; game works without it
        guard let url = Bundle.main.url(forResource: "bg_music", withExtension: "mp3") else { return }
        bgPlayer = try? AVAudioPlayer(contentsOf: url)
        bgPlayer?.numberOfLoops = -1
        bgPlayer?.volume = 0.4
        bgPlayer?.play()
    }

    func extinguishMusic() {
        bgPlayer?.pause()
    }

    func toll(_ name: String) {
        guard Reliquary.shared.soundOn else { return }
        if let player = sfxPlayers[name] {
            player.currentTime = 0
            player.play()
            return
        }
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav")
                     ?? Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        let player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        player?.play()
        sfxPlayers[name] = player
    }

    func vibrate(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        guard Reliquary.shared.hapticsOn else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard Reliquary.shared.hapticsOn else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}
