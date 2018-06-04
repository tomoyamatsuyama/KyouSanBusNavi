import UIKit
import RxSwift
import RxCocoa

final class TimeTableDetailViewController: UIViewController, TimeTableDetailViewProtocol {
    @IBOutlet private weak var selectedSegment: UISegmentedControl!
    @IBOutlet private weak var directionLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    private var presenter: TimeTableDetailPresenterProtocol!
    private var timeList: [TimeTableDetailViewModel.Time] = []
    private let disposeBag = DisposeBag()
    private var busContents: BusContents!
    private let indicator = UIActivityIndicatorView()
    
    var refreshTrigger: Signal<BusContents> {
        return refreshTriggerRelay.asSignal()
    }
    private let refreshTriggerRelay = PublishRelay<BusContents>()
    
    var changeTimeTrigger: Signal<BusContents> {
        return changeTimeRelay.asSignal()
    }
    private let changeTimeRelay = PublishRelay<BusContents>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = busContents.busKind.title
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        
        if (busContents.busKind == .kamigamo || busContents.busKind == .niken) {
            selectedSegment.changeAllSegment(withArray: ["平日", "水曜", "土曜"])
        } else if busContents.busKind == .kokusai {
            selectedSegment.changeAllSegment(withArray: ["Aダイヤ", "Bダイヤ", "土曜", "日祝"])
        } else if busContents.busKind == .demachi {
            selectedSegment.changeAllSegment(withArray: ["平日", "土曜", "日祝", "Aダイヤ", "Cダイヤ"])
        } else {
            selectedSegment.changeAllSegment(withArray: ["平日", "土曜", "日祝"])
        }
        
        presenter.viewModel
            .drive(onNext:{ [weak self] viewModel in
                guard let strongSelf = self else { return }
                strongSelf.setUpView(for: viewModel)
            })
            .disposed(by: disposeBag)
        
        selectedSegment.rx.selectedSegmentIndex
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] index in
                guard let `self` = self else { return }
                var dayKind: DayKind?
                if (self.busContents.busKind == .kamigamo || self.busContents.busKind == .niken) {
                    guard let dayKindOfShuttle = DayKindOfShuttle(rawValue: index) else { return }
                    dayKind = DayKind(rawValue: dayKindOfShuttle.value)
                } else if self.busContents.busKind == .kokusai {
                    guard let dayKindOfKokusai = DayKindOfKokusai(rawValue: index) else { return }
                    dayKind = DayKind(rawValue: dayKindOfKokusai.value)
                } else if self.busContents.busKind == .kita {
                    guard let dayKindOfCityBus = DayKindOfCityBus(rawValue: index) else { return }
                    dayKind = DayKind(rawValue: dayKindOfCityBus.value)
                } else {
                    guard let dayKindOfDemachi = DayKindOfDemachi(rawValue: index) else { return }
                    dayKind = DayKind(rawValue: dayKindOfDemachi.value)
                }
                if let dayKind = dayKind {
                    self.busContents.dayKind = dayKind
                }
                self.changesTime()
            })
            .disposed(by: disposeBag)
    }
    
    //TODO: もうちょい綺麗に書ける。
    private func setUpView(for viewModel: TimeTableDetailViewModel) {
        stopIndicator(indicator: indicator)
        selectedSegment.isUserInteractionEnabled = true
        if let directionName = viewModel.directionName, let dayKind = viewModel.dayKind {
            directionLabel.text = directionName
            guard let dayKind = DayKind(rawValue: dayKind) else { return }
            self.busContents.dayKind = dayKind
            
            switch dayKind {
            case .weekday:
                selectedSegment.selectedSegmentIndex = 0
            case .saturday:
                if busContents.busKind == .kamigamo || busContents.busKind == .niken {
                    selectedSegment.selectedSegmentIndex = 2
                } else if busContents.busKind == .kokusai {
                    selectedSegment.selectedSegmentIndex = 2
                } else {
                    selectedSegment.selectedSegmentIndex = 1
                }
            case .wednesday:
                selectedSegment.selectedSegmentIndex = 1
            case .sunAndHoliday:
                if busContents.busKind == .kokusai {
                    selectedSegment.selectedSegmentIndex = 3
                } else {
                    selectedSegment.selectedSegmentIndex = 2
                }
            case .diaA:
                if busContents.busKind == .demachi {
                    selectedSegment.selectedSegmentIndex = 3
                } else {
                    selectedSegment.selectedSegmentIndex = 0
                }
            case .diaB:
                selectedSegment.selectedSegmentIndex = 1
            case .diaC:
                selectedSegment.selectedSegmentIndex = 4
            }
            
            timeList = viewModel.list
            tableView.reloadData()
        } else {
            showAlertView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startIndicator(indicator: indicator)
        selectedSegment.isUserInteractionEnabled = false
        refreshTriggerRelay.accept(busContents)
    }
    
    private func showAlertView() {
        let alert: UIAlertController = UIAlertController(title: "時刻表を読み込めませんでした。", message: "アプリを終了します", preferredStyle: .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "終了する", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            exit(0)
        })
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func changesTime() {
        let changeTimeModel = BusContents(busKind: busContents.busKind, dayKind: busContents.dayKind, directionKind: busContents.directionKind)
        startIndicator(indicator: indicator)
        selectedSegment.isUserInteractionEnabled = false
        changeTimeRelay.accept(changeTimeModel)
    }
    
    func inject(_ presenter: TimeTableDetailPresenterProtocol, with busContents: BusContents) {
        self.presenter = presenter
        self.busContents = busContents
    }
}

