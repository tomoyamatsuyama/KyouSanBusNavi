import Foundation
import RxSwift
import RxCocoa

protocol BusTimerDataStoreProtocol {
    func fetchTime(_ countTimeContents: CountTimeContents) -> Observable<CountTimeFeed>
    func fetchSchedule(_ scheduleContents: ScheduleContents) -> Observable<ScheduleFeed>
}

struct BusTimerDataStore: BusTimerDataStoreProtocol {
    func fetchTime(_ countTimeContents: CountTimeContents) -> Observable<CountTimeFeed> {
        let request = GetCountTimeAPIRequest(countTimeContents: countTimeContents ,method: .get, path: "")
        return APIClient.rx.respose(to: request)
    }
    
    func fetchSchedule(_ scheduleContents: ScheduleContents) -> Observable<ScheduleFeed> {
        let request = GetScheduleAPIRequest(scheduleContents: scheduleContents, method: .get, path: "")
        
        return APIClient.rx.respose(to: request)
    }
}

struct GetCountTimeAPIRequest: APIRequest {
    typealias Response = CountTimeFeed
    let countTimeContents: CountTimeContents
    
    var method: HTTPMethod
    var path: String
    
    var parameters: [String : Any] {
        return [
            "bus_name": countTimeContents.busKind.value,
            "day_kind": countTimeContents.dayKind.value,
            "direction_kind": countTimeContents.directionKind.value
        ]
    }
}

struct GetScheduleAPIRequest: APIRequest {
    typealias Response = ScheduleFeed
    let scheduleContents: ScheduleContents
    
    var method: HTTPMethod
    var path: String
    
    var parameters: [String : Any] {
        return [
            "bus_name": scheduleContents.busName,
            "month": scheduleContents.month ,
            "day": scheduleContents.day
        ]
    }
}
