import Foundation
import UIKit
import RxCocoa
import RxSwift

class TimeTableListPresenter: TimeTableListPresenterProtocol {
    private weak var view: TimeTableListViewProtocol!
    private var wireframe: TimeTableListWireframeProtocol
    private let disposeBag = DisposeBag()
    
    var viewModel: Driver<TimeTableListModel> {
        return viewModelRelay.asDriver(onErrorJustReturn: .init())
    }
    private let viewModelRelay = PublishRelay<TimeTableListModel>()
    
    init(view: TimeTableListViewProtocol, wireframe: TimeTableListWireframeProtocol) {
        self.view = view
        self.wireframe = wireframe
        
        view.presentTrigger
            .emit(onNext: { type in
                switch type {
                case .kamigamoThere:
                    wireframe.presentKamigamoView(with: BusContents(busKind: .kamigamo, dayKind: .weekday, directionKind: .there))
                case .kamigamoBack:
                    wireframe.presentKamigamoView(with: BusContents(busKind: .kamigamo, dayKind: .weekday, directionKind: .back))
                case .nikenThere:
                    wireframe.presentNikenView(with: BusContents(busKind: .niken, dayKind: .weekday, directionKind: .there))
                case .nikenBack:
                    wireframe.presentNikenView(with: BusContents(busKind: .niken, dayKind: .weekday, directionKind: .back))
                case .demachiThere:
                    wireframe.presentDemachiView(with: BusContents(busKind: .demachi, dayKind: .weekday, directionKind: .there))
                case .demachiBack:
                    wireframe.presentDemachiView(with: BusContents(busKind: .demachi, dayKind: .weekday, directionKind: .back))
                case .kokusaiThere:
                    wireframe.presentKokusaiView(with: BusContents(busKind: .kokusai, dayKind: .diaA, directionKind: .there))
                case .kokusaiBack:
                    wireframe.presentKokusaiView(with: BusContents(busKind: .kokusai, dayKind: .diaA, directionKind: .back))
                case .kitaThere:
                    wireframe.presentKitaView(with: BusContents(busKind: .kita, dayKind: .weekday, directionKind: .there))
                case .kitaBack:
                    wireframe.presentKitaView(with: BusContents(busKind: .kita, dayKind: .weekday, directionKind: .back))
                }
            })
            .disposed(by: disposeBag)
    }
}
