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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
