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
    
    let persistentContainer: NSPersistentContainer
    
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "BookSearchApp")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
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
            favoriteBook.id = book.id.uuidString
            favoriteBook.isbn = book.isbn
            favoriteBook.title = book.title
            favoriteBook.authors = book.authors.joined(separator: ", ")
            favoriteBook.publisher = book.publisher ?? ""
            favoriteBook.thumbnail = book.thumbnail ?? ""
            favoriteBook.price = Int32(book.price ?? 0)
            favoriteBook.salePrice = Int32(book.salePrice ?? 0)
            favoriteBook.status = book.status ?? ""
            favoriteBook.datetime = book.datetime ?? Date()
            favoriteBook.contents = book.contents ?? ""
            favoriteBook.url = book.url ?? ""
            favoriteBook.translators = book.translators.joined(separator: ", ")
            
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
        return Observable.create { observer in
            print("CoreDataManager.fetchFavoriteBooks(): Observable.create 클로저 시작")
            let context = self.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<FavoriteBook> = FavoriteBook.fetchRequest()
            
            do {
                print("CoreDataManager.fetchFavoriteBooks(): do 블록 진입")
                let favoriteBooks = try context.fetch(fetchRequest)
                print("CoreDataManager.fetchFavoriteBooks(): Core Data에서 가져온 즐겨찾기 책: \(favoriteBooks.count)개")
                for book in favoriteBooks {
                    print("  - \(book.title ?? "제목 없음") (ISBN: \(book.isbn ?? "없음"))")
                }
                let bookItemModels = favoriteBooks.map { book -> BookItemModel in
                    return BookItemModel(
                        id: UUID(uuidString: book.id ?? "") ?? UUID(),
                        title: book.title ?? "",
                        contents: book.contents,
                        url: book.url,
                        isbn: book.isbn ?? "",
                        authors: book.authors?.components(separatedBy: ", ") ?? [],
                        publisher: book.publisher,
                        translators: book.translators?.components(separatedBy: ", ") ?? [],
                        price: Int(book.price),
                        salePrice: Int(book.salePrice),
                        thumbnail: book.thumbnail,
                        status: book.status,
                        datetime: book.datetime
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
            let fetchRequest: NSFetchRequest<FavoriteBook> = FavoriteBook.fetchRequest()
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
        let fetchRequest: NSFetchRequest<FavoriteBook> = FavoriteBook.fetchRequest()
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
