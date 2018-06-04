import UIKit
import Foundation
import RxCocoa
import RxSwift

class TimeTableListWireframe: TimeTableListWireframeProtocol {
    private weak var view: TimeTableListViewController!
    
    init(view: TimeTableListViewController) {
        self.view = view
    }
    
    func presentKamigamoView(with busContents: BusContents) {
        let viewController = TimeTableDetailViewBuilder.build(with: busContents)
        view.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentNikenView(with busContents: BusContents) {
        let viewController = TimeTableDetailViewBuilder.build(with: busContents)
        view.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentDemachiView(with busContents: BusContents) {
        let viewController = TimeTableDetailViewBuilder.build(with: busContents)
        view.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentKokusaiView(with busContents: BusContents) {
        let viewController = TimeTableDetailViewBuilder.build(with: busContents)
        view.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentKitaView(with busContents: BusContents) {
        let viewController = TimeTableDetailViewBuilder.build(with: busContents)
        view.navigationController?.pushViewController(viewController, animated: true)
    }
}
