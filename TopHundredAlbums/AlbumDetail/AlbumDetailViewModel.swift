//
//  AlbumDetailViewModel.swift
//  TopHundredAlbums
//
//  Created by chris davis on 2/9/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

class AlbumDetailViewModel: NSObject {
    let albumName: String
    let artistName: String
    let albumArt: String
    let genres: [Genre]
    let releaseDate: String
    let copyright: String
    let url:String
    
    init(_ album: Album) {
        albumName = album.albumName
        artistName = album.artistName
        albumArt = album.albumArt
        genres = album.genres
        releaseDate = album.releaseDate
        copyright = album.copyright
        url = album.url
    }
}
