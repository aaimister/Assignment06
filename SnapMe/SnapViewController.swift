//
//  SnapViewController.swift
//  SnapMe
//
//  Created by Aaron Kroupa on 11/15/16.
//  Copyright © 2016 Aaron Kroupa. All rights reserved.
//

import UIKit

class SnapViewController: UIViewController {

    
    @IBOutlet weak var snapImage: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var detailItem: SnapData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
