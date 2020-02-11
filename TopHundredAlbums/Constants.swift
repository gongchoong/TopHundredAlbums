//
//  Constants.swift
//  TopHundredAlbums
//
//  Created by chris davis on 2/8/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

struct Constants {
    static let RSSURL = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"
    static let iosBlueColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
}

var imageCache = NSCache<AnyObject, AnyObject>()
