import Foundation

struct TimeTableFeed: Codable {
    let busName, direction, directionKind, dayKind: String
    let times: [Time]
    
    enum CodingKeys: String, CodingKey {
        case busName = "bus_name"
        case direction
        case directionKind = "direction_kind"
        case dayKind = "day_kind"
        case times
    }
    
    struct Time: Codable {
        let hour: Int
        let minutes: [Int]
    }
}

