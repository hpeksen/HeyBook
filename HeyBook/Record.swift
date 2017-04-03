//
//  Record.swift
//  CTIS480_Fall1617_HW3_4
//
//  Created by Ctis on 13/12/2016.
//  Copyright © 2016 CTIS. All rights reserved.
//

import Foundation

@objc(Blog)
class Record : NSObject, NSCoding {
    var book_id: String
    var book_title: String
    var author_title: String
    var duration: String
    var photo: String
    var desc: String
    var demo: String
    var thumb: String
    
    init(book_id: String, book_title: String, author_title: String, duration: String, photo: String, desc: String, demo: String, thumb: String) {
        self.book_id = book_id
        self.book_title = book_title
        self.author_title = author_title
        self.duration = duration
        self.photo = photo
        self.desc = desc
        self.demo = demo
        self.thumb=thumb
    }
    
    required convenience init(coder aDecoder: NSCoder) {
          let book_id = aDecoder.decodeObject(forKey: "book_id") as! String
        let book_title = aDecoder.decodeObject(forKey: "book_title") as! String
        let author_title = aDecoder.decodeObject(forKey: "author_title") as! String
        let duration = aDecoder.decodeObject(forKey: "duration") as! String
        let photo = aDecoder.decodeObject(forKey: "photo") as! String
        let desc = aDecoder.decodeObject(forKey: "desc") as! String
        let demo = aDecoder.decodeObject(forKey: "demo") as! String
        let thumb = aDecoder.decodeObject(forKey: "thumb") as! String
        
        self.init(book_id:book_id, book_title: book_title, author_title: author_title, duration: duration, photo: photo, desc: desc, demo: demo, thumb: thumb)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(book_id, forKey: "book_id")
        aCoder.encode(book_title, forKey: "book_title")
        aCoder.encode(author_title, forKey: "author_title")
        aCoder.encode(duration, forKey: "duration")
        aCoder.encode(photo, forKey: "photo")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(demo, forKey: "demo")
        aCoder.encode(thumb, forKey: "thumb")
    }
}
