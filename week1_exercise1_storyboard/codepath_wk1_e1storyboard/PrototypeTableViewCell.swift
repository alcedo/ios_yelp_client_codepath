//
//  PrototypeTableViewCell.swift
//  codepath_wk1_e1storyboard
//
//  Created by Victor Liew on 5/6/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit

class PrototypeTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
