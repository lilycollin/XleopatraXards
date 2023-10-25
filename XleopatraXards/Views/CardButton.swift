
import UIKit

class CardButton: UIButton {
    
    var card: Card!
    var symbol = ""
    
    var cardState: CardState = .closed

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(ciColor: .black).cgColor
        backgroundColor = .red
        imageView?.contentMode = .scaleAspectFill
        setImage(UIImage(named: "level_3"), for: .normal)
    }
    
    func setCard(_ card: Card) {
        self.card = card
        symbol = card.title
    }
    
    func flip() {
        if cardState == .closed {
            cardState = .open
            backgroundColor = .white
            imageView?.contentMode = .scaleAspectFit
            setImage(card.image, for: .normal)
        } else if cardState == .open {
            cardState = . closed
            backgroundColor = .red
            imageView?.contentMode = .scaleAspectFill
            setImage(UIImage(named: "level_3"), for: .normal)
        }
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    func complete() {
        cardState = .complete
        backgroundColor = .cyan
        imageView?.contentMode = .scaleAspectFill
        setImage(UIImage(named: "level_1"), for: .normal)
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
        self.isUserInteractionEnabled = false
    }
    
    

}
