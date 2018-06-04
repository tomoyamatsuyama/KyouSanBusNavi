import Foundation
import UIKit
import RxCocoa
import RxSwift

class BusTimerPresenter: BusTimerPresenterProtocol {
    private weak var view: BusTimerViewProtocol!
    private var interactor: BusTimerInteractorProtocol
    private let disposeBag = DisposeBag()
    
    var viewModel: Driver<CountTimeViewModel?> {
        return viewModelRelay.asDriver(onErrorJustReturn: nil)
    }
    private let viewModelRelay = PublishRelay<CountTimeViewModel?>()
    
    var dayKind: Driver<DayKind> {
        return dayKindRelay.asDriver(onErrorJustReturn: .diaA)
    }
    private let dayKindRelay = PublishRelay<DayKind>()
    
    init(view: BusTimerViewProtocol, interactor: BusTimerInteractorProtocol) {
        self.view = view
        self.interactor = interactor
        
        view.scheduleTrigger
            .emit(onNext: { [weak self] contents in
                guard let strongSelf = self else { return }
                interactor.fetchSchedule(contents)
                    .bind(to: strongSelf.dayKindRelay)
                    .disposed(by: strongSelf.disposeBag)                
            })
            .disposed(by: disposeBag)
        
        view.refreshTrigger
            .emit(onNext: { [weak self] contents in
                guard let strongSelf = self else { return }
                interactor.fetchTime(contents)
                    .bind(to: strongSelf.viewModelRelay)
                    .disposed(by: strongSelf.disposeBag)
            })
            .disposed(by: disposeBag)
        
        view.updateTrigger
            .emit(onNext: { [weak self] contents in
                guard let strongSelf = self else { return }
                interactor.fetchTime(contents)
                    .bind(to: strongSelf.viewModelRelay)
                    .disposed(by: strongSelf.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}


