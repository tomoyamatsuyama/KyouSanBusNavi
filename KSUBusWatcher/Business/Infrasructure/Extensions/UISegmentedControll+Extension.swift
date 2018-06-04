import UIKit

extension UISegmentedControl {
    func changeAllSegment(withArray: [String]){
        self.removeAllSegments()
        for title in withArray {
            self.insertSegment(withTitle: title, at: self.numberOfSegments, animated: false)
            self.setWidth(60.0, forSegmentAt: self.numberOfSegments - 1)
        }
        self.selectedSegmentIndex = 0
    }
    
    func changeAllSegment(withArray: [String], width: CGFloat){
        self.removeAllSegments()
        for title in withArray {
            self.insertSegment(withTitle: title, at: self.numberOfSegments, animated: false)
            self.setWidth(width, forSegmentAt: self.numberOfSegments - 1)
        }
        self.selectedSegmentIndex = 0
    }
}
