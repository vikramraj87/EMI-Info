import UIKit
import CoreData

class CreditCardDetailViewController: UIViewController, SegueHandlerType, UIPageViewControllerDelegate, ManagedObjectContextConsumer {
    // MARK: SegueHandlerType
    enum SegueIdentifier: String {
        case creditCardPageViewControllerEmbedSege = "CreditCardPageViewControllerEmbedSegue"
    }
    
    // MARK:-
    // MARK: Notifications and UserInfoKeys
    static let creditCardPropertyUpdatedNotification = Notification.Name("com.kivi.emi-info.creditCardPropertyUpdatedNotification")
    
    enum CreditCardProperyUpdateNotificationInfoKey: String {
        case name = "com.kivi.emi-info.CreditCardNameKey"
        case bank = "com.kivi.emi-info.CreditCardBankKey"
        case lastFourNumbers = "com.kivi.emi-info.CreditCardLastFourNumbersKey"
        case billDay = "com.kivi.emi-info.CreditCardBillDayKey"
    }
    
    // MARK:-
    // MARK: Stored Properties
    var creditCard: CreditCard?
    
    // Keeps track of current color for saving
    var currentColor: UIColor!
    
    // MARK:-
    // MARK: ManageObjectContextConsumer
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK:-
    // MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bankTextField: UITextField!
    @IBOutlet weak var lastFourNumbersTextField: UITextField!
    @IBOutlet weak var billDayTextField: UITextField!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK:-
    // MARK: UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // Check whether the transition is completed and not cancelled
        guard completed else {
            return
        }
        
        // Get info from the current controller of page view controller
        let creditCardPageViewController = pageViewController as! CreditCardPageViewController
        
        let currentViewController = creditCardPageViewController.viewControllers![0] as! CreditCardColorViewController
        
        let currentPage = creditCardPageViewController.pageNumber(for: currentViewController)
        
        currentColor = currentViewController.color
        pageControl.currentPage = currentPage
    }
    
    // MARK:-
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerObservers()
        
        if let card = creditCard {
            populateView(with: card)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifier(for: segue) {
        case .creditCardPageViewControllerEmbedSege:
            guard let creditCardPageViewController = segue.destinationViewController as? CreditCardPageViewController else {
                fatalError("Unrecognized embedded page view controller")
            }
            
            // Set the total number of pages from page view controller
            // for UIPageControl
            pageControl.numberOfPages = creditCardPageViewController.numberOfPages
            
            
            // Set the delegate as self so that we can set
            // current page of UIPageControl to the current page
            // of UIPageViewController
            creditCardPageViewController.delegate = self
            currentColor = creditCardPageViewController.currentColor
            
            guard let card = creditCard else {
                break
            }
            
            pageControl.currentPage = creditCardPageViewController.populate(with: card)
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue()
        scrollView.contentInset.bottom = keyboardSize.height
        scrollView.scrollIndicatorInsets.bottom = keyboardSize.height
    }
    
    func keyboardWillBeHidden(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    // MARK: -
    // MARK: Helpers
    private func registerObservers() {
        // Register NotificationCenter observers
        // Keyboard notifications for setting scrollview insets
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func populateView(with card: CreditCard) {
        deleteButton.isHidden = false
        
        nameTextField.text = card.name
        bankTextField.text = card.issuingBank
        lastFourNumbersTextField.text = Formatters.creditCardLastFourNumberFormatter.string(from: NSNumber(value: card.lastFourNumbers))
        billDayTextField.text = Formatters.creditCardBillDayFormatter.string(from: NSNumber(value: card.billDay))
    }
}

extension CreditCardDetailViewController: ValidatableTextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        var userInfoKey: CreditCardDetailViewController.CreditCardProperyUpdateNotificationInfoKey?
        let value: String = textField.text ?? ""
        
        switch textField {
        case nameTextField:
            userInfoKey = .name
        case bankTextField:
            userInfoKey = .bank
        case lastFourNumbersTextField:
            userInfoKey = .lastFourNumbers
        case billDayTextField:
            userInfoKey = .billDay
        default:
            userInfoKey = nil
        }
        
        if let key = userInfoKey {
            let userInfo: [String: String] = [key.rawValue: value]
            NotificationCenter.default.post(name: CreditCardDetailViewController.creditCardPropertyUpdatedNotification, object: nil, userInfo: userInfo)
        }
    }
    
    func validatorChain(for textField: UITextField) -> ValidatorChain? {
        switch textField {
        case nameTextField, bankTextField:
            return ValidatorChain(validators: [
                RequiredValidator(),
                NameValidator()
            ])
        case lastFourNumbersTextField:
            return ValidatorChain(validators: [
                RequiredValidator(),
                DigitsValidator(minimumLength: 4, maximumLength: 4)
            ])
        case billDayTextField:
            return ValidatorChain(validators: [
                RequiredValidator(),
                DigitsValidator(minimumLength: 1, maximumLength: 2),
                IntegerValidator(minimum: 1, maximum: 31)
            ])
        default:
            return nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.characters.count > 0 else {
            return true
        }
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if var validatorChain = validatorChain(for: textField) {
            return validatorChain.liveValidate(incompleteString: prospectiveText)
        }
        
        return true
    }
    
    func textFieldsForValidation() -> [UITextField]? {
        return [
            nameTextField,
            bankTextField,
            lastFourNumbersTextField,
            billDayTextField
        ]
    }
    
    func failedValidator(for textField: UITextField) -> (([(Validator, FailedValidationReason)]?) -> Void)? {
        let field: String
        switch textField {
        case nameTextField:
            field = "Name text field"
        case bankTextField:
            field = "Bank text field"
        case lastFourNumbersTextField:
            field = "Last four numbers text field"
        case billDayTextField:
            field = "Bill day text field"
        default:
            field = ""
        }
        
        return {
            failedValidatorsAndReasons in
            if let failedValidators = failedValidatorsAndReasons {
                if failedValidators.count > 0 {
                    let (_, failedReason) = failedValidators.first!
                    print("\(field):")
                    print(failedReason.rawValue)
                }
            }
        }
    }
    
    @IBAction func saveCreditCard(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        let result = validate()
        guard result else {
            return
        }
        
        if creditCard == nil {
            creditCard = CreditCard(context: managedObjectContext)
        }
        
        save(creditCard!)
        
        NotificationCenter.default.post(name: CreditCardCollectionViewController.emiUpdatedNotification, object: nil)
        
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func deleteCreditCard(_ sender: UIButton) {
        view.endEditing(true)
        let message = "Do you really want to delete the card \"\(creditCard!.name!)\" and all the EMIs associated with it?"
        
        let actionSheet = UIAlertController(title: "Delete credit card", message: message, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Yes, Delete it", style: .destructive) {
            action in
            
            self.delete(self.creditCard!)
            
            NotificationCenter.default.post(name: CreditCardCollectionViewController.emiUpdatedNotification, object: nil)
            
            self.navigationController!.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func save(_ card: CreditCard) {
        let lastFourNumbers = Formatters.creditCardLastFourNumberFormatter.number(from: lastFourNumbersTextField.text!)!.int16Value
        let billDay = Formatters.creditCardBillDayFormatter.number(from: billDayTextField.text!)!.int16Value
        
        card.name = nameTextField.text!
        card.issuingBank = bankTextField.text!
        card.lastFourNumbers = lastFourNumbers
        card.billDay = billDay
        card.color = currentColor!
        
        saveContext()
    }
    
    private func delete(_ card: CreditCard) {
        self.managedObjectContext.delete(card)
        self.saveContext()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension CreditCardDetailViewController: UIActionSheetDelegate {
    
}
