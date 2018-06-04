import UIKit
import RxCocoa
import RxSwift

final class TimeTableListViewController: UITableViewController, TimeTableListViewProtocol {
    private var presenter: TimeTableListPresenterProtocol!
    private let disposeBag = DisposeBag()
    private var viewModel = TimeTableListModel()
    
    var presentTrigger: Signal<TimeTableListModel.Section.Item> {
        return presentTriggerRelay.asSignal()
    }
    private let presentTriggerRelay = PublishRelay<TimeTableListModel.Section.Item>()
    
    func inject(_ presenter: TimeTableListPresenterProtocol) {
        self.presenter = presenter
    }
    
    @objc private func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        guard let view = gestureRecognizer.view as? SectionTableViewHeaderView else { return }
        
        viewModel.sections[view.section].isExpanded = !viewModel.sections[view.section].isExpanded
        let isExpanded = viewModel.sections[view.section].isExpanded
        
        if !isExpanded {
            let expandedRows = viewModel.sections[view.section].item.enumerated()
                                    .map{ IndexPath(row: $0.offset, section: view.section)}

            tableView.deleteRows(at: expandedRows, with: .automatic)
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integer: view.section), with: .fade)
            tableView.endUpdates()
        }
        
        tableView.reloadSections(IndexSet(integer: view.section), with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? SectionTableViewHeaderView
        
        if view == nil {
            view = SectionTableViewHeaderView(reuseIdentifier: "SectionHeader")
            view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(gestureRecognizer:))))
        }
        
        guard let header = view else { return view }
        header.section = section
        header.setImage(isExpanded: viewModel.sections[section].isExpanded)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = viewModel.sections[indexPath.section].item[indexPath.row].name
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].isExpanded ? viewModel.sections[section].item.count : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentTriggerRelay.accept(viewModel.sections[indexPath.section].item[indexPath.row])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        title = "時刻表"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "timeTableCell")
    }
}
