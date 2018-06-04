import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol BusTimerUseCaseProtocol: class {
    func fetchTime(_ countTimeContents: CountTimeContents) -> Observable<CountTimeViewModel>
    func fetchSchedule(_ scheduleContents: ScheduleContents) -> Observable<DayKind>
}

class BusTimerUseCase: BusTimerUseCaseProtocol {
    private var busTimerRepository: BusTimerRepositoryProtocol!
    init(busTimerRepository: BusTimerRepositoryProtocol) {
        self.busTimerRepository = busTimerRepository
    }
    
    func fetchTime(_ countTimeContents: CountTimeContents) -> Observable<CountTimeViewModel> {
        return busTimerRepository.fetchTime(countTimeContents).flatMap { countTimeFeed -> Observable<CountTimeViewModel> in
            return .just(BusTimerUseCase.convertViewModel(to: countTimeFeed, requestTime: countTimeContents.time))
        }
    }
    
    func fetchSchedule(_ scheduleContents: ScheduleContents) -> Observable<DayKind> {
        return busTimerRepository.fetchSchedule(scheduleContents).flatMap { feed -> Observable<DayKind> in
            guard let dayKind = DayKind(rawValue: feed.diaKind) else {
                fatalError("TODO")
            }
            return .just(dayKind)
        }
    }
    
    private static func convertViewModel(to countTimeFeed: CountTimeFeed, requestTime: Time) -> CountTimeViewModel {
        guard let busKind = BusKind(rawValue: countTimeFeed.busKind) else { fatalError("TODO") }
        guard let directionKind = DirectionKind(rawValue: countTimeFeed.directionKind) else { fatalError("TODO") }
        guard let dayKind = DayKind(rawValue: countTimeFeed.dayKind) else { fatalError("TODO") }
        
        var primaryKeys: [Int] = []
        for (index, countTime) in countTimeFeed.countTimes.enumerated() {
            primaryKeys.append(index)
            if ((countTime.time.hour == requestTime.hour && requestTime.minutes < countTime.time.minutes) || countTime.time.hour == requestTime.hour + 1) {
                break
            }
        }
        
        guard let primaryKey = primaryKeys.last else { fatalError("TODO") }
        
        let time = Time(hour: countTimeFeed.countTimes[primaryKey].time.hour, minutes: countTimeFeed.countTimes[primaryKey].time.minutes)
        
        return CountTimeViewModel(busKind: busKind, directionKind: directionKind, dayKind: dayKind, isCirculation: countTimeFeed.countTimes[primaryKey].isCirculation, isFinished: countTimeFeed.countTimes[primaryKey].isFinished, time: time)
    }
}
