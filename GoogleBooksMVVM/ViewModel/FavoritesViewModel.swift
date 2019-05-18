//
//  FavoritesViewModel.swift
//  GoogleBooksMVVM
//
//  Created by Hammed opejin on 5/18/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

protocol FavoritesViewModelDelegate: class {
    func updateView()
}

class FavoritesViewModel {
    
    weak var delegate: FavoritesViewModelDelegate?
    
    var favoriteBooks = [Book]() {
        didSet {
            delegate?.updateView()
        }
    }
    
    var currentBook: Book!
    
    func get() {
        favoriteBooks = coreManager.getBooks()
    }
    
}
