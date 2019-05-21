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
    var book: Book!
    
    var isFavorite: Bool {
        return viewModel == nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBook()
        bindViews()
    }
    
    func setupBook() {
        switch isFavorite {
        case true:
            book = favoriteViewModel.currentBook
        default:
            book = viewModel.currentBook
        }
    }
    
    func bindViews() {
        
        bookTitle.text = book.title
        bookAuthors.text = book.authors.joined(separator: ", ")
        bookPublishedDate.text = book.publishedDate
        bookDescription.text = book.bookDescription
        bookPublisher.text = book.publisher
        
        let url = book.imageUrl
        downloadService.downloadImage(url: url) {[unowned self] image in
            let img = image != nil ? image : #imageLiteral(resourceName: "book")
            
            DispatchQueue.main.async {
                self.bookImage.image = img
            }
        }
        
        flag = coreManager.isFavorite(book.id)
        
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
