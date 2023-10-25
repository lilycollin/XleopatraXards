
import UIKit

class InstructionVC: UIViewController, UITextViewDelegate {
    
    var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setupTextView()
        view.backgroundColor = .clear
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        let hookView = UIView()
        hookView.backgroundColor = .label
        hookView.translatesAutoresizingMaskIntoConstraints = false
        hookView.clipsToBounds = true
        hookView.layer.cornerRadius = 3
        view.addSubview(hookView)
        NSLayoutConstraint.activate([
            hookView.topAnchor.constraint(equalTo: view.topAnchor, constant: 7),
            hookView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            hookView.heightAnchor.constraint(equalToConstant: 6),
            hookView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupTextView(){
        textView = UITextView()
        textView.font = UIFont(name: "AvenirNext-Regular", size: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 10
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        if let filePath = Bundle.main.path(forResource: "instruction", ofType: "txt") {
            do {
                let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
                textView.text = fileContents
            } catch {
                print("Error reading file: \(error)")
            }
        }
    }
}
