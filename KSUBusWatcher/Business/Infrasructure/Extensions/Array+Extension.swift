import UIKit
import Foundation

extension Array where Element: Equatable {
    var unique: [Element] {
        
        return reduce([]) { first, second in
            first.contains(second) ? first : first + [second]
        }
    }
}


