import Foundation
import UIKit

struct TimeTableListViewBuilder {
    static func build() -> UINavigationController {
        let viewController = TimeTableListViewController()
        
        let wireframe = TimeTableListWireframe(view: viewController)
        let presenter = TimeTableListPresenter(view: viewController, wireframe: wireframe)
        viewController.inject(presenter)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return navigationController
    }
}
