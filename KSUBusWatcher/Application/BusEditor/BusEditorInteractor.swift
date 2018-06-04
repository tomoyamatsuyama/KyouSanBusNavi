import Foundation
import UIKit
import RxSwift
import RxCocoa

class BusEditorInteractor: BusEditorInteractorProtocol {
    func apply(_ updateContents: BusKind) -> BusKind? {
        return BusManager.setBusKindForUserDefaults(busKind: updateContents)
    }
}