extension TimeTableDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeList[section].minutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if busContents.busKind == .kamigamo && busContents.dayKind == .weekday && busContents.directionKind == .back && indexPath.section == 0 {
            cell.textLabel?.text = "9:05までの間 約2~5分間隔で折り返し運行"
        } else if busContents.busKind == .kamigamo && busContents.dayKind == .weekday && busContents.directionKind == .there && indexPath.section == 0 {
            cell.textLabel?.text = "8:15~9:02 約2~5分間隔で折り返し運行"
        } else if busContents.busKind == .kamigamo && busContents.dayKind == .wednesday && busContents.directionKind == .back && indexPath.section == 0 {
            cell.textLabel?.text = "9:05までの間 約2~5分間隔で折り返し運行"
        } else if busContents.busKind == .kamigamo && busContents.dayKind == .wednesday && busContents.directionKind == .there && indexPath.section == 0 && indexPath.row == 1 {
            cell.textLabel?.text = "8:15~9:02 約2~5分間隔で折り返し運行"
            
        } else if busContents.busKind == .niken && (busContents.dayKind == .weekday || busContents.dayKind == .wednesday) && busContents.directionKind == .back && indexPath.section == 0 && indexPath.row == 1 {
            cell.textLabel?.text = "8:20~9:25 約5~10分間隔で折り返し運行"
        } else if busContents.busKind == .niken && (busContents.dayKind == .weekday || busContents.dayKind == .wednesday) && busContents.directionKind == .there && indexPath.section == 0 && indexPath.row == 1 {
            cell.textLabel?.text = "8:20~9:30 約5~10分間隔で折り返し運行"
            
        } else if busContents.busKind == .niken && (busContents.dayKind == .weekday || busContents.dayKind == .wednesday) && busContents.directionKind == .back && indexPath.section == 2 && indexPath.row == 1 {
            cell.textLabel?.text = "10:05~10:55 約5~10分間隔で折り返し運行"
        } else if busContents.busKind == .niken && (busContents.dayKind == .weekday || busContents.dayKind == .wednesday) && busContents.directionKind == .there && indexPath.section == 2 && indexPath.row == 1 {
            cell.textLabel?.text = "10:00~10:50 約5~10分間隔で折り返し運行"
            
        } else if busContents.busKind == .niken && busContents.dayKind == .weekday && busContents.directionKind == .back && indexPath.section == 6 && indexPath.row == 4 {
            cell.textLabel?.text = "14:50~15:20 約5~10分間隔で折り返し運行"
        } else if busContents.busKind == .niken && busContents.dayKind == .weekday && busContents.directionKind == .there && indexPath.section == 6 && indexPath.row == 4 {
            cell.textLabel?.text = "14:55~15:25 約5~10分間隔で折り返し運行"
        } else if busContents.busKind == .niken && busContents.dayKind == .weekday && busContents.directionKind == .back && indexPath.section == 8 && indexPath.row == 3 {
            cell.textLabel?.text = "16:30~17:10 約5~10分間隔で折り返し運行"
        } else if busContents.busKind == .niken && busContents.dayKind == .weekday && busContents.directionKind == .there && indexPath.section == 8 && indexPath.row == 3 {
            cell.textLabel?.text = "16:35~17:15 約5~10分間隔で折り返し運行"
        } else {
            cell.textLabel?.text = "\(timeList[indexPath.section].minutes[indexPath.row])"
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return timeList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(timeList[section].hour)時"
    }
}
