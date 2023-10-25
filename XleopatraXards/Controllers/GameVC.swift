import UIKit
import SpriteKit
import SwiftyGif
import GameKit

class GameVC: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var menuButton: UIButton!
    
    var win = false
    
    var backgroundImageView: UIImageView!
    
    var level: Int = 1
    
    var scene: GameScene!
    
    var stackView: UIStackView!
    
    var rows: Int = 4
    var columns: Int = 3
    
    var maxOpenCards = 2
    
    var boardView: UIView!
    
    var cards: [CardButton] = []
    
    var symbols: [Card] = []
    
    var openCards: [CardButton] = [] {
        didSet {
            if openCards.count == maxOpenCards {
                boardView.isUserInteractionEnabled = false
                if allCardsAreTheSame() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        for card in self.openCards {
                            card.complete()
                            self.cards.remove(at: self.cards.firstIndex(of: card)!)
                            card.isUserInteractionEnabled = false
                        }
                        self.openCards = []
                        self.boardView.isUserInteractionEnabled = true
                        if self.cards.count == 0 {
                            self.nextLevel()
                            self.scene.complete()
                        } else {
                            self.scene.fire()
                        }
                    })
                    succes(true)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        for card in self.openCards {
                            card.flip()
                        }
                        self.openCards = []
                        self.boardView.isUserInteractionEnabled = true
                    })
                    succes(false)
                }
            }
        }
    }
    
    func succes(_ success: Bool) {
        let imageView = UIImageView()
        if success {
            switch Int.random(in: 1...2) {
            case 1:
                imageView.image = UIImage(named: "Wow!@4x")
            case 2:
                imageView.image = UIImage(named: "Great!@4x")
            default:
                imageView.image = UIImage(named: "Wow!@4x")
            }
        } else {
            switch Int.random(in: 1...2) {
            case 1:
                imageView.image = UIImage(named: "Oops!@4x")
            case 2:
                imageView.image = UIImage(named: "Try again!@4x")
            default:
                imageView.image = UIImage(named: "Oops!@4x")
            }
        }
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.height*0.2),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
        ])
        
        UIView.animate(withDuration: 0.5, animations: {
            imageView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                imageView.alpha = 0
            }) { _ in
                imageView.removeFromSuperview()
            }
        }
    }
    
    
    func allCardsAreTheSame() -> Bool {
        var symbol: String? = nil
        for card in openCards {
            if symbol == nil {
                symbol = card.symbol
            } else {
                if card.symbol != symbol! {
                    return false
                }
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let achievement = GKAchievement(identifier: "firstimpression")
        achievement.percentComplete = 100.0 // Achieved 100%
        achievement.showsCompletionBanner = true
        GKAchievement.report([achievement]) { error in
            if let error = error {
                // Handle reporting error.
                print("Achievement report error: \(error.localizedDescription)")
            } else {
                // Achievement reported successfully.
            }
        }
        setupBackground()
        configureLevelData()
        
        setupProgress()
        setupBoard()
        setupButtons()
    }
    
    func setupButtons() {
        menuButton = UIButton()
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.setImage(UIImage(named: "btn_menu"), for: .normal)
        menuButton.imageView?.contentMode = .scaleAspectFit
        view.addSubview(menuButton)
        menuButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        NSLayoutConstraint.activate([
            menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            menuButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            menuButton.heightAnchor.constraint(equalTo: menuButton.widthAnchor)
        ])
    }
    
    func setupProgress() {
        if stackView != nil {
            stackView.removeFromSuperview()
        }
        stackView = nil
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 10
        stackView.backgroundColor = .brown
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<4 {
            let squareView = UIView()
            squareView.clipsToBounds = true
            squareView.layer.cornerRadius = 10
            squareView.layer.borderColor = UIColor(ciColor: .black).cgColor
            squareView.layer.borderWidth = 2
            squareView.backgroundColor = (i < level - 1) ? UIColor(ciColor: .cyan) : UIColor(ciColor: .red)
            squareView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(squareView)
        }
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95)
        ])
    }
    
    func setupBackground() {
        let skView = SKView(frame: view.bounds)
        skView.backgroundColor = .clear
        view.addSubview(skView)
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    func nextLevel() {
        level += 1
        setupProgress()
        configureLevelData()
        if !win {
            setupBoard()
        } else {
            win = false
            let achievement = GKAchievement(identifier: "firstwin")
            achievement.percentComplete = 100.0 // Achieved 100%
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement]) { error in
                if let error = error {
                    // Handle reporting error.
                    print("Achievement report error: \(error.localizedDescription)")
                } else {
                    // Achievement reported successfully.
                }
            }
            runWin()
            level = 1
            configureLevelData()
            scene.next()
            let gifImageView = PlatformImageView(gifImage: try! UIImage(gifName: "phoenix.gif"))
            gifImageView.startAnimatingGif()
            MusicHelper.sharedHelper.playSoundPhoenix()
            gifImageView.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                gifImageView.alpha = 1
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    UIView.animate(withDuration: 0.5, animations: {
                        gifImageView.alpha = 0
                    }) { _ in
                        gifImageView.removeFromSuperview()
                        gifImageView.stopAnimating()
                    }
                })
            }
            gifImageView.contentMode = .scaleAspectFit
            gifImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(gifImageView)
            
            NSLayoutConstraint.activate([
                gifImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                gifImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                gifImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
                gifImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
                
            ])
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.setupProgress()
                self.setupBoard()
            })
        }
    }
    
    func runWin() {
        UIView.animate(withDuration: 0.5, animations: {
            self.stackView.alpha = 0
            self.boardView.alpha = 0
        }) { _ in
            self.stackView.isHidden = true
            self.boardView.isHidden = true
        }
    }
    
    func configureLevelData() {
        CardData.shared.shuffle()
        symbols = []
        cards = []
        openCards = []
        switch level {
        case 1:
            rows = 4
            columns = 2
            maxOpenCards = 2
            for i in 0..<4 {
                symbols.append(CardData.shared.cards[i])
                symbols.append(CardData.shared.cards[i])
            }
        case 2:
            rows = 4
            columns = 3
            maxOpenCards = 2
            for i in 0..<6 {
                symbols.append(CardData.shared.cards[i])
                symbols.append(CardData.shared.cards[i])
            }
        case 3:
            rows = 3
            columns = 5
            maxOpenCards = 3
            for i in 0..<5 {
                symbols.append(CardData.shared.cards[i])
                symbols.append(CardData.shared.cards[i])
                symbols.append(CardData.shared.cards[i])
            }
        case 4:
            rows = 3
            columns = 4
            maxOpenCards = 2
            for i in 0..<6 {
                symbols.append(CardData.shared.cards[i])
                symbols.append(CardData.shared.cards[i])
            }
        default:
            print("End")
            win = true
        }
        symbols.shuffle()
    }
    
    func setupBoard() {
        if boardView != nil {
            
            boardView.removeFromSuperview()
        }
        boardView = nil
        boardView = UIView()
        boardView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(boardView)
        
        NSLayoutConstraint.activate([
            boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            boardView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor)
        ])
        boardView.isUserInteractionEnabled = true
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = true
        
        for _ in 0..<rows {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.alignment = .fill
            rowStackView.spacing = 8
            
            for _ in 0..<columns {
                let button = CardButton()
                cards.append(button)
                button.setup()
                button.setCard(symbols[cards.firstIndex(of: button)!])
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                button.addTarget(self, action: #selector(tap), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
            }
            stackView.addArrangedSubview(rowStackView)
        }
        boardView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: boardView.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: boardView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: boardView.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: boardView.bottomAnchor, constant: -16).isActive = true
    }
    
    @objc func tap(_ sender: CardButton) {
        if sender.cardState == .closed {
            openCards.append(sender)
            sender.flip()
        }
    }
}
