//
//  CoreDataManager.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import CoreData
import RxSwift
import SwiftUI

class CoreDataManager {
    static let shared = CoreDataManager()
    
    var persistentContainer: NSPersistentContainer
    
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "BookSearchApp")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("CoreData load error: \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveFavoriteBook(book: BookItemModel) -> Observable<Void> {
        print("CoreDataManager.saveFavoriteBook()", book.title)
        return Observable.create { observer in
            let context = self.persistentContainer.viewContext
            
            // 중복 저장 방지
            if self.isBookFavorite(isbn: book.isbn) {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let favoriteBook = FavoriteBook(context: context)
            favoriteBook.setValue(book.id.uuidString, forKey: "id")
            favoriteBook.setValue(book.isbn, forKey: "isbn")
            favoriteBook.setValue(book.title, forKey: "title")
            favoriteBook.setValue(book.authors.joined(separator: ", "), forKey: "authors")
            favoriteBook.setValue(book.publisher ?? "", forKey: "publisher")
            favoriteBook.setValue(book.thumbnail ?? "", forKey: "thumbnail")
            favoriteBook.setValue(Int32(book.price ?? 0), forKey: "price")
            favoriteBook.setValue(Int32(book.salePrice ?? 0), forKey: "salePrice")
            favoriteBook.setValue(book.status ?? "", forKey: "status")
            favoriteBook.setValue(book.datetime ?? Date(), forKey: "datetime")
            favoriteBook.setValue(book.contents ?? "", forKey: "contents")
            favoriteBook.setValue(book.url ?? "", forKey: "url")
            favoriteBook.setValue(book.translators.joined(separator: ", "), forKey: "translators")
            
            do {
                try context.save()
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
            
        }
    }
    
    func fetchFavoriteBooks() -> Observable<[BookItemModel]> {
        print("CoreDataManager.fetchFavoriteBooks() 호출 시작")
        return Observable.create { observer in
            print("CoreDataManager.fetchFavoriteBooks(): Observable.create 클로저 시작")
            let context = self.persistentContainer.viewContext
//            let fetchRequest: NSFetchRequest<FavoriteBook> = FavoriteBook.fetchRequest()
            let fetchRequest: NSFetchRequest<FavoriteBook> = NSFetchRequest<FavoriteBook>(entityName: "FavoriteBook")
            
            do {
                print("CoreDataManager.fetchFavoriteBooks(): do 블록 진입 - fetchRequest 실행 전")
                let favoriteBooks = try context.fetch(fetchRequest)
                print("CoreDataManager.fetchFavoriteBooks(): Core Data에서 가져온 즐겨찾기 책: \(favoriteBooks.count)개")
                for book in favoriteBooks {
                    print("  - \(book.value(forKey: "title") as? String ?? "제목 없음") (ISBN: \(book.value(forKey: "isbn") as? String ?? "없음"))")
                }
                let bookItemModels = favoriteBooks.map { book -> BookItemModel in
                    return BookItemModel(
                        id: UUID(uuidString: book.value(forKey: "id") as? String ?? "") ?? UUID(),
                        title: book.value(forKey: "title") as? String ?? "",
                        contents: book.value(forKey: "contents") as? String,
                        url: book.value(forKey: "url") as? String,
                        isbn: book.value(forKey: "isbn") as? String ?? "",
                        authors: (book.value(forKey: "authors") as? String)?.components(separatedBy: ", ") ?? [],
                        publisher: book.value(forKey: "publisher") as? String,
                        translators: (book.value(forKey: "translators") as? String)?.components(separatedBy: ", ") ?? [],
                        price: Int(book.value(forKey: "price") as? Int32 ?? 0),
                        salePrice: Int(book.value(forKey: "salePrice") as? Int32 ?? 0),
                        thumbnail: book.value(forKey: "thumbnail") as? String,
                        status: book.value(forKey: "status") as? String,
                        datetime: book.value(forKey: "datetime") as? Date
                    )
                }
                observer.onNext(bookItemModels)
                observer.onCompleted()
            } catch {
                print(#function, error)
                observer.onError(error)
            }
            return Disposables.create()
            
        }
    }
    
    func deleteFavoriteBook(isbn: String) -> Observable<Void> {
        return Observable.create { observer in
            let context = self.persistentContainer.viewContext
//            let fetchRequest: NSFetchRequest<FavoriteBook> = FavoriteBook.fetchRequest()
            let fetchRequest: NSFetchRequest<FavoriteBook> = NSFetchRequest<FavoriteBook>(entityName: "FavoriteBook")
            fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if let bookToDelete = results.first {
                    context.delete(bookToDelete)
                    try context.save()
                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    observer.onCompleted()
                }
            } catch {
                print(#function, error)
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    
    func isBookFavorite(isbn: String) -> Bool {
        let context = self.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<FavoriteBook> = FavoriteBook.fetchRequest()
        let fetchRequest: NSFetchRequest<FavoriteBook> = NSFetchRequest<FavoriteBook>(entityName: "FavoriteBook")
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        fetchRequest.fetchLimit = 1
        do {
            let favoriteBooks = try context.fetch(fetchRequest)
            return !favoriteBooks.isEmpty
        } catch {
            return false
        }
    }
    
    
}
