//
//  HorizontalCategoriesCollectionViewCell.swift
//  HeyBook
//
//  Created by Admin on 23/03/2017.
//  Copyright © 2017 Team1. All rights reserved.
//

import UIKit
import Cosmos

class HorizontalCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoriesBookName: UILabel!
    @IBOutlet weak var categoriesBookImage: UIImageView!
    @IBOutlet weak var categoriesBookRating: CosmosView!
    @IBOutlet weak var categoriesBookAuthor: UILabel!
    @IBOutlet weak var categoriesBookPrice: UILabel!
}
