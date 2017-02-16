//
//  Record.swift
//  CTIS480_Fall1617_HW3_4
//
//  Created by Ctis on 13/12/2016.
//  Copyright © 2016 CTIS. All rights reserved.
//

import Foundation

class Record {
    
    var book_title: String
    var author_title: String
    var duration: String
    var photo: String
    var desc: String
    var demo: String
    var thumb: String
    
    init(book_title: String, author_title: String, duration: String, photo: String, desc: String, demo: String, thumb: String) {
        self.book_title = book_title
        self.author_title = author_title
        self.duration = duration
        self.photo = photo
        self.desc = desc
        self.demo = demo
        self.thumb=thumb
    }
        
}
