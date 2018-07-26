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
    func getAudioPosts(username: String){
        
         let link = "https://api.tumblr.com/v2/blog/\(username)/posts/audio?api_key=7uLhMXjYCmqyvzkaWqCXiSZ3RTEIEh9ex8QR3AWAY5RdpGXKcU"
        
    }
    
}


