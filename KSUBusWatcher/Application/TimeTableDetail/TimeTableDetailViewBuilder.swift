import Foundation
import UIKit
import RxSwift
import RxCocoa

struct TimeTableDetailViewBuilder {
    static func build(with busContents: BusContents) -> TimeTableDetailViewController {
        let viewController: TimeTableDetailViewController = .instantiate()
        let timeTableDetailRepository = TimeTableDetailRepository(timeTableDetailDataStore: TimeTableDetailAPIDataStore())
        let timeTableDetailUseCase = TimeTableDetailUseCase(timeTableDetailRepository: timeTableDetailRepository)
        let interactor = TimeTableDetailInteractor(timeTableDetailUseCase: timeTableDetailUseCase)
        let presenter: TimeTableDetailPresenter = .init(view: viewController, interactor: interactor)
        
        viewController.inject(presenter, with: busContents)
        
        return viewController
    }
}
