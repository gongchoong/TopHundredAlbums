//
//  AlbumCell.swift
//  TopHundredAlbums
//
//  Created by chris davis on 2/8/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        return String(describing: self)
    }

}
