//
//  MenuTableViewCell.swift
//  HeyBook
//
//  Created by Admin on 01/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImage: UIImageView!

    @IBOutlet weak var lblMenuButton: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
