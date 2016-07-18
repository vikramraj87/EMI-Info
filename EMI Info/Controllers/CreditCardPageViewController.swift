import UIKit

class CreditCardPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    // MARK: Stored Properties
    // Colors using the RGB extension for credit card
    private let colors = [
        UIColor(red: 1, green: 38, blue: 54),
        UIColor(red: 22, green: 51, blue: 101),
        UIColor(red: 164, green: 0, blue: 71),
        UIColor(red: 19, green: 19, blue: 19),
        UIColor(red: 3, green: 86, blue: 138),
        UIColor(red: 9, green: 25, blue: 48)
    ]
    
    // Array of controllers for credit card of different color
    private var controllers: [CreditCardColorViewController] = []
    
    // Current controller of the pageView
    var currentController: CreditCardColorViewController!
    
    var currentColor: UIColor {
        if currentController == nil {
            return colors[0]
        }
        return currentController.color
    }
    
    // Properties to propagate to CreditCardColorViewController
    var name = ""
    var bank = ""
    var lastFourNumbers = ""
    var billDay = ""
    
    // MARK: -
    // MARK: Computed Properties
    var numberOfPages: Int {
        return colors.count
    }
    
    // Update the property according to change in UI
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
    }
    
    // MARK: -
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(creditCardUpdated(_:)), name: CreditCardDetailViewController.creditCardPropertyUpdatedNotification, object: nil)
        
        // If this is a update, the controllers might have already been initialized
        // Else initialize the first controller
        if controllers.count < 1 {
            let ctrl = viewController(for: 0)
            controllers.append(ctrl)
        }
        
        // Get the last controller in the array. If this is a update, this might be the color of the credit card.
        // Else the first controller will be the current controller
        currentController = controllers.last!
        self.setViewControllers([currentController], direction: .forward, animated: true, completion: nil)
        
    }
    
    // MARK: -
    // MARK: UIPageViewControllerDataSource
    // Providing view controllers
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? CreditCardColorViewController,
            let index = controllers.index(of: controller) else {
                fatalError("Invalid current controller")
        }
        
        guard index > 0 else {
            return nil
        }
        currentController = controllers[index - 1]
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? CreditCardColorViewController,
            let index = controllers.index(of: controller) else {
                fatalError("Invalid current controller")
        }
        
        guard index < colors.count - 1 else {
            return nil
        }
        
        if index + 2 > controllers.count {
            let nextController = self.viewController(for: index + 1)
            controllers.append(nextController)
        }
        
        currentController = controllers[index + 1]
        return controllers[index + 1]
    }

    private func viewController(for pageNumber: Int) -> CreditCardColorViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CreditCardColorViewController") as! CreditCardColorViewController
        
        controller.color = colors[pageNumber]
        
        controller.name = name
        controller.bank = bank
        controller.lastFourNumbers = lastFourNumbers
        controller.billDay = billDay
        
        return controller
    }
    
    // Returns the page number supposed to be the current page
    // when the view controller loads
    func populate(with card: CreditCard) -> Int {
        name = card.name ?? ""
        bank = card.issuingBank ?? ""
        lastFourNumbers = Formatters.creditCardLastFourNumberFormatter.string(from: NSNumber(value: card.lastFourNumbers)) ?? ""
        billDay = Formatters.creditCardBillDayFormatter.string(from: NSNumber(value: card.billDay)) ?? ""
        
        return initializeTillColor(color: card.color as! UIColor)
    }
    
    func pageNumber(for controller: CreditCardColorViewController) -> Int {
        return controllers.index(of: controller)!
    }
    
    // Returns the last index for setting the page number
    private func initializeTillColor(color: UIColor) -> Int {
        guard let index = colors.index(of: color) else {
            fatalError("Invalid color provided")
        }
        for i in 0...index {
            controllers.append(viewController(for: i))
        }
        return index
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
