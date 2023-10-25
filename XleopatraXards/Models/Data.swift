import UIKit
import AVFoundation

class CardData {
    static let shared = CardData()
    
    var cards: [Card] = [Card(image: UIImage(named: "Q")!, title: "q"),
                         Card(image: UIImage(named: "J")!, title: "j"),
                         Card(image: UIImage(named: "A")!, title: "a"),
                         Card(image: UIImage(named: "K")!, title: "k"),
                         Card(image: UIImage(named: "M2")!, title: "cat"),
                         Card(image: UIImage(named: "M3")!, title: "frog"),
                         Card(image: UIImage(named: "M4")!, title: "snake"),
    ]
    
    func shuffle() {
        cards = cards.shuffled()
    }
}

struct Card {
    var image: UIImage
    var title: String
}

enum CardState {
    case closed
    case open
    case complete
}

class MusicHelper {
    
    static let sharedHelper = MusicHelper()
    
    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "background", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }

    var playerPhoenix: AVAudioPlayer?

    func playSoundPhoenix() {
        playSoundFire()
        guard let path = Bundle.main.path(forResource: "phoenix", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            playerPhoenix = try AVAudioPlayer(contentsOf: url)
            playerPhoenix?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var playerFire: AVAudioPlayer?
    
    func playSoundFire() {
        guard let path = Bundle.main.path(forResource: "fire", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            playerFire = try AVAudioPlayer(contentsOf: url)
            playerFire?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playLaugh() {
        guard let path = Bundle.main.path(forResource: "laugh", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            playerPhoenix = try AVAudioPlayer(contentsOf: url)
            playerPhoenix?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
