//
//  AlbumDetailViewController.swift
//  TopHundredAlbums
//
//  Created by chris davis on 2/9/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 0.2
        return imageView
    }()
    
    let albumNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 13)
        label.textColor = UIColor.lightGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 13)
        label.textColor = UIColor.lightGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let copyrightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 12)
        label.textColor = UIColor.lightGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let itunesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open Itunes Album", for: .normal)
        button.backgroundColor = Constants.iosBlueColor
        button.titleLabel?.font = UIFont(name: "Lato-Bold", size: 16)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(itunesButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var viewModel: AlbumDetailViewModel? {
        didSet{
            guard let albumArt = viewModel?.albumArt, let albumName = viewModel?.albumName, let artistName = viewModel?.artistName, let genres = viewModel?.genres, let releaseDate = viewModel?.releaseDate, let copyright = viewModel?.copyright else {return}
            
            albumImageView.setImage(albumArt: albumArt)
            albumNameLabel.text = albumName
            artistNameLabel.text = artistName
            
            var genreName = ""
            for genre in genres{
                if genreName.count > 0{
                    genreName += ", \(genre.name)"
                }else{
                    genreName += genre.name
                }
            }
            genreLabel.text = genreName
            releaseDateLabel.text = releaseDate
            copyrightLabel.text = copyright
        }
    }
    
    @objc func itunesButtonTapped(){
        guard let url = viewModel?.url else {return}
        //truncate first 6 characters (https:)
        let urlAfterEdit = url.dropFirst(6)
        guard let finalURL = URL(string: "itms:\(urlAfterEdit)") else {return}
        
        //if url is valid
        if UIApplication.shared.canOpenURL(finalURL){
            //only opens in real device
            UIApplication.shared.open(finalURL, options: [:], completionHandler: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        view.backgroundColor = UIColor.white
        view.addSubview(albumImageView)
        view.addSubview(albumNameLabel)
        view.addSubview(artistNameLabel)
        view.addSubview(genreLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(copyrightLabel)
        view.addSubview(itunesButton)
        
        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            albumImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            albumImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            albumNameLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 20),
            albumNameLabel.leadingAnchor.constraint(equalTo: albumImageView.leadingAnchor),
            albumNameLabel.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor),
            albumNameLabel.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.size.height * 0.05),
            
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 5),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumImageView.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor),
            artistNameLabel.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.size.height * 0.05),
            
            genreLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 10),
            genreLabel.leadingAnchor.constraint(equalTo: albumImageView.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor),
            genreLabel.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.size.height * 0.05),
            
            releaseDateLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 5),
            releaseDateLabel.leadingAnchor.constraint(equalTo: albumImageView.leadingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor),
            releaseDateLabel.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.size.height * 0.05),
            
            copyrightLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 5),
            copyrightLabel.leadingAnchor.constraint(equalTo: albumImageView.leadingAnchor),
            copyrightLabel.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor),
            copyrightLabel.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.size.height * 0.08),
            
            itunesButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            itunesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itunesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            itunesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
}
