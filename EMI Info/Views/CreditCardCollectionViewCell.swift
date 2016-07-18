import UIKit

class CreditCardCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
    
    override func awakeFromNib() {
        sv.frame = CGRect(x: 8, y: 8, width: 284, height: 173)
    }
    
    @IBOutlet weak var creditCardView: CreditCardView!
    @IBOutlet weak var sv: UIStackView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalEMILabel: UILabel!
    @IBOutlet weak var billDayLabel: UILabel!
    
    typealias Object = CreditCard
    
    var creditCard: CreditCard!
    
    var lastFourNumbers: String {
        return "xxxx xxxx xxxx \(creditCard.lastFourNumbers)"
    }
    
    var nextBillDate: String {
        let date = CreditCardCollectionViewCell.billDateFormatter.string(from: creditCard.futureBillDate(for: Date()))
        return "\(date)"
    }
    
    var totalEMI: String {
        let amount = creditCard.totalActiveMonthlyInstallments(at: Date())
        let str = CreditCardCollectionViewCell.currencyFormatter.string(from: NSNumber(value: amount))!
        return "\(str)"
    }
    
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    static let billDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    

    
    func configure(for object: CreditCard) {
        creditCard = object
        
        nameLabel.text = creditCard.name
        bankLabel.text = creditCard.issuingBank
        numberLabel.text = lastFourNumbers
        billDayLabel.text = nextBillDate
        
        creditCardView.backgroundColor = creditCard.color as? UIColor
        totalEMILabel.text = totalEMI
        
    }
}
