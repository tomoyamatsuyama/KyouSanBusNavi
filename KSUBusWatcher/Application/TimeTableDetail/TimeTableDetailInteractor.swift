import Foundation
import UIKit
import RxSwift
import RxCocoa

class TimeTableDetailInteractor: TimeTableDetailInteractorProtocol {
    private var timeTableDetailUseCase: TimeTableDetailUseCaseProtocol
    
    init(timeTableDetailUseCase: TimeTableDetailUseCaseProtocol) {
        self.timeTableDetailUseCase = timeTableDetailUseCase
    }
    
    func fetch(_ busContents: BusContents) -> Observable<TimeTableDetailViewModel> {
        return timeTableDetailUseCase.fetchTimeTable(busContents)
    }
}
