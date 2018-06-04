import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol TimeTableDetailRepositoryProtocol {
    func fetchTimeTable(busContents: BusContents) -> Observable<TimeTableFeed>
}

struct TimeTableDetailRepository: TimeTableDetailRepositoryProtocol {
    let timeTableDetailDataStore: TimeTableDetailDataStoreProtocol
    
    func fetchTimeTable(busContents: BusContents) -> Observable<TimeTableFeed> {
        return timeTableDetailDataStore.fetchTimeTable(busContents)
    }
}
