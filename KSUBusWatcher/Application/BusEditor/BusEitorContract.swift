import Foundation
import RxSwift
import RxCocoa

enum AlertContents {
    case confirmationOfChanges(item: BusKind)
    case cantSave
    case done(item: BusKind)
    
    var title: String {
        switch self {
        case .confirmationOfChanges(_):
            return "確認"
        case .cantSave:
            return "エラー"
        case .done(let item):
            return "『\(item.title)』に設定を変更しました"
        }
    }
    
    var message: String{
        switch self {
        case .confirmationOfChanges(let item):
            return "『\(item.title)』に変更しますか？"
        case .cantSave:
            return "設定を変更できませんでした。"
        case .done(_):
            return "カウントダウンに戻ります。"
        }
    }
}

struct BusEditorViewModel {
    let items: [BusKind] = [.kamigamo, .niken, .kokusai, .demachi, .kita]
}

protocol BusEditorViewProtocol: class {
    var updateTrigger: Signal<BusKind> { get }
    var presentTrigger: Signal<Void> { get }
}

protocol BusEditorPresenterProtocol: class {
    var viewState: Driver<BusKind?> { get }
}

protocol BusEditorInteractorProtocol: class {
    func apply(_ updateContents: BusKind) -> BusKind?
}

protocol BusEditorWireframeProtocol {
    func presentBusTimer()
}
