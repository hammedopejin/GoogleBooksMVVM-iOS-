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
    
    var books = [Book]() {
        didSet {
            favoritesTableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        books = dataService.getBooks()
    }
    
    func setupTableView() {
        
        favoritesTableview.dataSource = self
        favoritesTableview.delegate = self
        favoritesTableview.register(UINib(nibName: "BooksTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: BooksTableViewCell.identifier)
        favoritesTableview.tableFooterView = UIView(frame: .zero)
   
    }

}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier, for: indexPath) as! BooksTableViewCell
        
        let book = books[indexPath.row]
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        //vc.book = books[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        books.remove(at: indexPath.row)
        dataService.deleteBook(book)
        tableView.reloadData()
    }
}
