//
//  AlbumCell.swift
//  TopHundredAlbums
//
//  Created by chris davis on 2/8/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

protocol AlbumCellDelegate: class {
    func reloadIndividualTableviewCell()
}

class AlbumCell: UITableViewCell {
    
    let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let albumNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 13)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    var delegate: AlbumCellDelegate?
    var albumNameHeightConstraint: NSLayoutConstraint?
    
    var viewModel: AlbumCellViewModel? {
        didSet{
            guard let albumArt = viewModel?.albumArt, let albumName = viewModel?.albumName, let artistName = viewModel?.artistName else {return}
            albumImageView.image = nil
            albumImageView.setImage(albumArt: albumArt)
            
            albumNameLabel.text = albumName
            artistNameLabel.text = artistName
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        addSubview(albumImageView)
        addSubview(albumNameLabel)
        addSubview(artistNameLabel)
        
        NSLayoutConstraint.activate([
            albumImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            albumImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: frame.size.height * 0.3),
            albumImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            albumImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            
            albumNameLabel.bottomAnchor.constraint(equalTo: albumImageView.centerYAnchor),
            albumNameLabel.leftAnchor.constraint(equalTo: albumImageView.rightAnchor, constant: frame.size.height * 0.3),
            albumNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -frame.size.height * 0.3),
            
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor),
            artistNameLabel.leftAnchor.constraint(equalTo: albumNameLabel.leftAnchor),
            artistNameLabel.rightAnchor.constraint(equalTo: albumNameLabel.rightAnchor),
            artistNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
}

extension UIImageView {
    func setImage(albumArt: String?){
        guard let albumArtURL = albumArt else {return}
        guard let url = URL(string: albumArtURL) else {return}
        
        //if image exists in cache
        if let cacheImage = imageCache.object(forKey: albumArtURL as AnyObject) as? UIImage{
            self.image = cacheImage
            return
        }
        
        //if image does not exist in cache, download image then write it to cache
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error{
                print(err.localizedDescription)
                return
            }
            
            guard let dataResponse = data else {return}
            guard let image = UIImage(data: dataResponse) else {return}
            //write to cache
            imageCache.setObject(image, forKey: albumArtURL as AnyObject)
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }
        task.resume()
    }
}

extension UILabel {

    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }

}
