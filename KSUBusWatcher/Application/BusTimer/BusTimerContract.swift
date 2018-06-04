import Foundation
import UIKit
import RxSwift
import RxCocoa

enum DirectionKindSegment: Int {
    case there = 0
    case back = 1
    
    var value: String {
        switch self {
        case .there:
            return "there"
        case .back:
            return "back"
        }
    }
}

struct CountTimeViewModel {
    var busKind: BusKind
    var directionKind: DirectionKind
    var dayKind: DayKind
    var isCirculation: Bool
    var isFinished: Bool
    var time: Time
}

struct Time {
    var hour: Int
    var minutes: Int
}

extension Time: Equatable {
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.hour == rhs.hour && lhs.minutes == rhs.minutes
    }
}

struct CountTimeContents {
    var busKind: BusKind
    var directionKind: DirectionKind
    var dayKind: DayKind
    var time: Time
}

struct ScheduleContents {
    var busName: String
    var month: Int
    var day: Int
}

protocol BusTimerViewProtocol: class {
    var refreshTrigger: Signal<CountTimeContents> { get }
    var scheduleTrigger: Signal<ScheduleContents> { get }
    var updateTrigger: Signal<CountTimeContents> { get }
}

protocol BusTimerPresenterProtocol: class {
    var viewModel: Driver<CountTimeViewModel?> { get }
    var dayKind: Driver<DayKind> { get }
}

protocol BusTimerInteractorProtocol: class {
    func fetchSchedule(_ scheduleContents: ScheduleContents) -> Observable<DayKind>
    func fetchTime(_ countTimeContents: CountTimeContents) -> Observable<CountTimeViewModel>
}
