import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol TimeTableDetailUseCaseProtocol: class {
    func fetchTimeTable(_ busContents: BusContents) -> Observable<TimeTableDetailViewModel>
}

class TimeTableDetailUseCase: TimeTableDetailUseCaseProtocol {
    private var timeTableDetailRepository: TimeTableDetailRepositoryProtocol
    
    init(timeTableDetailRepository: TimeTableDetailRepositoryProtocol) {
        self.timeTableDetailRepository = timeTableDetailRepository
    }
    
    func fetchTimeTable(_ busContents: BusContents) -> Observable<TimeTableDetailViewModel> {
        return timeTableDetailRepository.fetchTimeTable(busContents: busContents).flatMap { timeTableFeed -> Observable<TimeTableDetailViewModel> in
            return .just(TimeTableDetailUseCase.convertViewModel(to: timeTableFeed))
        }
    }
    
    private static func convertViewModel(to timeTableFeed: TimeTableFeed) -> TimeTableDetailViewModel {
        let list = timeTableFeed.times.map { TimeTableDetailViewModel.Time(hour: $0.hour, minutes: $0.minutes) }
        return TimeTableDetailViewModel(name: timeTableFeed.busName, directionKind: timeTableFeed.directionKind, directionName: timeTableFeed.direction, dayKind: timeTableFeed.dayKind, list: list)
    }
}
