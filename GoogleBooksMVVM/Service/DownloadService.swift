//
//  DownloadService.swift
//  GoogleBooksMVVM
//
//  Created by Hammed opejin on 5/17/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

typealias bookHandler = ([Book]?) -> Void
typealias imageHandler = (UIImage?) -> Void
let downloadService = DownloadService.shared

final class DownloadService {
    
    private init(){}
    static let shared = DownloadService()
    let cache = NSCache<NSString, UIImage>()
    
    func downloadImage(url: String, completion: @escaping imageHandler) {
        
        if let image = cache.object(forKey: url as NSString) {
            completion(image)
            return
        }
        
        guard let imageUrl = URL(string: url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { [unowned self] (data, _, err) in
            
            if let error = err {
                print("Couldn't retrieve data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            
            if let data = data {
                
                guard let image = UIImage(data: data) else{
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                self.cache.setObject(image, forKey: url as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
                
            }
        }.resume()
        
    }
    
    func getBooks(searchTerm: String, vc: UIViewController, completion: @escaping bookHandler) {
        let endpoint = "https://www.googleapis.com/books/v1/volumes?q=\(searchTerm)"
        let escapedEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: escapedEndpoint!) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            if let error = err {
                print(error)
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    if let jsonObjectCount = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let bookCount = jsonObjectCount["totalItems"] as? Int {
                        if bookCount == 0 {
                            print("No Results")
                            DispatchQueue.main.async {
                                vc.showAlert(title: "No Result!", message: "No book match the search criteria you entered, please try another search term")
                                completion(nil)
                            }
                        }
                    }
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let bookArray = jsonObject["items"] as? [[String: Any]] else {
                        print("Bad Json Format Error!")
                        return
                    }
                    
                    var books = [Book]()
                    for book in bookArray {
                        if let book = try Book(json: book) {
                            books.append(book)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        print("Books count: \(books.count)")
                        if !books.isEmpty {
                            completion(books)
                        }
                    }
                    
                } catch {
                    
                    print(data.debugDescription)
                    print("Couldn't Serialize Object: \(error.localizedDescription)")
                }
            }
            }.resume()
    }
  
}
