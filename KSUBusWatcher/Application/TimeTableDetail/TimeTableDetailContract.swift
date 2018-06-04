import Foundation
import UIKit
import RxSwift
import RxCocoa

enum BusKind: String {
    case kamigamo = "kamigamo"
    case niken = "niken"
    case demachi = "demachi"
    case kokusai = "kokusai"
    case kita = "kita"
    
    var title: String {
        switch self {
        case .kamigamo:
            return "上賀茂シャトルバス"
        case .niken:
            return "二軒茶屋シャトルバス"
        case .kita:
            return "京都市営バス 北3"
        case .demachi:
            return "京都バス 出町柳線"
        case .kokusai:
            return "京都バス 国際会館線"
        }
    }
    
    var value: String {
        switch self {
        case .kamigamo:
            return "kamigamo"
        case .niken:
            return "niken"
        case .kita:
            return "kita"
        case .demachi:
            return "demachi"
        case .kokusai:
            return "kokusai"
        }
    }
}

struct BusContents {
    var busKind: BusKind
    var dayKind: DayKind
    var directionKind: DirectionKind
}

struct TimeTableDetailViewModel {
    let name: String?
    let directionKind: String?
    let directionName: String?
    let dayKind: String?
    let list: [Time]
    
    struct Time {
        let hour: Int
        let minutes: [Int]
    }
}

enum DayKind: String {
    case weekday = "week_day"
    case wednesday = "wednesday"
    case saturday = "saturday"
    case sunAndHoliday = "sun_and_holiday"
    case diaA = "dia_a"
    case diaB = "dia_b"
    case diaC = "dia_c"
    
    var value: String {
        switch self {
        case .weekday:
            return "week_day"
        case .wednesday:
            return "wednesday"
        case .saturday:
            return "saturday"
        case .sunAndHoliday:
            return "sun_and_holiday"
        case .diaA:
            return "dia_a"
        case .diaB:
            return "dia_b"
        case .diaC:
            return "dia_c"
        }
    }
    
    var title: String {
        switch self {
        case .weekday:
            return "平日"
        case .wednesday:
            return "水曜"
        case .saturday:
            return "土曜"
        case .sunAndHoliday:
            return "日祝"
        case .diaA:
            return "Aダイヤ"
        case .diaB:
            return "Bダイヤ"
        case .diaC:
            return "Cダイヤ"
        }
    }
}

enum DirectionKind: String {
    case there = "there"
    case back = "back"
    
    var labelTitle: String {
        switch self {
        case .there:
            return "行き"
        case .back:
            return "帰り"
        }
    }
    
    var value: String {
        switch self {
        case .there:
            return "there"
        case .back:
            return "back"
        }
    }
    
    func getDirectionKindLabelTitle(with busKind: BusKind) -> String {
        switch self {
        case .there:
            return "京都産業大学行き"
        case .back:
            switch busKind {
            case .kamigamo:
                return "上賀茂神社行き"
            case .niken:
                return "二軒茶屋行き"
            case .kokusai:
                return "国際会館駅前行き"
            case .demachi:
                return "出町柳駅前行き"
            case .kita:
                return "北大路BT行き"
            }
        }
    }
    
    func getArrivedLabelTitle(with busKind: BusKind) -> String {
        switch self {
        case .there:
            return "京都産業大学前"
        case .back:
            switch busKind {
            case .kamigamo:
                return "上賀茂神社前"
            case .niken:
                return "二軒茶屋前"
            case .kokusai:
                return "国際会館駅前"
            case .demachi:
                return "出町柳駅前"
            case .kita:
                return "北大路BT"
            }
        }
    }
    
    func getDepatureLabelTitle(with busKind: BusKind) -> String {
        switch self {
        case .there:
            switch busKind {
            case .kamigamo:
                return "上賀茂神社前"
            case .niken:
                return "二軒茶屋前"
            case .kokusai:
                return "国際会館駅前"
            case .demachi:
                return "出町柳駅前"
            case .kita:
                return "北大路BT"
            }
        case .back:
            return "京都産業大学前"
        }
    }
}

enum DayKindOfShuttle: Int {
    case weekday = 0
    case wednesday = 1
    case saturday = 2
    
    var value: String {
        switch self {
        case .weekday:
            return "week_day"
        case .wednesday:
            return "wednesday"
        case .saturday:
            return "saturday"
        }
    }
}

enum DayKindOfCityBus: Int {
    case weekday = 0
    case saturday = 1
    case sunAndHoliday = 2
    
    var value: String {
        switch self {
        case .weekday:
            return "week_day"
        case .saturday:
            return "saturday"
        case .sunAndHoliday:
            return "sun_and_holiday"
        }
    }
}

enum DayKindOfKokusai: Int {
    case diaA = 0
    case diaB = 1
    case saturday = 2
    case sunAndHoliday = 3
    
    var value: String {
        switch self {
        case .diaA:
            return "dia_a"
        case .diaB:
            return "dia_b"
        case .saturday:
            return "saturday"
        case .sunAndHoliday:
            return "sun_and_holiday"
        }
    }
}

enum DayKindOfDemachi: Int {
    case weekday = 0
    case saturday = 1
    case sunAndHoliday = 2
    case diaA = 3
    case diaC = 4
    
    var value: String {
        switch self {
        case .weekday:
            return "week_day"
        case .saturday:
            return "saturday"
        case .sunAndHoliday:
            return "sun_and_holiday"
        case .diaA:
            return "dia_a"
        case .diaC:
            return "dia_c"
        }
    }
}

protocol TimeTableDetailViewProtocol: class {
    var refreshTrigger: Signal<BusContents> { get }
    var changeTimeTrigger: Signal<BusContents> { get }
}

protocol TimeTableDetailPresenterProtocol: class {
    var viewModel: Driver<TimeTableDetailViewModel> { get }
}

protocol TimeTableDetailInteractorProtocol: class {
    func fetch(_ busContents: BusContents) -> Observable<TimeTableDetailViewModel>
}
