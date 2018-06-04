import UIKit
import RxSwift
import RxCocoa

final class BusTimerViewController: UIViewController, BusTimerViewProtocol {
    private var presenter: BusTimerPresenterProtocol!
    private let disposeBag = DisposeBag()
    
    private var responseTimeList: [Time] = [] // ここで持たせない。
    private var date: Date! // Date
    private let formatter = DateFormatter()
    private var components: DateComponents!
    private var timer: Timer?
    private var busContents: BusContents!
    private var hourLabelText: String?
    private var minutesLabelText: String!
    private var secondLabelTitle: String!
    private let indicator = UIActivityIndicatorView()
    
    @IBOutlet private weak var busKindTitleLabel: UILabel!
    @IBOutlet private weak var depatureLabel: UILabel!
    @IBOutlet private weak var arrivedLabel: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var dayKindLabel: UILabel!
    @IBOutlet private weak var nextTimeLabel: UILabel!
    @IBOutlet private weak var directionKindLabel: UILabel!
    @IBOutlet private weak var countTimeLabel: UILabel!
    @IBOutlet private weak var beforeButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    @IBAction func didTapBeforeButton(_ sender: UIButton) {
        updateContents(false)
    }
    
    @IBAction func didTapAfterButton(_ sender: UIButton) {
        updateContents(true)
    }
    
    func inject(_ presenter: BusTimerPresenterProtocol, busContents: BusContents) {
        self.busContents = busContents
        self.presenter = presenter
    }
    
    var refreshTrigger: Signal<CountTimeContents> {
        return refreshRelay.asSignal()
    }
    private let refreshRelay = PublishRelay<CountTimeContents>()
    
    var updateTrigger: Signal<CountTimeContents> {
        return updateRelay.asSignal()
    }
    private let updateRelay = PublishRelay<CountTimeContents>()
    
    var scheduleTrigger: Signal<ScheduleContents> {
        return scheduleRelay.asSignal()
    }
    
    private let scheduleRelay = PublishRelay<ScheduleContents>()
    
    private func updateContents(_ isAfter: Bool, isTimeUp: Bool = false) {
        self.timer?.invalidate()
        startIndicator(indicator: indicator)
        var time: Time?
        if isAfter {
            time = responseTimeList.last
            if isTimeUp {
                responseTimeList.remove(at: 0)
            }
        } else {
            responseTimeList.remove(at: responseTimeList.count - 1)
            time = Time(hour: responseTimeList.last!.hour, minutes: responseTimeList.last!.minutes - 1)
            responseTimeList.remove(at: responseTimeList.count - 1)
        }
        guard let contentsTime = time else { return }
        let countTimeContents = CountTimeContents(busKind: busContents.busKind, directionKind: busContents.directionKind, dayKind: busContents.dayKind, time: contentsTime)
        updateRelay.accept(countTimeContents)
        
        beforeButton.setImage(responseTimeList.count < 2 ? nil : UIImage(named: "leftButton") , for: .normal)
        beforeButton.isUserInteractionEnabled = responseTimeList.count < 2 ? false : true
    }
    
    private func updateView(with viewModel: CountTimeViewModel?) {
        self.timer?.invalidate()
        stopIndicator(indicator: indicator)
        if let viewModel = viewModel {
            busContents.busKind = viewModel.busKind
            busContents.dayKind = viewModel.dayKind
            
            nextButton.setImage(UIImage(named: "rightButton") , for: .normal)
            nextButton.isUserInteractionEnabled = true
            busKindTitleLabel.text = viewModel.busKind.title
            dayKindLabel.text = viewModel.dayKind.title
            directionKindLabel.text = viewModel.directionKind.getDirectionKindLabelTitle(with: viewModel.busKind)
            depatureLabel.text = viewModel.directionKind.getDepatureLabelTitle(with: viewModel.busKind)
            arrivedLabel.text = viewModel.directionKind.getArrivedLabelTitle(with: viewModel.busKind)
        
            responseTimeList.append(Time(hour: viewModel.time.hour, minutes: viewModel.time.minutes))
            self.responseTimeList = responseTimeList.unique
            
            if viewModel.isCirculation {
                nextTimeLabel.text = "折返し運転中"
                countTimeLabel.text = "折返し運転中"
            } else if viewModel.isFinished {
                nextTimeLabel.text = "運転終了"
                countTimeLabel.text = "運転終了"
                
                nextButton.setImage(nil, for: .normal)
                nextButton.isUserInteractionEnabled = false
            } else {
                let hourString = viewModel.time.hour < 10 ? "0\(viewModel.time.hour)" : "\(viewModel.time.hour)"
                let minutesString = viewModel.time.minutes < 10 ? "0\(viewModel.time.minutes)" : "\(viewModel.time.minutes)"
                nextTimeLabel.text = hourString + ":" + minutesString + "発"
                countDown()
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            }
            guard let text = nextTimeLabel.text else { return }
            let attributeString = NSMutableAttributedString(string: text)
            attributeString.addAttribute(.underlineStyle, value: 1, range: NSMakeRange(0, text.count))
            nextTimeLabel.attributedText = attributeString
        } else {
            popUpError()
        }
        
        beforeButton.setImage(responseTimeList.count < 2 ? nil : UIImage(named: "leftButton") , for: .normal)
        beforeButton.isUserInteractionEnabled = responseTimeList.count < 2 ? false : true
    }
    
