//
//  AlbumCellViewModel.swift
//  TopHundredAlbums
//
//  Created by chris davis on 2/8/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

class AlbumCellViewModel: NSObject {
    
    let albumName: String
    let artistName: String
    let albumArt: String
    
    init(_ album: Album) {
        albumName = album.albumName
        artistName = album.artistName
        albumArt = album.albumArt
    }
}
