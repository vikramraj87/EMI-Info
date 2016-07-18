import UIKit
import CoreData

class EMITableViewController: UITableViewController, ManagedObjectContextConsumer, SegueHandlerType, DataProviderDelegate, TableViewDataSourceDelegate, FetchedResultsControllerProvider {
    
    // MARK: SegueHandlerType
    enum SegueIdentifier: String {
        case addEMISegue = "AddEMISegue"
        case updateEMISegue = "UpdateEMISegue"
    }
    
    // MARK: -
    // MARK: Aliases
    private typealias FRDataProvider = FetchedResultsDataProvider<EMI, EMITableViewController>
    private typealias TVDataSource = TableViewDataSource<EMI, FRDataProvider, EMITableViewCell, EMITableViewController>
    
    // MARK: -
    // MARK: Properties
    var creditCard: CreditCard!
    private var dataSource: TVDataSource!
    private var dataProvider: FRDataProvider!
    
    // MARK: -
    // MARK: ManagedObjectContextConsumer
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: -
    // MARK: FetchedResultsControllerProvider
    typealias FetchResultProvider = EMI
    
    // MARK: -
    // MARK: TableViewDataSourceDelegate and DataProviderDelegate
    typealias Object = EMI
    
    func cellIdentifier(for object: Object) -> String {
        return "EMITableViewCell"
    }
    
    func dataProviderDidUpdate(with updates: [DataProviderUpdate<Object>]) {
        dataSource.processUpdates(updates)
    }
    
    // MARK: -
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Set manage object context for view controllers requiring managedObjectContext
        if var destinationViewController = segue.destinationViewController as? ManagedObjectContextConsumer {
            destinationViewController.managedObjectContext = managedObjectContext
        }
        
        switch segueIdentifier(for: segue) {
        case .addEMISegue:
            guard let emiDetailViewController = segue.destinationViewController as? EMIDetailViewController else {
                fatalError("Invalid controller")
            }
            emiDetailViewController.creditCard = creditCard!
        case .updateEMISegue:
            guard let emiDetailViewController = segue.destinationViewController as? EMIDetailViewController else {
                fatalError("Invalid controller")
            }
            emiDetailViewController.emi = dataSource.object(for: sender as! EMITableViewCell)
            emiDetailViewController.creditCard = creditCard!
        }
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    // MARK: -
    // MARK: Helper Methods
    private func setupTableView() {
        let fetchedResultsController = self.fetchedResultsController {
            fetchRequest in
            
            let predicate = Predicate(format: "creditCard = %@", self.creditCard)
            fetchRequest.predicate = predicate
        }
        dataProvider = FRDataProvider(fetchedResultsController: fetchedResultsController, delegate: self)
        dataSource = TVDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    }
}
