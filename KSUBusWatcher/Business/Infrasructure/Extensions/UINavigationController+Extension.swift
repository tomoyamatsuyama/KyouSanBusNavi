import Foundation
import UIKit

extension UINavigationController {
    
    static func instantiate(storyboardName: String) -> UINavigationController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            fatalError("Failed to instatiate \(storyboardName) form stoyboard")
        }
        return navigationController
    }
    
    func firstViewController<ViewController: UIViewController>() -> ViewController {
        guard let viewController = self.viewControllers.first as? ViewController else {
            fatalError("could not found \(ViewController.self)")
        }
        return viewController
    }
}
