import UIKit
import Foundation

protocol SectionTableViewHeaderViewDelegeteProtocol {
    func updateHeader(section: Int)
}


class SectionTableViewHeaderView: UITableViewHeaderFooterView {
    private var imageView = UIImageView()
    var section = 0
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let separatorOfBottomView = UIView()
        separatorOfBottomView.backgroundColor = .lightGray
        self.contentView.addSubview(separatorOfBottomView)
        
        let separatorOfTopView = UIView()
        separatorOfTopView.backgroundColor = .lightGray
        self.contentView.addSubview(separatorOfTopView)
        
        separatorOfTopView.translatesAutoresizingMaskIntoConstraints = false
        separatorOfBottomView.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.textColor = UIColor(red: 0.14, green: 0.14, blue: 0.14, alpha: 1)
        
        let layouts = [
            separatorOfBottomView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorOfBottomView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            separatorOfBottomView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            separatorOfBottomView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            separatorOfTopView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorOfTopView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            separatorOfTopView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            separatorOfTopView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        ]
        
        NSLayoutConstraint.activate(layouts)
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.imageView)
        self.contentView.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1.0, constant: -8),
            NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1.0, constant: 0)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(isExpanded: Bool) {
        self.imageView.image = UIImage(named: isExpanded ? "ArrowUp" : "ArrowDown")
    }
}
