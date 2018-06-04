import UIKit

struct BusEditorViewBuilder {
    static func build() -> BusEditorTableViewController {
        let viewController = BusEditorTableViewController()
        let interactor = BusEditorInteractor()
        let wireframe = BusEditorWireframe(view: viewController)
        let presenter = BusEditorPresenter(view: viewController, interactor: interactor, wireframe: wireframe)
        viewController.inject(presenter)
        
        return viewController
    }
}
