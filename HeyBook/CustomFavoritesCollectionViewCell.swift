//
//  CustomFavoritesCollectionViewCell.swift
//  HeyBook
//
//  Created by Admin on 14/04/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit

class CustomFavoritesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookDuration: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var deleteBookFromFav: UIButton!
    @IBAction func deleteFavoritesBtn(_ sender: Any) {
    }
}
