import Foundation
import UIKit
import RxCocoa
import RxSwift

class BusTimerInteractor: BusTimerInteractorProtocol {
    private var useCase: BusTimerUseCaseProtocol
    
    init(useCase: BusTimerUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchTime(_ countTimeContents: CountTimeContents) -> Observable<CountTimeViewModel> {
        return useCase.fetchTime(countTimeContents)
    }
    
    func fetchSchedule(_ scheduleContents: ScheduleContents) -> Observable<DayKind> {
        return useCase.fetchSchedule(scheduleContents)
    }
}
