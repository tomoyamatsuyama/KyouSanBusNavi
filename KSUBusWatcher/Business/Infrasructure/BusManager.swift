import Foundation
import UIKit
import Alamofire

enum UserDefaultsManager {
    case busName
    
    var key: String {
        switch self {
        case .busName:
            return "busName"
        }
    }
}

class BusManager {
    static func getBusKindForUserDefaults() -> BusKind? {
        guard let busName = UserDefaults.standard.string(forKey: UserDefaultsManager.busName.key) else { return nil }
        return BusKind(rawValue: busName)
    }
    
    static func setBusKindForUserDefaults(busKind: BusKind) -> BusKind? {
        UserDefaults.standard.set(busKind.value, forKey: UserDefaultsManager.busName.key)
        guard let busName = UserDefaults.standard.string(forKey: UserDefaultsManager.busName.key) else { return nil }
        return BusKind(rawValue: busName)
    }
}
