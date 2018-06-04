import Foundation
import RxSwift
import RxCocoa

protocol BusTimerRepositoryProtocol {
    func fetchTime(_ countTimeContents: CountTimeContents) -> Observable<CountTimeFeed>
    func fetchSchedule(_ scheduleContents: ScheduleContents) -> Observable<ScheduleFeed>
}

struct BusTimerRepository: BusTimerRepositoryProtocol {
    private let dataStore: BusTimerDataStoreProtocol
    init(dataStore: BusTimerDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func fetchTime(_ countTimeContents: CountTimeContents) -> Observable<CountTimeFeed> {
        return dataStore.fetchTime(countTimeContents)
    }
    
    func fetchSchedule(_ scheduleContents: ScheduleContents) -> Observable<ScheduleFeed> {
        return dataStore.fetchSchedule(scheduleContents)
    }
}
