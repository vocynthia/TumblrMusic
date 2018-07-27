//
//  NetworService.swift
//  TumblrMusic
//
//  Created by Macbook on 7/25/18.
//  Copyright © 2018 makeschool. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON


struct NetworkManager {
    func getAudioPosts(username: String) -> String {
        let url = "https://api.tumblr.com/v2/blog/\(username)/posts/audio?api_key=7uLhMXjYCmqyvzkaWqCXiSZ3RTEIEh9ex8QR3AWAY5RdpGXKcU"
        return url
        }
    }

struct filter {
   
    let albumArt: String
    let artist: String
    let album: String
    let trackName: String
//    let data: String  //music file
    
    init(json:JSON) {
        self.albumArt = json["album_art"].stringValue
        self.artist = json["artist"].stringValue
        self.album = json["artst"].stringValue
        self.trackName = json["track_name"].stringValue
//        self.data =
        
    }
    
}




  

