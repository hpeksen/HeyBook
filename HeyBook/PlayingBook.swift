//
//  PlayingBook.swift
//  HeyBook
//
//  Created by Erol Gizlice on 29/04/17.
//  Copyright © 2017 Team1. All rights reserved.
//

import Foundation
import AVFoundation

class PlayingBook {
    var book:Record
    var player:AVPlayer
    var audioPlayer:AVAudioPlayer
    var isDownloaded:Bool
    var lastPlayPosition:String
    
    init(book:Record, player:AVPlayer, audioPlayer:AVAudioPlayer, isDownloaded:Bool, lastPlayPosition:String) {
        self.book = book
        self.player = player
        self.audioPlayer = audioPlayer
        self.isDownloaded = isDownloaded
        self.lastPlayPosition = lastPlayPosition
    }
}
