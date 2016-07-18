import UIKit
import CoreData
import ValidationKitiOS

class EMIDetailViewController: UIViewController, ManagedObjectContextConsumer {

    weak var startDayPicker: UIDatePicker!
    @IBOutlet weak var monthsTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emiStartDateLabel: UILabel!
    
    var emi: EMI?
    
    var creditCard: CreditCard!
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDatePicker()
        initializeTextFields()
    }
    
    @IBAction func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func initializeTextFields() {
        monthsTextField.delegate = self
        amountTextField.delegate = self
        nameTextField.delegate = self
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEMI(_:)))
        
        guard let emi = emi else {
            navigationItem.rightBarButtonItems = [saveButton]
            return
        }
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteEMI(_:)))
        
        navigationItem.rightBarButtonItems = [saveButton, deleteButton]
        
        nameTextField.text = emi.name
        amountTextField.text = String(emi.monthlyInstallment!)
        monthsTextField.text = String(emi.numberOfInstallments)
        
        guard let date = emi.startDate else { return }
        startDayPicker.date = Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
    }
    
    private func initializeDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        datePicker.maximumDate = Date()
        
        let calendar = Calendar(calendarIdentifier: .gregorian)!
        datePicker.minimumDate = calendar.date(byAdding: .month, value: -240, to: Date(), options: Calendar.Options.matchStrictly)
        
        startDayPicker = datePicker
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: emiStartDateLabel.bottomAnchor, constant: 8.0).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension EMIDetailViewController: ValidatableTextFieldDelegate {
    func textFieldsForValidation() -> [UITextField]? {
        return [
            nameTextField,
            monthsTextField,
            amountTextField
        ]
    }
    
    func validatorChain(for textField: UITextField) -> ValidatorChain? {
        switch textField {
            
        case nameTextField:
            return ValidatorChain(validators: [
                RequiredValidator(),
                NameValidator()
                ])
        case monthsTextField:
            return ValidatorChain(validators: [
                RequiredValidator(),
                IntegerValidator(minimum: 1, maximum: 720)
                ])
        case amountTextField:
            return ValidatorChain(validators: [
                RequiredValidator(),
                DecimalValidator(minimum: 0.0, maximum: 1_00_00_000.0, maximumFractionalPlaces: 2)
                ])
        default:
            return nil
        }
    }
    
    func failedValidator(for textField: UITextField) -> (([(Validator, FailedValidationReason)]?) -> Void)? {
        let field: String
        
        switch textField {
        case nameTextField:
            field = "Name text field"
        case monthsTextField:
            field = "Months text field"
        case amountTextField:
            field = "Amount text field"
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
    
    func saveEMI(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        let result = validate()
        guard result else {
            return
        }
        
        if emi == nil {
            emi = EMI(context: managedObjectContext)
        }
        
        let monthlyInstallment = NSDecimalNumber(string: amountTextField.text!)
        let numberOfInstallments = Formatters.monthsFormatter.number(from: monthsTextField.text!)!.int16Value
        
        emi!.name = nameTextField.text
        emi!.monthlyInstallment = monthlyInstallment
        emi!.numberOfInstallments = numberOfInstallments
        emi!.startDate = startDayPicker.date as NSDate
        emi!.creditCard = creditCard
        
        saveContext()
        
        NotificationCenter.default.post(name: CreditCardCollectionViewController.emiUpdatedNotification, object: nil)
        
        navigationController!.popViewController(animated: true)
    }
    
    func deleteEMI(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        let message = "Do you really want to delete the emi \"\(emi!.name)\"?"
        
        let actionSheet = UIAlertController(title: "Delete EMI", message: message, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Yes, Delete it", style: .destructive) {
            action in
            
            self.managedObjectContext.delete(self.emi!)
            self.saveContext()
            
            NotificationCenter.default.post(name: CreditCardCollectionViewController.emiUpdatedNotification, object: nil)
            
            self.navigationController!.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }

}