    @objc private func countDown() {
        let calender = Calendar.current
        self.date = Date()
        self.components = calender.dateComponents([.hour, .minute, .second], from: date)
      
        if responseTimeList.count >= 1 {
            guard let currentTime = calender.date(from: components) else { return }
            guard let nextTime = calender.date(from: DateComponents(hour: responseTimeList[responseTimeList.count - 1].hour, minute: responseTimeList[responseTimeList.count - 1].minutes, second: 0)) else { return }
            
            let diffComp = calender.dateComponents([.hour, .minute, .second], from: currentTime, to: nextTime)
            guard let diffHour = diffComp.hour else { return }
            guard let diffMinutes = diffComp.minute else { return }
            guard let diffSecond = diffComp.second else { return }
            
            if responseTimeList.count >= 2 {
                guard let responseTime = calender.date(from: DateComponents(hour: responseTimeList[0].hour, minute: responseTimeList[0].minutes, second: 0)) else { return }
                let diffResponseTime = calender.dateComponents([.second], from: currentTime, to: responseTime)
                guard let second = diffResponseTime.second else { return }
                if second <= 0 {
                    responseTimeList.remove(at: 0)
                }
                
                beforeButton.setImage(responseTimeList.count < 2 ? nil : UIImage(named: "leftButton") , for: .normal)
                beforeButton.isUserInteractionEnabled = responseTimeList.count < 2 ? false : true
            }
            
            if diffHour <= 0 && diffMinutes <= 0 && diffSecond <= 0 {
                updateContents(true, isTimeUp: true)
            }
            
            self.hourLabelText = diffHour < 10 ? "0\(diffHour)" : "\(diffHour)"
            self.minutesLabelText = diffMinutes < 10 ? "0\(diffMinutes)" : "\(diffMinutes)"
            self.secondLabelTitle = diffSecond < 10 ? "0\(diffSecond)" : "\(diffSecond)"
            
            if diffHour < 1 {
                countTimeLabel.text = minutesLabelText + "分" + secondLabelTitle + "秒前"
                reSizeForLabelFont(label: countTimeLabel, hasHour: false)
            } else {
                guard let hourLabelText = hourLabelText else { return }
                countTimeLabel.text = "\(hourLabelText)時間" + minutesLabelText + "分" + secondLabelTitle + "秒前"
                reSizeForLabelFont(label: countTimeLabel, hasHour: true)
            }
        }
    }
    
    private func reSizeForLabelFont(label: UILabel, hasHour: Bool) {
        guard let labelText = label.text else { return }
        let attrLabel = NSMutableAttributedString(string: labelText)
        if hasHour {
            attrLabel.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 50), range: NSMakeRange(0, 2))
            attrLabel.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 50), range: NSMakeRange(4, 2))
            attrLabel.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 50), range: NSMakeRange(7, 2))
        } else {
            attrLabel.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 60), range: NSMakeRange(0, 2))
            attrLabel.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 60), range: NSMakeRange(3, 2))
        }
        countTimeLabel.attributedText = attrLabel
    }
    
    private func popUpError() {
        let alert: UIAlertController = UIAlertController(title: "時刻表を読み込めませんでした。", message: "アプリを終了します。", preferredStyle: .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "終了する", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            exit(0)
        })
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func convertWeekKind() {
        self.date = Date()
        self.components = Calendar.current.dateComponents([.month, .day, .weekday], from: date)
        guard let busKind = BusManager.getBusKindForUserDefaults() else { return }
        guard let weekday = components.weekday else { return }
        
        guard let month = components.month else { return }
        guard let day = components.day else { return }
        
        switch busKind {
        case .kokusai:
            scheduleRelay.accept(ScheduleContents(busName: "kokusai", month: month , day: day))
        case .demachi:
            scheduleRelay.accept(ScheduleContents(busName: "demachi", month: month, day: day))
        case .kita:
            if weekday == 0 {
                self.busContents.dayKind = .sunAndHoliday
            } else if weekday == 7 {
                self.busContents.dayKind =  .saturday
            } else {
                self.busContents.dayKind = .weekday
            }
        default:
            if weekday == 7 {
                self.busContents.dayKind = .saturday
            } else if weekday == 4 {
                self.busContents.dayKind = .wednesday
            } else {
                self.busContents.dayKind = .weekday
            }
        }
    }
    
    private func configure() {
        startIndicator(indicator: indicator)
        responseTimeList.removeAll()
        
        self.date = Date()
        self.components = Calendar.current.dateComponents([.hour, .minute, .second, .weekday], from: date)
        
        if let busKind = BusManager.getBusKindForUserDefaults() {
            guard let hour = components.hour else { return }
            guard let minutes = components.minute else { return }
            
            let countTimeContents = CountTimeContents(busKind: busKind, directionKind: busContents.directionKind , dayKind: busContents.dayKind, time: .init(hour: hour, minutes: minutes))
            
            refreshRelay.accept(countTimeContents)
        } else {
            popUpError()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.dayKind
            .drive(onNext: { [weak self] dayKind in
                guard let strongSelf = self else { return }
                strongSelf.busContents.dayKind = dayKind
                strongSelf.responseTimeList.removeAll()
                strongSelf.configure()
            })
            .disposed(by: disposeBag)
        
        convertWeekKind()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        let width = UIScreen.main.bounds.width
        segmentedControl.changeAllSegment(withArray: ["行き", "帰り"], width: width / 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        beforeButton.setImage(nil , for: .normal)
        nextButton.setImage(nil , for: .normal)
        
        configure()
        
        presenter.viewModel
            .drive(onNext: { [weak self] viewModel in
                guard let strongSelf = self else { return }
                
                strongSelf.updateView(with: viewModel)
            })
            .disposed(by: disposeBag)
        
        segmentedControl.rx.selectedSegmentIndex
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] selectedIndex in
                guard let strongSelf = self else { return }
                guard let directionKindSegment = DirectionKindSegment(rawValue: selectedIndex) else { return }
                guard let directionKind = DirectionKind(rawValue: directionKindSegment.value) else { return }
                strongSelf.busContents.directionKind = directionKind
                strongSelf.configure()
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
    }
}
