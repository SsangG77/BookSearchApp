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

        // CoreData를 인메모리 저장소로 설정
        guard let modelURL = Bundle(identifier: "com.sangjin.BookSearchApp")?.url(forResource: "BookSearchApp", withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            XCTFail("Failed to load managed object model from main app bundle.")
            return
        } // 메인 번들에서 모델 로드
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType // 인메모리 저장소 사용
        persistentStoreDescription.shouldMigrateStoreAutomatically = true // 자동 마이그레이션 활성화
        persistentStoreDescription.shouldInferMappingModelAutomatically = true // 자동 매핑 모델 추론 활성화

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

        // 테스트 전용 CoreDataManager 인스턴스 생성
        coreDataManager = CoreDataManager(container: persistentContainer)

        guard let coreDataManager = coreDataManager else {
            XCTFail("coreDataManager 인스턴스 초기화 실패")
            return
        }

        favoriteRepository = FavoriteRepositoryImpl(coreDataManager: coreDataManager)
        disposeBag = DisposeBag()
    }
    

    override func tearDownWithError() throws {
        
        guard let coreDataManager = coreDataManager else { return }
        let context = coreDataManager.persistentContainer.viewContext

        // 인메모리 저장소 정리: NSBatchDeleteRequest 대신 컨텍스트 리셋
        context.rollback() // 보류 중인 변경 사항 롤백
        context.reset() // 컨텍스트의 모든 객체 지우기
        
        favoriteRepository = nil
        disposeBag = nil
        self.coreDataManager = nil
        
        try super.tearDownWithError()
    }
   
    
    // 즐겨찾기 저장 테스트
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
            .flatMap { _ in
                return coreDataManager.fetchFavoriteBooks()
            }
            .subscribe(onNext: { books in
                XCTAssertTrue(
                    books.contains(where: { $0.isbn == testBook.isbn}),
                    "저장 후 책이 즐겨찾기에 있는지 확인"
                )
                expectation.fulfill()
            }, onError: { error in
                XCTFail("저장 또는 로드 실패: \(error)")
            })
            .disposed(by: self.disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
}
