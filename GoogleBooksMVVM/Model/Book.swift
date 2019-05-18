//
//  Book.swift
//  GoogleBooksMVVM
//
//  Created by Hammed opejin on 5/17/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit
import CoreData

enum BookErrors: Error {
    case missing(String)
}

class Book {
    let id: String
    let title: String
    let authors: [String]
    let publisher: String
    let publishedDate: String
    let bookDescription: String
    let imageUrl: String
    
    init?(json: [String: Any]) throws {
        
        guard let bookInfo = json["volumeInfo"] as? [String: Any], let id = json["id"] as? String  else {
            throw BookErrors.missing("Missing Book Id")
        }
        self.id = id
        
        var imageLinks = ["" : ""]
        if let imgLinks = bookInfo["imageLinks"] as? [String: String]  {
            imageLinks = imgLinks
        }
        
        var title = "No Title"
        if let titl = bookInfo["title"] as? String {
            title = titl
        }
        self.title = title
        
        var author = ["Anonmous Author"]
        if let auth = bookInfo["authors"] as? [String] {
            author = auth
        }
        self.authors = author
        
        var publisher = "NA"
        if let pub = bookInfo["publisher"] as? String {
            publisher = pub
        }
        self.publisher = publisher
        
        var publishedDate = "NA"
        if let date = bookInfo["publishedDate"] as? String {
            publishedDate = date
        }
        self.publishedDate = publishedDate
        
        var description = "No description for this book!"
        if let desc = bookInfo["description"] as? String {
            description = desc
        }
        self.bookDescription = description
        
        var imageUrl = ""
        if let imgUrl = imageLinks["thumbnail"] {
            imageUrl = imgUrl
        }
        self.imageUrl = imageUrl
        
    }
    
    init?(entity: NSManagedObject) {
        guard let id = entity.value(forKey: Entity.Keys.Book.id.rawValue) as? String, let title = entity.value(forKey: Entity.Keys.Book.title.rawValue) as? String, let authors = entity.value(forKey: Entity.Keys.Book.authors.rawValue) as? [String], let publisher = entity.value(forKey: Entity.Keys.Book.publisher.rawValue) as? String, let publishedDate = entity.value(forKey: Entity.Keys.Book.publishedDate.rawValue) as? String, let bookDescription = entity.value(forKey: Entity.Keys.Book.bookDescription.rawValue) as? String, let imageUrl = entity.value(forKey: Entity.Keys.Book.imageUrl.rawValue) as? String else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.authors = authors
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.bookDescription = bookDescription
        self.imageUrl = imageUrl
    }
}
