import UIKit
import RxSwift
import RxCocoa

final class BusEditorTableViewController: UITableViewController, BusEditorViewProtocol {
    private var currentCheckCellIndexPath: IndexPath!
    private var selectingCellIndexPath: IndexPath!
    private var busKind: BusKind = .kamigamo
    
    var updateTrigger: Signal<BusKind> {
        return updateRelay.asSignal()
    }
    private let updateRelay = PublishRelay<BusKind>()
    
    var presentTrigger: Signal<Void> {
        return presentRelay.asSignal()
    }
    private let presentRelay = PublishRelay<Void>()
    
    private let viewModel = BusEditorViewModel()
    private var presenter: BusEditorPresenterProtocol!
    private let disposeBag = DisposeBag()
    
    func inject(_ presenter: BusEditorPresenterProtocol) {
        self.presenter = presenter
    }
    
    private func cancel() {
        configure()
        let selectingCell = tableView.cellForRow(at: selectingCellIndexPath)
        selectingCell?.accessoryType = .none
        tableView.reloadData()
    }
    
    private func showAlert(alertContents: AlertContents) {
        let alert: UIAlertController = UIAlertController(title: alertContents.title, message: alertContents.message, preferredStyle: .alert)
        
        switch alertContents {
        case .confirmationOfChanges(let item):
            let defaultAction: UIAlertAction = UIAlertAction(title: "変更する", style: .default, handler: { [weak self]
                (action: UIAlertAction!) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.updateRelay.accept(item)
            })
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "変更しない", style: .cancel, handler: { [weak self]
                (action: UIAlertAction!) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.cancel()
            })
            
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            
        case .done(_):
            let defaultAction: UIAlertAction = UIAlertAction(title: "確認", style: .default, handler: { [weak self] (action: UIAlertAction!) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.presentRelay.accept(())
            })
            alert.addAction(defaultAction)
            
        default:
            let defaultAction: UIAlertAction = UIAlertAction(title: "戻る", style: .default, handler: nil)
            alert.addAction(defaultAction)
        }

        present(alert, animated: true, completion: nil)
    }
    
    private func configure() {
        let busKind = BusManager.getBusKindForUserDefaults()
        if let busKind = busKind {
            self.busKind = busKind
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        title = "バス変更"
        
        tableView.isScrollEnabled = false
        presenter.viewState
            .drive(onNext: { [weak self] busKind in
                guard let strongSelf = self else { return }
                if let busKind = busKind {
                    strongSelf.showAlert(alertContents: AlertContents.done(item: busKind))
                    strongSelf.configure()
                    strongSelf.tableView.reloadData()
                } else {
                    strongSelf.showAlert(alertContents: AlertContents.cantSave)
                }
            })
            .disposed(by: disposeBag)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "busKindCell")
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "busKindCell", for: indexPath)
        cell.textLabel?.text = viewModel.items[indexPath.row].title
        if viewModel.items[indexPath.row] == busKind {
            cell.accessoryType = .checkmark
            currentCheckCellIndexPath = indexPath
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCheckCell = tableView.cellForRow(at: currentCheckCellIndexPath)
        currentCheckCell?.accessoryType = .none
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        let item = viewModel.items[indexPath.row]
        self.selectingCellIndexPath = indexPath
        showAlert(alertContents: AlertContents.confirmationOfChanges(item: item))
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}
