import Foundation
import UIKit

struct SettingListViewBuilder {
    static func build() -> UINavigationController {
        
        let viewController = SettingListViewController()
        let wireframe = SettingListWireframe(view: viewController)
        let presenter = SettingListPresenter(view: viewController, wireframe: wireframe)
        viewController.inject(presenter)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return navigationController
    }
}
