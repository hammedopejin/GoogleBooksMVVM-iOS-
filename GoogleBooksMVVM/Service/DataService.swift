//
//  DataService.swift
//  GoogleBooksMVVM
//
//  Created by Hammed opejin on 5/17/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit
import CoreData

let dataService = DataService.sharedInstance
final class DataService {
    
    static let sharedInstance = DataService()
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = { 
        let container = NSPersistentContainer(name: Entity.Constant.GoogleBooksMVVM.rawValue)
        container.loadPersistentStores(completionHandler: { (persistentStoreDescription, err) in
            
            if let error = err {
                fatalError("Couldn't Load Persistence Store!")
            }
            
        })
        return container
    }()
    
    
    func saveBook(_ book: Book) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: Entity.Keys.Book.CoreBook.rawValue, in: context) else {
            return
        }
        
        let coreBook = NSManagedObject(entity: entity, insertInto: context)
        coreBook.setValue(book.id, forKey: Entity.Keys.Book.id.rawValue)
        coreBook.setValue(book.title, forKey: Entity.Keys.Book.title.rawValue)
        coreBook.setValue(book.authors, forKey: Entity.Keys.Book.authors.rawValue)
        coreBook.setValue(book.publisher, forKey: Entity.Keys.Book.publisher.rawValue)
        coreBook.setValue(book.publishedDate, forKey: Entity.Keys.Book.publishedDate.rawValue)
        coreBook.setValue(book.bookDescription, forKey: Entity.Keys.Book.bookDescription.rawValue)
        coreBook.setValue(book.imageUrl, forKey: Entity.Keys.Book.imageUrl.rawValue)
        
        print("Saved Book: \(book.title)")
        saveContext()
        
    }
    
    func getBooks() -> [Book] {
        
        let fetchRequest = NSFetchRequest<CoreBook>(entityName: Entity.Keys.Book.CoreBook.rawValue)
        var books = [Book]()
        
        do{
            let coreBooks = try context.fetch(fetchRequest)
            for book in coreBooks {
                books.append(Book(entity: book)!)
            }
            
            return books
            
        } catch {
            print("Couldn't Fetch Objects: \(error.localizedDescription)")
            return []
        }

    }
    
    func deleteBook(_ book: Book) {
        
        let fetchRequest = NSFetchRequest<CoreBook>(entityName: Entity.Keys.Book.CoreBook.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id = %@", book.id)
        do {
            let bookData = try context.fetch(fetchRequest)
            let toDeleteBook = bookData[0] as NSManagedObject
            context.delete(toDeleteBook)
            saveContext()
            print("Deleted Book: \(book.title) from Favorite")
        } catch {
            print("Error Deleting Book: \(error.localizedDescription)")
        }
        
    }
    
    private func saveContext() {
        
        do {
            try context.save()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
}
