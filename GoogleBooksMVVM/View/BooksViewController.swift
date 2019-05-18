//
//  BooksViewController.swift
//  GoogleBooksMVVM
//
//  Created by Hammed opejin on 5/18/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController {
    @IBOutlet weak var booksTableview: UITableView!
    
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    var viewModel: BooksViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupTableView()
        setupSearch()
    }
    
    func setupViewModel() {
        viewModel = BooksViewModel()
        viewModel.delegate = self
    }
    
    func setupTableView() {
        
        booksTableview.delegate = self
        booksTableview.dataSource = self
        booksTableview.register(UINib(nibName: BooksTableViewCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: BooksTableViewCell.identifier)
        booksTableview.tableFooterView = UIView(frame: .zero)
        
    }
    
    func setupSearch() {
        resultSearchController = ({
            
            let controller = UISearchController(searchResultsController: nil)
            controller.searchBar.delegate = self
            controller.dimsBackgroundDuringPresentation = false
            controller.definesPresentationContext = true
            controller.searchBar.sizeToFit()
            controller.searchBar.tintColor = .black
            controller.searchBar.placeholder = "Search Google Books"
            
            return controller
        })()
        
        booksTableview.tableHeaderView = resultSearchController.searchBar
    }

}

extension BooksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier, for: indexPath) as! BooksTableViewCell
        
        let book = viewModel.books[indexPath.row]
        cell.configureCell(book: book)
        
        return cell
    }
    
}

extension BooksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        resultSearchController.dismiss(animated: true, completion: nil)
        
        viewModel.currentBook = viewModel.books[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.viewModel = viewModel
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: BooksViewModelDelegate
extension BooksViewController: BooksViewModelDelegate {
    
    func updateView() {
        booksTableview.reloadData()
    }
}

extension BooksViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resultSearchController.dismiss(animated: true, completion: nil)
        if let searchTerm = searchBar.text {
          viewModel.get(searchTerm: searchTerm, vc: self)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        tabBarController?.tabBar.isHidden = true
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tabBarController?.tabBar.isHidden = false
    }

}
