import UIKit
import Foundation
import RxCocoa
import RxSwift

class BusEditorPresenter: BusEditorPresenterProtocol {
    private weak var view: BusEditorViewProtocol!
    private var interactor: BusEditorInteractorProtocol
    private var wireframe: BusEditorWireframeProtocol
    private let disposeBag = DisposeBag()
    
    var viewState: Driver<BusKind?> {
        return viewStateRelay.asDriver(onErrorJustReturn: nil)
    }
    private var viewStateRelay = PublishRelay<BusKind?>()
    
    init(view: BusEditorViewProtocol, interactor: BusEditorInteractorProtocol, wireframe: BusEditorWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        
        
        view.updateTrigger
            .emit(onNext: { [weak self] busKind in
                guard let strongSelf = self else { return }
                strongSelf.viewStateRelay.accept(interactor.apply(busKind))
            })
            .disposed(by: disposeBag)
        
        view.presentTrigger
            .emit(onNext: { _ in
                wireframe.presentBusTimer()
            })
            .disposed(by: disposeBag)
    }
}
