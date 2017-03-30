//
//  CustomCollectionViewCell.swift
//  HeyBook
//
//  Created by Admin on 04/01/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var leftView: UIView!
}
