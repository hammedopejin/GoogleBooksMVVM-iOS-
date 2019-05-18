//
//  DetailViewController.swift
//  GoogleBooksMVVM
//
//  Created by Hammed opejin on 5/18/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    @IBOutlet weak var bookPublishedDate: UILabel!
    @IBOutlet weak var bookDescription: UITextView!
    @IBOutlet weak var bookPublisher: UILabel!
    
    var viewModel: BooksViewModel!
    var favoriteViewModel: FavoritesViewModel!
    var flag = false

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViews()
    }
    
    func bindViews() {
        
        if viewModel != nil {
            bookTitle.text = viewModel.currentBook.title
            bookAuthors.text = viewModel.currentBook.authors.joined(separator: ", ")
            bookPublishedDate.text = viewModel.currentBook.publishedDate
            bookDescription.text = viewModel.currentBook.bookDescription
            bookPublisher.text = viewModel.currentBook.publisher
            
            let url = viewModel.currentBook.imageUrl
            downloadService.downloadImage(url: url) {[unowned self] image in
                let img = image != nil ? image : #imageLiteral(resourceName: "book")
                
                DispatchQueue.main.async {
                    self.bookImage.image = img
                }
            }
            
            let books = coreManager.getBooks()
            if books.count > 0 {
                for bk in books {
                    if bk.id == viewModel.currentBook.id {
                        flag = true
                    }
                }
            }
        } else {
            bookTitle.text = favoriteViewModel.currentBook.title
            bookAuthors.text = favoriteViewModel.currentBook.authors.joined(separator: ", ")
            bookPublishedDate.text = favoriteViewModel.currentBook.publishedDate
            bookDescription.text = favoriteViewModel.currentBook.bookDescription
            bookPublisher.text = favoriteViewModel.currentBook.publisher
            
            let url = favoriteViewModel.currentBook.imageUrl
            downloadService.downloadImage(url: url) {[unowned self] image in
                let img = image != nil ? image : #imageLiteral(resourceName: "book")
                
                DispatchQueue.main.async {
                    self.bookImage.image = img
                }
            }
            
            let books = coreManager.getBooks()
            if books.count > 0 {
                for bk in books {
                    if bk.id == favoriteViewModel.currentBook.id {
                        flag = true
                    }
                }
            }
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(DetailViewController.backAction))
        self.navigationItem.rightBarButtonItem?.setBackgroundImage(resizeImage(image: flag ? #imageLiteral(resourceName: "stargold") : #imageLiteral(resourceName: "starplain"), targetSize: CGSize(width: 100.0, height: 40.0)), for: .normal, barMetrics: .default)
    }
    
    @objc func backAction() {
        
        if viewModel != nil {
            flag ? coreManager.deleteBook(viewModel.currentBook) : coreManager.saveBook(viewModel.currentBook)
        } else {
            flag ? coreManager.deleteBook(favoriteViewModel.currentBook) : coreManager.saveBook(favoriteViewModel.currentBook)
        }
        
        self.navigationItem.rightBarButtonItem?.setBackgroundImage(resizeImage(image: flag ? #imageLiteral(resourceName: "starplain") : #imageLiteral(resourceName: "stargold"), targetSize: CGSize(width: 100.0, height: 40.0)), for: .normal, barMetrics: .default)
        flag = flag ? false : true
    }

}
