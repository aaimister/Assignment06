//
//  SnapCell.swift
//  SnapMe
//
//  Created by Aaron Kroupa on 11/15/16.
//  Copyright © 2016 Aaron Kroupa. All rights reserved.
//

import UIKit

class SnapCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var delegate: SnapCellDelegate?
    var snapData: SnapData? {
        didSet {
            configure()
        }
    }
    var longPressGesture: UILongPressGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func configure() {
        if let snap = snapData {
            icon.image = snap.isConsumed() ? #imageLiteral(resourceName: "viewed") : #imageLiteral(resourceName: "received")
            nameLabel.text = snap.getName()
            statusLabel.text = snap.getStatus()
            
            if !snap.isConsumed() {
                longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(SnapCell.longPress(_:)))
                self.addGestureRecognizer(longPressGesture!)
            }
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SnapCell.onTap(_:))))
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func longPress(_ sender: UILongPressGestureRecognizer) {
        if let del = delegate, let snap = snapData {
            if !snap.isConsumed() {
                switch(sender.state) {
                case .began:
                    del.showSnap(self)
                case .ended:
                    del.hideSnap(snap)
                case .cancelled:
                    del.hideSnap(snap)
                default:
                    return
                }
            }
        }
    }
    
    func onTap(_ sender: UITapGestureRecognizer) {
        if let del = delegate, let snap = snapData {
            snap.setStatus(.Tapped)
            //del.refreshTableAt(snap)
            switch(sender.state) {
            case .ended:
                let oldFrame = self.frame
//                UIView.animate(withDuration: 0.3, delay: 1, options: .curveLinear, animations: {
//                    self.frame = CGRect(x: 30, y: oldFrame.minY, width: oldFrame.size.width, height: oldFrame.size.height)
//                }, completion: { _ in
//                    UIView.animate(withDuration: 0.600, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//                        self.frame = oldFrame
//                    }, completion: { _ in
//                        snap.resetToPreviousStatus()
//                        del.refreshTableAt(snap)
//                    })
//
//                })
                UIView.animate(withDuration: 0.3, animations: {
                    self.frame = CGRect(x: 30, y: oldFrame.minY, width: oldFrame.size.width, height: oldFrame.size.height)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.600, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        self.frame = oldFrame
                    }, completion: { _ in
                        snap.resetToPreviousStatus()
                        del.refreshTableAt(snap)
                    })
                })
            case .cancelled, .failed:
                snap.resetToPreviousStatus()
                del.refreshTableAt(snap)
            default:
                return
            }
        }
    }
    
}
