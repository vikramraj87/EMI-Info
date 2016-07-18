//
//  CreditCardCollectionViewController.swift
//  EMI Info
//
//  Created by Vikram Raj Gopinathan on 04/07/16.
//  Copyright © 2016 Kivi. All rights reserved.
//
import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class CreditCardCollectionViewController: UICollectionViewController, SegueHandlerType, DataProviderDelegate, CollectionViewDataSourceDelegate, ManagedObjectContextConsumer, FetchedResultsControllerProvider {
    // MARK: SegueHandlerType
    enum SegueIdentifier: String {
        case creditCardAdd = "CreditCardAddSegue"
        case creditCardShow = "CreditCardShowSegue"
        case creditCardEMI = "CreditCardEMISegue"
    }
    
    static let emiUpdatedNotification = Notification.Name("com.kivi.emi-info.EMIUpdated")
    
    // MARK: -
    // MARK: Aliases
    private typealias FRDataProvider = FetchedResultsDataProvider<CreditCard, CreditCardCollectionViewController>
    private typealias CVDataSource = CollectionViewDataSource<CreditCard, FRDataProvider, CreditCardCollectionViewCell, CreditCardCollectionViewController>
    
    // MARK: -
    // MARK: Private stored property
    private var dataSource: CVDataSource!
    private var dataProvider: FRDataProvider!
    
    // MARK: -
    // MARK: ManagedObjectContextConsumer
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: -
    // MARK: FetchedResultsControllerProvider
    typealias FetchResultProvider = CreditCard
    
    // MARK: -
    // MARK: ReuseCellIdentifierProvider and DataProviderDelegate
    typealias Object = CreditCard
    
    func cellIdentifier(for object: Object) -> String {
        return "CreditCardCollectionViewCell"
    }
    
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    func headerView(for indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as? CreditCardCollectionReusableView else {
            fatalError("Header view not available")
        }
        
        guard let creditCards = dataProvider.allObjects() where creditCards.count > 0 else {
            headerView.titleLabel.text = "No credit cards added"
            return headerView
        }
        
        let totalMonthlyInstallment = creditCards.reduce(0.0) { $0 + $1.totalActiveMonthlyInstallments(at: Date()) }
        let totalMonthlyInstallmentAmount = CreditCardCollectionViewController.currencyFormatter.string(from: NSNumber(value: totalMonthlyInstallment))!
        
        headerView.titleLabel.text = "Total Monthly Installment: \(totalMonthlyInstallmentAmount)"
        return headerView
    }
    
    func dataProviderDidUpdate(with updates: [DataProviderUpdate<Object>]) {
        dataSource.processUpdates(updates)
    }
    
    // MARK: -
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(emiDidUpdated(_:)), name: CreditCardCollectionViewController.emiUpdatedNotification, object: nil)
        
        setupCollectionView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if var managedObjectContextConsumer = segue.destinationViewController as? ManagedObjectContextConsumer {
            managedObjectContextConsumer.managedObjectContext = managedObjectContext
        }
        switch segueIdentifier(for: segue) {
        case .creditCardAdd:
            guard let _ = segue.destinationViewController as? CreditCardDetailViewController else {
                fatalError("Invalid controller")
            }
            break
        case .creditCardShow:
            guard let creditCardDetailViewController = segue.destinationViewController as? CreditCardDetailViewController else {
                fatalError("Invalid controller")
            }
            
            guard let creditCardCell = (sender as! UIButton).superviewWithClassName("UICollectionViewCell") as? CreditCardCollectionViewCell else {
                fatalError("Not able to find the cell from button")
            }
            let creditCard = dataSource.object(for: creditCardCell)
            creditCardDetailViewController.creditCard = creditCard
        case .creditCardEMI:
            guard let emiTableViewController = segue.destinationViewController as? EMITableViewController else {
                fatalError("Invalid controller")
            }
            guard let cell = sender as? CreditCardCollectionViewCell else {
                fatalError("Sender Invalid")
            }
            let creditCard = dataSource.object(for: cell)
            emiTableViewController.creditCard = creditCard
        }
    }
    
    func emiDidUpdated(_ notification: Notification) {
        let indexSet = IndexSet(integer: 0)
        collectionView?.reloadSections(indexSet)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: -
    // MARK: Helpers
    private func setupCollectionView() {
        let fetchedResultsController = self.fetchedResultsController(withConfigurationHandler: nil)
        dataProvider = FRDataProvider(fetchedResultsController: fetchedResultsController, delegate: self)
        dataSource = CVDataSource(collectionView: collectionView!, dataProvider: dataProvider, cellIdentifierProvider: self)
    }
}
