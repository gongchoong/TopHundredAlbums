//
//  MainViewController.swift
//  TopHundredAlbums
//
//  Created by chris davis on 2/8/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

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
        // Do any additional setup after loading the view.
        setupTableview()
        
        initViewModel()
    }
    
    fileprivate func setupTableview(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.identifier)
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
            print(self?.viewModel.errorMessage)
        }
        
        //start fetching data
        viewModel.fetch()
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.identifier, for: indexPath) as? AlbumCell else {
            fatalError("cell error")
        }
        let vm = viewModel.getAlbumCellViewModel(indexPath)
        cell.textLabel?.text = "\(vm.albumName)"
        return cell
    }
    
    
}

