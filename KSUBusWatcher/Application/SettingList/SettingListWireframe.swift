import Foundation
import UIKit
import RxSwift
import RxCocoa

class SettingListWireframe: SettingListWireframeProtocol {
    private weak var view: SettingListViewController!
    init(view: SettingListViewController) {
        self.view = view
    }
    
    func prsentBusEditorView() {
        let viewController = BusEditorViewBuilder.build()
        view.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentSupportView() {
        let viewController = SupportViewBuilder.build()
        view.navigationController?.pushViewController(viewController, animated: true)
    }
}
