import UIKit
import Foundation
import RxSwift
import RxCocoa

struct SupportViewBuilder {
    static func build() -> SupportViewController {
        let viewController: SupportViewController = .instantiate()
        return viewController
    }
}
