import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol TimeTableDetailDataStoreProtocol {
    func fetchTimeTable(_ busContents: BusContents) -> Observable<TimeTableFeed>
}

struct TimeTableDetailAPIDataStore: TimeTableDetailDataStoreProtocol {
    func fetchTimeTable(_ busContents: BusContents) -> Observable<TimeTableFeed> {
        let request = GetTimeTableAPIRequest(busContents: busContents, method: .get, path: "")
        return APIClient.rx.respose(to: request)
    }
}

private struct GetTimeTableAPIRequest: APIRequest {
    typealias Response = TimeTableFeed
    let busContents: BusContents
    var method: HTTPMethod
    var path: String
    var parameters: [String : Any] {
        return [
            "bus_name" : busContents.busKind.value,
            "day_kind" : busContents.dayKind.value,
            "direction_kind": busContents.directionKind.value,
        ]
    }
}
