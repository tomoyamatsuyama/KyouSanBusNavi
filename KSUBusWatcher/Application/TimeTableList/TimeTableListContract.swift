import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol TimeTableListViewProtocol: class {
    var presentTrigger: Signal<TimeTableListModel.Section.Item> { get }
}

protocol TimeTableListPresenterProtocol: class {
    var viewModel: Driver<TimeTableListModel> { get }
}

protocol TimeTableListWireframeProtocol: class {
    func presentKamigamoView(with busContents: BusContents)
    func presentNikenView(with busContents: BusContents)
    func presentDemachiView(with busContents: BusContents)
    func presentKokusaiView(with busContents: BusContents)
    func presentKitaView(with busContents: BusContents)
}

struct TimeTableListModel {
    var sections: [Section] = [
        Section(title: "上賀茂シャトルバス", item: [.kamigamoThere, .kamigamoBack], isExpanded: false),
        Section(title: "二軒茶屋シャトルバス", item: [.nikenThere, .nikenBack], isExpanded: false),
        Section(title: "京都バス 国際会館線", item: [.kokusaiThere, .kokusaiBack], isExpanded: false),
        Section(title: "京都バス 出町柳線", item: [.demachiThere, .demachiBack], isExpanded: false),
        Section(title: "京都市営バス 北3", item: [.kitaThere, .kitaBack], isExpanded: false),
    ]
    
    struct Section {
        let title: String
        let item: [Item]
        var isExpanded: Bool
        enum Item {
            case kamigamoThere
            case kamigamoBack
            case nikenThere
            case nikenBack
            case kokusaiThere
            case kokusaiBack
            case demachiThere
            case demachiBack
            case kitaThere
            case kitaBack
            
            var name: String {
                switch self {
                case .kamigamoThere:
                    return "京都産業大学方面"
                case .kamigamoBack:
                    return "上賀茂神社方面"
                case .nikenThere:
                    return "京都産業大学方面"
                case .nikenBack:
                    return "二軒茶屋方面"
                case .kokusaiThere:
                    return "京都産業大学方面"
                case .kokusaiBack:
                    return "国際会館方面"
                case .demachiThere:
                    return "京都産業大学方面"
                case .demachiBack:
                    return "出町柳方面"
                case .kitaThere:
                    return "京都産業大学方面"
                case .kitaBack:
                    return "北大路BT方面"
                }
            }
        }
    }
}
