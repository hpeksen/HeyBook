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
    var category_id: String
    var publisher_id: String
    var author_id: String
    var narrator_id: String
    var book_title: String
    var desc: String
    var price: String
    var photo: String
    var thumb: String
    var audio: String
    var duration: String
    var size: String
    var demo: String
    var star: String
    var category_title: String
    var author_title: String
    var publisher_title: String
    
    init(book_id: String, category_id: String, publisher_id: String, author_id: String, narrator_id: String, book_title: String, desc: String, price: String, photo: String, thumb: String, audio: String, duration: String, size: String, demo: String, star: String, category_title: String, author_title: String, publisher_title: String) {
        self.book_id = book_id
        self.category_id = category_id
        self.publisher_id = publisher_id
        self.author_id = author_id
        self.narrator_id = narrator_id
        self.book_title = book_title
        self.desc = desc
        self.price = price
        self.photo = photo
        self.thumb = thumb
        self.audio = audio
        self.duration = duration
        self.size = size
        self.demo = demo
        self.star = star
        self.category_title = category_title
        self.author_title = author_title
        self.publisher_title = publisher_title
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let book_id = aDecoder.decodeObject(forKey: "book_id") as! String
        let category_id = aDecoder.decodeObject(forKey: "category_id") as! String
        let publisher_id = aDecoder.decodeObject(forKey: "publisher_id") as! String
        let author_id = aDecoder.decodeObject(forKey: "author_id") as! String
        let narrator_id = aDecoder.decodeObject(forKey: "narrator_id") as! String
        let book_title = aDecoder.decodeObject(forKey: "book_title") as! String
        let desc = aDecoder.decodeObject(forKey: "desc") as! String
        let price = aDecoder.decodeObject(forKey: "price") as! String
        let photo = aDecoder.decodeObject(forKey: "photo") as! String
        let thumb = aDecoder.decodeObject(forKey: "thumb") as! String
        let audio = aDecoder.decodeObject(forKey: "audio") as! String
        let duration = aDecoder.decodeObject(forKey: "duration") as! String
        let size = aDecoder.decodeObject(forKey: "size") as! String
        let demo = aDecoder.decodeObject(forKey: "demo") as! String
        let star = aDecoder.decodeObject(forKey: "star") as! String
        let category_title = aDecoder.decodeObject(forKey: "category_title") as! String
        let author_title = aDecoder.decodeObject(forKey: "author_title") as! String
        let publisher_title = aDecoder.decodeObject(forKey: "publisher_title") as! String
        
        self.init(book_id: book_id, category_id: category_id, publisher_id: publisher_id, author_id: author_id, narrator_id: narrator_id, book_title: book_title, desc: desc, price: price,  photo: photo, thumb: thumb, audio: audio, duration: duration, size: size,  demo: demo, star: star, category_title: category_title, author_title: author_title, publisher_title: publisher_title)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(book_id, forKey: "book_id")
        aCoder.encode(category_id, forKey: "category_id")
        aCoder.encode(publisher_id, forKey: "publisher_id")
        aCoder.encode(author_id, forKey: "author_id")
        aCoder.encode(narrator_id, forKey: "narrator_id")
        aCoder.encode(book_title, forKey: "book_title")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(photo, forKey: "photo")
        aCoder.encode(thumb, forKey: "thumb")
        aCoder.encode(audio, forKey: "audio")
        aCoder.encode(duration, forKey: "duration")
        aCoder.encode(size, forKey: "size")
        aCoder.encode(demo, forKey: "demo")
        aCoder.encode(star, forKey: "star")
        aCoder.encode(category_title, forKey: "category_title")
        aCoder.encode(author_title, forKey: "author_title")
        aCoder.encode(publisher_title, forKey: "publisher_title")
    }

}
