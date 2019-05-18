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
    var flag = false

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViews()
    }
    

    func bindViews() {
        
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
        
        let books = dataService.getBooks()
        if books.count > 0 {
            for bk in books {
                if bk.id == viewModel.currentBook.id {
                    flag = true
                }
            }
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(DetailViewController.backAction))
        self.navigationItem.rightBarButtonItem?.setBackgroundImage(resizeImage(image: flag ? #imageLiteral(resourceName: "stargold") : #imageLiteral(resourceName: "starplain"), targetSize: CGSize(width: 100.0, height: 40.0)), for: .normal, barMetrics: .default)
    }
    
    @objc func backAction() {
        flag ? dataService.deleteBook(viewModel.currentBook) : dataService.saveBook(viewModel.currentBook)
        
        self.navigationItem.rightBarButtonItem?.setBackgroundImage(resizeImage(image: flag ? #imageLiteral(resourceName: "starplain") : #imageLiteral(resourceName: "stargold"), targetSize: CGSize(width: 100.0, height: 40.0)), for: .normal, barMetrics: .default)
        flag = flag ? false : true
    }

}
