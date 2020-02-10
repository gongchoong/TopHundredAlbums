//
//  MainViewModel.swift
//  TopHundredAlbums
//
//  Created by chris davis on 2/8/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

class MainViewModel: NSObject {
    
    let apiService: ApiServiceProtocol
    fileprivate var albums = [Album]()
    
    fileprivate var albumCellViewModels = [AlbumCellViewModel]() {
        didSet {
            //reload tableview when data fetch is finished
            tableViewReloadClosure?()
        }
    }
    
    var numberOfCells: Int {
        return albumCellViewModels.count
    }
    
    var errorMessage: String? {
        didSet {
            //data fetch error -> show error message
            showErrorMessageClosure?()
        }
    }
    
    var tableViewReloadClosure: (()->())?
    var showErrorMessageClosure: (()->())?
    
    init(_ api: ApiServiceProtocol = ApiService()) {
        self.apiService = api
    }
    
    func fetch(){
        apiService.fetchTopHundredAlbums { (successful, albums, error) in
            if let err = error{
                self.errorMessage = err.localizedDescription
            }else{
                 self.process(albums)
            }
        }
    }
    
    fileprivate func process(_ albums: [Album]){
        self.albums = albums
        var albumCellVms = [AlbumCellViewModel]()
        
        //generate albumViewModel for each albumCell
        for album in albums{
            albumCellVms.append(AlbumCellViewModel(album))
        }
        self.albumCellViewModels = albumCellVms
    }
    
    func getAlbumCellViewModel(_ indexPath: IndexPath) -> AlbumCellViewModel{
        let albumCellViewModel = self.albumCellViewModels[indexPath.row]
        albumCellViewModel.indexPath = indexPath
        return albumCellViewModel
    }
    
    func getAlbum(_ indexPath: IndexPath) -> Album{
        return albums[indexPath.row]
    }
}
