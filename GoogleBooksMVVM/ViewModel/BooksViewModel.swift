//
//  BooksViewModel.swift
//  GoogleBooksMVVM
//
//  Created by Hammed opejin on 5/18/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

protocol BooksViewModelDelegate: class {
    func updateView()
    func showUpdateAlert()
}

class BooksViewModel {
    
    weak var delegate: BooksViewModelDelegate?
    
    private(set) var books = [Book]() {
        didSet {
            delegate?.updateView()
            delegate?.showUpdateAlert()
        }
    }
    
    var currentBook: Book!
    
    func get(searchTerm: String) {
    
        downloadService.getBooks(searchTerm: searchTerm) { [unowned self] bks in
            
            if let books = bks {
                self.books = books
            }
        }
    }
    
}
