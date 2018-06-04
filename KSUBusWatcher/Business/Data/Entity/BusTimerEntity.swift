import Foundation

struct CountTimeFeed: Codable {
    let busKind, dayKind, directionKind: String
    let countTimes: [CountTime]
    
    enum CodingKeys: String, CodingKey {
        case busKind = "bus_kind"
        case dayKind = "day_kind"
        case directionKind = "direction_kind"
        case countTimes
    }
    
    struct CountTime: Codable {
        let isFinished, isCirculation: Bool
        let time: Time
        
        enum CodingKeys: String, CodingKey {
            case isFinished = "is_finished"
            case isCirculation = "is_circulation"
            case time
        }
        
        struct Time: Codable {
            let hour, minutes: Int
        }
        
    }

}

struct ScheduleFeed: Codable {
    let diaKind: String
    
    enum CodingKeys: String, CodingKey {
        case diaKind = "dia_kind"
    }
}
