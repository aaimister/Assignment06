//
//  SnapViewController.swift
//  SnapMe
//
//  Created by Aaron Kroupa on 11/15/16.
//  Copyright © 2016 Aaron Kroupa. All rights reserved.
//

import UIKit

class SnapViewController: UIViewController, SnapTimerDelegate {

    
    @IBOutlet weak var snapImage: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var detailItem: SnapCell? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    private func configureView() {
        if let item = detailItem {
            self.view.addGestureRecognizer(item.longPressGesture!)
            if let snap = item.snapData {
                snap.delegate = self
                if snapImage != nil {
                    snapImage.image = snap.getImage()
                }
                if timerLabel != nil {
                    timerLabel.text = "\(snap.getSeconds())"
                }
            }
        }
    }
    
    func timeUpdate(_ newTime: Int) {
        self.timerLabel.text = String(newTime)
        if newTime == 0 {
            print("hide snap")
            detailItem?.snapData?.setStatus(.Viewed)
            detailItem?.delegate?.hideSnap(detailItem!.snapData!)
        }
    }
    
}
