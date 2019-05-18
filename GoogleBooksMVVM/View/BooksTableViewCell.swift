//
//  BooksTableViewCell.swift
//  GoogleBooksMVVM
//
//  Created by Hammed opejin on 5/18/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

class BooksTableViewCell: UITableViewCell {
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorsLabel: UILabel!
    @IBOutlet weak var bookReleaseDateLabel: UILabel!
    
    static let identifier = "BooksTableViewCell"
    
    func configureCell(book: Book) {
        bookTitleLabel.text = book.title
        bookAuthorsLabel.text = book.authors.joined(separator: ", ")
        bookReleaseDateLabel.text = book.publishedDate
        
        let url = book.imageUrl
        
        downloadService.downloadImage(url: url) { [unowned self] image in
            
            self.bookImage.image = image != nil ? image : #imageLiteral(resourceName: "book")
            
        }
        
        
    }
}
