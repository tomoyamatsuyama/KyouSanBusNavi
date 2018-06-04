import UIKit

struct BusTimerViewBuilder {
    static func build() -> UINavigationController {
        let navigationController: UINavigationController = .instantiate(storyboardName: String(describing: BusTimerViewController.self))
        
        let viewController: BusTimerViewController = navigationController.firstViewController()
        
        let repository = BusTimerRepository(dataStore: BusTimerDataStore())
        let useCase = BusTimerUseCase(busTimerRepository: repository)
        let interactor = BusTimerInteractor(useCase: useCase)
        let presenter = BusTimerPresenter(view: viewController, interactor: interactor)
        
        var busKind = BusManager.getBusKindForUserDefaults()
        
        if BusManager.getBusKindForUserDefaults() == nil {
            _ = BusManager.setBusKindForUserDefaults(busKind: .kamigamo)
            busKind = .kamigamo
        }
        
        guard let bus = busKind else {
            fatalError("TODO")
        }
        
        let busContents = BusContents(busKind: bus, dayKind: .sunAndHoliday, directionKind: .there)
        
        viewController.inject(presenter, busContents: busContents)
        return navigationController
    }
}
