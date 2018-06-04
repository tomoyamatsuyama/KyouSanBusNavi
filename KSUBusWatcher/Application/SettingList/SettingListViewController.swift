import UIKit
import RxSwift
import RxCocoa

final class SettingListViewController: UITableViewController, SettingListViewProtocol {
    private var viewModel: SettingListViewModel = .init()
    private var presenter: SettingListPresenterProtocol!
    
    private let disposeBag = DisposeBag()
    
    var presentTrigger: Signal<SettingListViewModel.Section.Item> {
        return presentRelay.asSignal()
    }
    private let presentRelay = PublishRelay<SettingListViewModel.Section.Item>()
    
    func inject(_ presenter: SettingListPresenterProtocol) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "その他"
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingListCell")
        tableView.isScrollEnabled = false
        presenter.viewModel
            .drive(onNext: { [weak self] responseViewModel in
                guard let strongSelf = self else { return }
                strongSelf.viewModel = responseViewModel
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].item.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingListCell", for: indexPath)
        cell.textLabel?.text = viewModel.sections[indexPath.section].item[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentRelay.accept(viewModel.sections[indexPath.section].item[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }
}
