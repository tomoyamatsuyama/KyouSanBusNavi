import UIKit
import Foundation

extension UIButton {
    func kbt_setUp(_ title: String) {
        setTitle(title, for: .normal)
        switch title {
        case "日祝":
            setTitleColor(.red, for: .normal)
        case "土曜":
            setTitleColor(.blue, for: .normal)
        case "行き":
            setTitleColor(.blue, for: .normal)
        case "帰り":
            setTitleColor(.red, for: .normal)
        default:
            setTitleColor(.white, for: .normal)
        }
    }
}
