//
//  BooksListView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import SwiftUI
import RxSwift
import RxCocoa

// MARK: - Domain Layer (Use Case Protocol)
protocol FetchBooksUseCase {
    func execute(page: Int) -> Observable<[BookItemModel]>
}

// MARK: - Domain Layer (Use Case Implementation)
class FetchBooksUseCaseImpl: FetchBooksUseCase {
    private let repository: BookRepository

    init(repository: BookRepository) {
        self.repository = repository
    }

    func execute(page: Int) -> Observable<[BookItemModel]> {
        return repository.fetchBooks(page: page)
    }
}

// MARK: - BooksListViewModel (프레젠테이션 계층)
class BooksListViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    let bookItemViewModelsSubject = BehaviorRelay<[BookItemViewModel]>(value: [])
    private let fetchBooksUseCase: FetchBooksUseCase

    var bookItemViewModels: Observable<[BookItemViewModel]> {
        return bookItemViewModelsSubject.asObservable()
    }

    init(fetchBooksUseCase: FetchBooksUseCase) {
        self.fetchBooksUseCase = fetchBooksUseCase
    }

    func loadBooks(searchText: String = "", page: Int = 1) {
        fetchBooksUseCase.execute(page: page) // page 매개변수 전달
            .map { bookModels in
                bookModels.map(BookItemViewModel.init)
            }
            .map { viewModels in
                if searchText.isEmpty {
                    return viewModels
                } else {
                    return viewModels.filter { bookViewModel in
                        bookViewModel.title.localizedCaseInsensitiveContains(searchText) ||
                        bookViewModel.authorsText.localizedCaseInsensitiveContains(searchText) ||
                        bookViewModel.publisher.localizedCaseInsensitiveContains(searchText)
                    }
                }
            }
            .subscribe(onNext: { [weak self] viewModels in
                self?.bookItemViewModelsSubject.accept(viewModels)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - BooksListView (프레젠테이션 계층)
struct BooksListView: View {
    @StateObject var viewModel: BooksListViewModel // StateObject로 뷰 모델 주입
    @State private var displayedBooks: [BookItemViewModel] = []
    @State private var searchText: String = "" // 검색 텍스트 추가
    private let disposeBag = DisposeBag()

    init(viewModel: BooksListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        
    }
    

    var body: some View {
        NavigationView { // NavigationView로 감쌉니다.
            List {
                ForEach(displayedBooks, id: \.id) { bookItemViewModel in
                    BookItemView(viewModel: bookItemViewModel)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear) // 배경도 투명하게
                    
                }
            }
            .listStyle(.plain)
            .background(Color.mainColor) // 리스트 배경색 설정
            .padding(.top, -70) // 검색창과의 간격 조절 (예시 값)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("검색")
                        .jalnanFont(size: 18)
                        .foregroundColor(.white)
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onSubmit(of: .search) { // 검색 버튼 눌렀을 때
                viewModel.loadBooks(searchText: searchText)
            }
            .onAppear {
                viewModel.bookItemViewModels
                    .subscribe(onNext: { viewModels in
                        self.displayedBooks = viewModels
                    })
                    .disposed(by: disposeBag)
                // 초기 로드는 더 이상 여기서 하지 않습니다.
            }
        }
        
    }

}


//MARK: - Preview
#Preview {
    let booksListViewModel = DIContainer.shared.makeBooksListViewModel()

    NavigationView {
        BooksListView(viewModel: booksListViewModel)
    }
}


