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
}

class BooksViewModel {
    
    weak var delegate: BooksViewModelDelegate?
    
    private(set) var books = [Book]() {
        didSet {
            delegate?.updateView()
        }
    }
    
    var currentBook: Book!
    
    func get(searchTerm: String, vc: UIViewController) {
    
        downloadService.getBooks(searchTerm: searchTerm, vc: vc) { [unowned self] bks in
            
            if let books = bks {
                self.books = books
            }
        }
    }
    
}
