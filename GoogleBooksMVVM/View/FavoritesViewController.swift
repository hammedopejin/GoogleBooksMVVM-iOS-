//
//  FavoritesViewController.swift
//  GoogleBooksMVVM
//
//  Created by Hammed opejin on 5/18/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableview: UITableView!
    
    var favoriteViewModel: FavoritesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        favoriteViewModel.get()
    }
    
    func setupViewModel() {
        favoriteViewModel = FavoritesViewModel()
        favoriteViewModel.delegate = self
    }
    
    func setupTableView() {
        
        favoritesTableview.dataSource = self
        favoritesTableview.delegate = self
        favoritesTableview.register(UINib(nibName: BooksTableViewCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: BooksTableViewCell.identifier)
        favoritesTableview.tableFooterView = UIView(frame: .zero)
   
    }

}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteViewModel.favoriteBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier, for: indexPath) as! BooksTableViewCell
        
        let book = favoriteViewModel.favoriteBooks[indexPath.row]
        cell.configureCell(book: book)
        
        return cell
    }

}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        favoriteViewModel.currentBook = favoriteViewModel.favoriteBooks[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.favoriteViewModel = favoriteViewModel
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let book = favoriteViewModel.favoriteBooks[indexPath.row]
        favoriteViewModel.favoriteBooks.remove(at: indexPath.row)
        coreManager.deleteBook(book)
        tableView.reloadData()
    }
}

//MARK FavoritesViewMOdelDelegate
extension FavoritesViewController: FavoritesViewModelDelegate {
    
    func updateView() {
        favoritesTableview.reloadData()
    }
}
