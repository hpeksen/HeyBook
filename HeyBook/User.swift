//
//  User.swift
//  HeyBook
//
//  Created by Admin on 10/01/2017.
//  Copyright © 2017 Team1. All rights reserved.
//


import Foundation

class User {
    
    var user_id: String
    var user_title: String
    var mail: String
    var password: String
    var subscribe: String
    var photo: String
    var valid_status: String
    
    
    init(user_id: String, user_title: String, mail: String, password: String, subscribe: String, photo: String, valid_status: String) {
        self.user_id = user_id
        self.user_title = user_title
        self.mail = mail
        self.photo = photo
        self.password = password
        self.subscribe = subscribe
        self.photo=photo
         self.valid_status=valid_status
    }
    
}
