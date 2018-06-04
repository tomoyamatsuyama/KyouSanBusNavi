import Foundation
import UIKit
import RxSwift
import RxCocoa

class TimeTableDetailPresenter: TimeTableDetailPresenterProtocol {
    private weak var view: TimeTableDetailViewProtocol!
    private var interactor: TimeTableDetailInteractorProtocol
    private let disposeBag = DisposeBag()
    
    //:TODO error処理を考える
    var viewModel: Driver<TimeTableDetailViewModel> {
        return viewModelRelay.asDriver(onErrorJustReturn: TimeTableDetailViewModel(name: nil, directionKind: nil, directionName: nil, dayKind: nil, list: []))
    }
    private let viewModelRelay = PublishRelay<TimeTableDetailViewModel>()
    
    init(view: TimeTableDetailViewProtocol, interactor: TimeTableDetailInteractorProtocol) {
        self.view = view
        self.interactor = interactor
        
        view.refreshTrigger    
            .emit(onNext: { [weak self] busContents in
                guard let strongSelf = self else { return }
                interactor.fetch(busContents)
                    .bind(to: strongSelf.viewModelRelay)
                    .disposed(by: strongSelf.disposeBag)
            })
            .disposed(by: disposeBag)
        
        view.changeTimeTrigger
            .emit(onNext: { [weak self] busContents in
                guard let strongSelf = self else { return }
                interactor.fetch(busContents)
                    .bind(to: strongSelf.viewModelRelay)
                    .disposed(by: strongSelf.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
