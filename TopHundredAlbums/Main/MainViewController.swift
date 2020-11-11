//
//  MainViewController.swift
//  TopHundredAlbums
//
//  Created by chris davis on 2/8/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

//test for commit
import UIKit

class MainViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var viewModel: MainViewModel = {
        let viewModel = MainViewModel()
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableview()
        
        initViewModel()
    }
    
    fileprivate func setupTableview(){
        navigationController?.navigationBar.topItem?.title = "Top 100 Albums"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.identifier)
        tableView.separatorStyle = .none
        
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    fileprivate func initViewModel(){
        
        viewModel.tableViewReloadClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.showErrorMessageClosure = { [weak self] () in
            guard let errorMessage = self?.viewModel.errorMessage else {return}
            DispatchQueue.main.async {
                self?.showAlert(errorMessage)
            }
        }
        
        //start fetching data
        viewModel.fetch()
    }
    
    fileprivate func resizeAlbumNameHeight(_ cell: AlbumCell){
        //resize albumName height by number of lines in text
        cell.albumNameHeightConstraint?.isActive = false
        if cell.albumNameLabel.calculateMaxLines() > 1{
            //if albunName label has more than 1 lines of text
            cell.albumNameHeightConstraint = cell.albumNameLabel.heightAnchor.constraint(lessThanOrEqualToConstant: cell.frame.size.height * 0.4)
        }else{
            //if albunName label has 1 line of text
            cell.albumNameHeightConstraint = cell.albumNameLabel.heightAnchor.constraint(equalToConstant: cell.frame.size.height * 0.2)
        }
        cell.albumNameHeightConstraint?.isActive = true
    }
    
    fileprivate func showAlert(_ message: String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.identifier, for: indexPath) as? AlbumCell else {
            print("cell deque error")
            return UITableViewCell()
        }
        let vm = viewModel.getAlbumCellViewModel(indexPath)
        cell.selectionStyle = .none
        cell.viewModel = vm
        resizeAlbumNameHeight(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //present 8 cells per screen
        return tableView.frame.size.height/8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = viewModel.getAlbum(indexPath)
        let albumDetailViewController = AlbumDetailViewController()
        albumDetailViewController.viewModel = AlbumDetailViewModel(album)
        navigationController?.pushViewController(albumDetailViewController, animated: true)
    }
}

