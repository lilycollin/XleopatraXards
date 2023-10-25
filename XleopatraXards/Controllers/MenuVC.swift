import UIKit
import SwiftyGif
import GameKit

class MenuVC: UIViewController, GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var isLaugh = false
    
    var playButton: UIButton!
    var instructionButton: UIButton!
    var backgroundImageView: UIImageView!
    var gameCenterButton: UIButton!
    
    var logoImageView: UIImageView!
    
    var gifImageView: PlatformImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GKLocalPlayer.local.isAuthenticated {
        } else {
            GKLocalPlayer.local.authenticateHandler = { viewController, error in
                if GKLocalPlayer.local.isAuthenticated {
                    // Player authenticated, enable Game Center features.
                } else if let vc = viewController {
                    // Present the authentication view controller to the player.
                    self.present(vc, animated: true, completion: nil)
                } else {
                    // Handle authentication error.
                    print("Game Center authentication error: \(error?.localizedDescription ?? "Unknown Error")")
                }
            }
        }
        MusicHelper.sharedHelper.playBackgroundMusic()
        setupBackground()
        
        gifImageView = PlatformImageView(gifImage: try! UIImage(gifName: "character.gif"))
        gifImageView.isUserInteractionEnabled = true
        gifImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(laugh)))
        
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gifImageView)
        
        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "logo_хleopatra_хards")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            gifImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gifImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.height*0.2),
            gifImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.3),
            gifImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.3),
            
            logoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3)

        ])
        setupButtons()
    }
    
    @objc func laugh() {
        if !isLaugh {
            Vibration.medium.vibrate()
            MusicHelper.sharedHelper.playLaugh()
            isLaugh = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.isLaugh = false
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gifImageView.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        gifImageView.stopAnimating()
    }
    
    func setupBackground() {
        backgroundImageView = UIImageView()
        backgroundImageView.frame = view.frame
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
    }
    
    func setupButtons(){
        playButton = UIButton(type: .custom)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setImage(UIImage(named: "btn_play"), for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        playButton.alpha = 0
        view.addSubview(playButton)
        
        instructionButton = UIButton(type: .custom)
        instructionButton.translatesAutoresizingMaskIntoConstraints = false
        instructionButton.setImage(UIImage(named: "btn_information"), for: .normal)
        instructionButton.imageView?.contentMode = .scaleAspectFit
        instructionButton.addTarget(self, action: #selector(instruction), for: .touchUpInside)
        instructionButton.alpha = 0
        view.addSubview(instructionButton)
        
        gameCenterButton = UIButton(type: .custom)
        gameCenterButton.translatesAutoresizingMaskIntoConstraints = false
        gameCenterButton.setImage(UIImage(named: "game center"), for: .normal)
        gameCenterButton.imageView?.contentMode = .scaleAspectFit
        gameCenterButton.addTarget(self, action: #selector(gameCenter), for: .touchUpInside)
        gameCenterButton.alpha = 0
        view.addSubview(gameCenterButton)
        
        NSLayoutConstraint.activate([
            playButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 15),
            playButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            playButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
            
            instructionButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -15),
            instructionButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            instructionButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            instructionButton.widthAnchor.constraint(equalTo: instructionButton.heightAnchor),
            
            gameCenterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            gameCenterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            gameCenterButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            gameCenterButton.heightAnchor.constraint(equalToConstant: 80)
            
        ])
        
        UIView.animate(withDuration: 0.5, animations: {
            self.playButton.alpha = 1
            self.instructionButton.alpha = 1
            self.gameCenterButton.alpha = 1
        }) { _ in
            
        }
    }
    
    @objc func play(){
        let vc = GameVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func instruction(){
        let vc = InstructionVC()
        self.present(vc, animated: true)
    }
    
    @objc func gameCenter(){
            let gcViewController = GKGameCenterViewController()
            gcViewController.gameCenterDelegate = self
            self.present(gcViewController, animated: true, completion: nil)
    }
}
