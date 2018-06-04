import UIKit

extension UIViewController {
    static func instantiate<ViewController: UIViewController>(in bundle: Bundle? = nil) -> ViewController {
        let storyboardName = String(describing: ViewController.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let viewController = storyboard.instantiateInitialViewController() as? ViewController else {
            fatalError("Failed to instatiate \(ViewController.self) form stoyboard")
        }
        return viewController
    }
    
    func startIndicator(indicator: UIActivityIndicatorView) {
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.center = self.view.center
        indicator.color = UIColor.gray
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func stopIndicator(indicator: UIActivityIndicatorView){
        indicator.stopAnimating()
    }
}
