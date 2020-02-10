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
    
    let albumName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    let artistName: UILabel = {
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
            albumImageView.image = nil
            albumImageView.setImage(albumArt: viewModel?.albumArt)
            
            albumName.text = viewModel?.albumName
            artistName.text = viewModel?.artistName
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        addSubview(albumImageView)
        addSubview(albumName)
        addSubview(artistName)
        
        NSLayoutConstraint.activate([
            albumImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            albumImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: frame.size.height * 0.3),
            albumImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            albumImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            
            albumName.bottomAnchor.constraint(equalTo: albumImageView.centerYAnchor),
            albumName.leftAnchor.constraint(equalTo: albumImageView.rightAnchor, constant: frame.size.height * 0.3),
            albumName.rightAnchor.constraint(equalTo: rightAnchor, constant: -frame.size.height * 0.3),
            
            artistName.topAnchor.constraint(equalTo: albumName.bottomAnchor),
            artistName.leftAnchor.constraint(equalTo: albumName.leftAnchor),
            artistName.rightAnchor.constraint(equalTo: albumName.rightAnchor),
            artistName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
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
        
        if let cacheImage = imageCache.object(forKey: albumArtURL as AnyObject) as? UIImage{
            self.image = cacheImage
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error{
                print(err.localizedDescription)
                return
            }
            
            guard let dataResponse = data else {return}
            guard let image = UIImage(data: dataResponse) else {return}
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
