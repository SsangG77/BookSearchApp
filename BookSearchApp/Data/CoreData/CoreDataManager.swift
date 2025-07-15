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

//MARK: - CoreData 관리 객체
/// - 데이터 로드, 저장, 삭제, 즐겨찾기 유무 확인 로직 수행
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

    // 테스트 코드용 생성자
    internal init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }
    
    
    //MARK: - 도서를 coreData에 저장하는 함수
    /// - Parameter book: 저장할 도서 모델
    /// - Returns: Observable<Void> 방출하여 저장 상태 알림
    func saveFavoriteBook(book: BookItemModel) -> Observable<Void> {
        print("CoreDataManager.saveFavoriteBook()", book.title)
        return Observable.create { observer in
            let context = self.persistentContainer.viewContext
            
            // 중복 저장 방지
            if self.isBookFavorite(isbn: book.isbn) {
                observer.onCompleted()
                return Disposables.create()
            }
            
            // coreData 저장 모델에 도서 모델 값들 할당
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
                // 저장
                try context.save()
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    
    //MARK: - coreData에 저장된(즐겨찾기된) 모든 책들을 조회
    /// - Returns: 저장된 도서 목록을 Observable로 방출
    func fetchFavoriteBooks() -> Observable<[BookItemModel]> {
        return Observable.create { observer in
            print("CoreDataManager.fetchFavoriteBooks(): Observable.create 클로저 시작")
            let context = self.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<FavoriteBook> = NSFetchRequest<FavoriteBook>(entityName: "FavoriteBook")
            
            do {
                print("CoreDataManager.fetchFavoriteBooks(): do 블록 진입 - fetchRequest 실행 전")
                let favoriteBooks = try context.fetch(fetchRequest)
                print("CoreDataManager.fetchFavoriteBooks(): Core Data에서 가져온 즐겨찾기 책: \(favoriteBooks.count)개")
                
                // coreData에서 가져온 책들을 `[BookItemModel]`로 파싱 처리
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
                
                // 옵저버로 도서 배열 방출
                observer.onNext(bookItemModels)
                observer.onCompleted()
            } catch {
                print(#function, error)
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    //MARK: - 도서 isbn으로 CoreData에서 삭제
    /// - Parameter isbn: 삭제하고자 하는 도서의 isbn
    /// - Returns: 옵저버 방출
    func deleteFavoriteBook(isbn: String) -> Observable<Void> {
        return Observable.create { observer in
            let context = self.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<FavoriteBook> = NSFetchRequest<FavoriteBook>(entityName: "FavoriteBook")
            
            // isbn 값이 일치하는 도서 가져오기
            fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
            
            do {
                // 조회된 도서 배열 변수에 할당
                let results = try context.fetch(fetchRequest)
                
                // 도서 배열의 첫번째 아이템을 삭제 처리
                if let bookToDelete = results.first {
                    context.delete(bookToDelete) // 삭제
                    try context.save() // 저장
                    observer.onNext(()) // 옵저버 방출
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
    
    
    //MARK: - 도서의 isbn으로 즐겨찾기가 되어있는지 판단
    /// - Parameter isbn: 확인할 도서의 isbn 값
    /// - Returns: Bool
    func isBookFavorite(isbn: String) -> Bool {
        let context = self.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteBook> = NSFetchRequest<FavoriteBook>(entityName: "FavoriteBook")
        
        // 매개변수 isbn과 일치하는 조건 등록
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        fetchRequest.fetchLimit = 1 // 최대 1개까지
        do {
            // 조건과 일치하는 도서 조회
            let favoriteBooks = try context.fetch(fetchRequest)
            return !favoriteBooks.isEmpty
        } catch {
            return false
        }
    }
    
    //MARK: - 즐겨찾기된 도서가 있는지 확인
    /// - Returns: 즐겨찾기된 도서가 하나라도 있으면 true, 없으면 false
    func hasFavoriteBooks() -> Bool {
        let context = self.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteBook> = NSFetchRequest<FavoriteBook>(entityName: "FavoriteBook")
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking for favorite books: \(error)")
            return false
        }
    }
}
    
    

