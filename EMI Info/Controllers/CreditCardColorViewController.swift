import UIKit

class CreditCardColorViewController: UIViewController {
    
    @IBOutlet weak var creditCardView: CreditCardView!
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var lastFourNumbersLabel: UILabel!
    @IBOutlet weak var billDayLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var name: String!
    var bank: String!
    var lastFourNumbers: String!
    var billDay: String!
    
    var color: UIColor! {
        didSet {
            if creditCardView != nil {
                creditCardView.backgroundColor = color
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creditCardView.backgroundColor = color
        NotificationCenter.default.addObserver(self, selector: #selector(creditCardUpdated(_:)), name: CreditCardDetailViewController.creditCardPropertyUpdatedNotification, object: nil)
        stackView.frame.origin = CGPoint(x: 8, y: 8)
        updateView()
    }
    
    func creditCardUpdated(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        if let name = userInfo[CreditCardDetailViewController.CreditCardProperyUpdateNotificationInfoKey.name.rawValue] as? String {
            self.name = name
        }
        
        if let bank = userInfo[CreditCardDetailViewController.CreditCardProperyUpdateNotificationInfoKey.bank.rawValue] as? String {
            self.bank = bank
        }
        
        if let lastFourNumbers = userInfo[CreditCardDetailViewController.CreditCardProperyUpdateNotificationInfoKey.lastFourNumbers.rawValue] as? String {
            self.lastFourNumbers = lastFourNumbers
        }
        
        if let billDay = userInfo[CreditCardDetailViewController.CreditCardProperyUpdateNotificationInfoKey.billDay.rawValue] as? String {
            self.billDay = billDay
        }
        
        updateView()
    }
    
    private func updateView() {
        nameLabel.text = name
        bankLabel.text = bank
        if !lastFourNumbers.isEmpty {
            lastFourNumbersLabel.text = "XXXX XXXX XXXX \(lastFourNumbers!)"
        } else {
            lastFourNumbersLabel.text = ""
        }
        billDayLabel.text = billDay!
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
