//
//  APISearchUseCaseTests.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/14/25.
//

import XCTest
import RxSwift
import CoreData
@testable import BookSearchApp

class FavoriteRepositoryTests: XCTestCase {
    
    var coreDataManager: CoreDataManager?
    var favoriteRepository: FavoriteRepository!
    var disposeBag: DisposeBag!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        coreDataManager = CoreDataManager.shared
        
        guard let coreDataManager = coreDataManager else {
            XCTFail("coreDataManager 인스턴스 초기화 실패")
            return
        }
        
        // CoreData를 인메모리 저장소로 설정
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType // 인메모리 저장소 사용
        persistentStoreDescription.shouldMigrateStoreAutomatically = false // 비동기 로딩 비활성화
        
        let persistentContainer = NSPersistentContainer(name: "BookSearchApp", managedObjectModel: managedObjectModel)
        persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        
        let expectation = XCTestExpectation(description: "CoreData 로드됨")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("CoreData 로드 실패: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0) // 1초동안 대기
        
        // 컨테이너를 persistentContainer에 할당하기
        coreDataManager.persistentContainer = persistentContainer
        
        favoriteRepository = FavoriteRepositoryImpl(coreDataManager: coreDataManager)
        disposeBag = DisposeBag()
    } /// - override func setUpWithError() throws
    

    override func tearDownWithError() throws {
        
        guard let coreDataManager = coreDataManager else { return }
        // 인메모리 저장소 관리
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteBook.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            XCTFail("인메모리 저장소 정리 실패: \(error)")
        }
        
        favoriteRepository = nil
        disposeBag = nil
        self.coreDataManager = nil
        
        try super.tearDownWithError()
    } /// - override func tearDownWithError() throws
   
    
    func testSaveFavoriteBook() {
        let expectation = XCTestExpectation(description: "즐겨찾기 책 저장 테스트")
        
        let testBook = BookItemModel(
            id: UUID(),
            title: "Test Book",
            contents: "Test contents",
            url: "",
            isbn: "123456",
            authors: ["차상진"],
            publisher: "상진 출판사",
            translators: [],
            price: 20000,
            salePrice: 15000,
            thumbnail: "",
            status: "정상 판매",
            datetime: nil
        )
        guard let coreDataManager = self.coreDataManager else {
            XCTFail("CoreDataManager가 nil입니다.")
            expectation.fulfill()
            return
        }
        
        favoriteRepository.saveFavoriteBook(book: testBook)
            .subscribe(onError: { error in
                XCTFail("저장 후 로드 실패: \(error)")
            }, onCompleted: {
                coreDataManager.fetchFavoriteBooks()
                    .subscribe(onNext: { books in
                        XCTAssertTrue(
                            books.contains(where: { $0.isbn == testBook.isbn}),
                            "저장 후 책이 즐겨찾기에 있는지 확인"
                        )
                        expectation.fulfill()
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    
}
