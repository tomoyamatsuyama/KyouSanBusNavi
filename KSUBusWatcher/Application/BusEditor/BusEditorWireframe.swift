import Foundation
import UIKit
import RxCocoa
import RxSwift

struct BusEditorWireframe: BusEditorWireframeProtocol {
    private weak var view: BusEditorTableViewController!
    
    init(view: BusEditorTableViewController) {
        self.view = view
    }
    
    func presentBusTimer() {
        if let tabVC = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            DispatchQueue.main.async {
                tabVC.selectedIndex = 0
            }
        }
    }
}
