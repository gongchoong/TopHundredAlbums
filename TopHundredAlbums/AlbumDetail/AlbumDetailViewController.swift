//
//  AlbumDetailViewController.swift
//  TopHundredAlbums
//
//  Created by chris davis on 2/9/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    var viewModel: AlbumDetailViewModel? {
        didSet{
            //update ui
            print(viewModel?.albumName)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        // Do any additional setup after loading the view.
    }
    
}
