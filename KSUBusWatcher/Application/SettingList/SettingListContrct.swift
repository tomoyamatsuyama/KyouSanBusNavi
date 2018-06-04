import Foundation
import RxSwift
import RxCocoa

struct SettingListViewModel {
    let sections: [Section] = [Section(title: "変更", item: [.busEditor]), Section(title: "報告", item: [.support])]
    
    struct Section {
        let title: String
        let item: [Item]
        
        enum Item {
            case busEditor
            case support
            
            var title: String {
                switch self {
                case .busEditor:
                    return "カウントタイムのバス変更"
                case .support:
                    return "お問い合わせ"
                }
            }
        }
    }
}

protocol SettingListViewProtocol: class {
    var presentTrigger: Signal<SettingListViewModel.Section.Item> { get }
}

protocol SettingListPresenterProtocol: class {
    var viewModel: Driver<SettingListViewModel> { get }
}

protocol SettingListWireframeProtocol: class {
    func prsentBusEditorView()
    func presentSupportView()
}
