import Foundation
import UIKit
import RxSwift
import RxCocoa

class SettingListPresenter: SettingListPresenterProtocol {
    private var view: SettingListViewProtocol!
    private var wireframe: SettingListWireframeProtocol!
    private let disposeBag = DisposeBag()
    
    var viewModel: Driver<SettingListViewModel> {
        return viewMoodelRelay.asDriver(onErrorJustReturn: SettingListViewModel())
    }
    private let viewMoodelRelay = PublishRelay<SettingListViewModel>()
    
    init(view: SettingListViewProtocol ,wireframe: SettingListWireframeProtocol) {
        self.view = view
        self.wireframe = wireframe
        
        view.presentTrigger
            .emit(onNext: { sectionItem in
                switch sectionItem {
                case .busEditor:
                    wireframe.prsentBusEditorView()
                case .support:
                    wireframe.presentSupportView()
                }
            })
            .disposed(by: disposeBag)
    }
}
