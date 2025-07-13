//
//  BookItemView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import SwiftUI

struct BookItemView: View {
    @StateObject var viewModel: BookItemViewModel
//    var deleteItem: (_ isbn: String) -> Void
    
    init(
        viewModel: BookItemViewModel,
//        deleteItem: @escaping (_ isbn: String) -> Void
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
//        self.deleteItem = deleteItem
    }

    var body: some View {
        // BookItemView body 로드됨 프린트문 추가
        HStack(alignment: .center, spacing: 10) {
            
            // 도서 표지 이미지
            bookImage(coverImageUrl: viewModel.coverURL)
            
            VStack {
                // 제목, 저자, 출편사, 즐겨찾기 버튼, 판매 상태 표시
                bookContents(
                    bookTitle: viewModel.title,
                    bookAuthors: viewModel.authorsText,
                    publisher: viewModel.publisher,
                    date: viewModel.publishedDateText,
                    status: viewModel.status
                )
                
                // 원가, 할인가, 할인율 표시
//                priceView(
//                    originalPrice: viewModel.originalPrice,
//                    salePrice: viewModel.salePrice,
//                    discountPercentage: viewModel.discountPercentage,
//                    isDiscounted: viewModel.isDiscounted
//                )
                
                HStack {
                    Spacer()
                    
                    PriceView(
                        originalPrice: viewModel.originalPrice,
                        salePrice: viewModel.salePrice,
                        discountPercentage: viewModel.discountPercentage,
                        isDiscounted: viewModel.isDiscounted,
                        salePriceSize: 16,
                        originalPriceSize: 12
                    )
                }
            } // VStack
            .padding(7)
        } // HStack
        .padding(5)
        .background(.white)
        .cornerRadius(12)
        .frame(height: 190)
        .listRowBackground(Color.clear) // 리스트 행의 배경을 투명하게 설정
    } // ar body: some View
    
    
    /// 책 표지 이미지
    /// - Parameter coverImageUrl: 이미지 표지 url
    /// - Returns: View: 이미지뷰 반환
    func bookImage(coverImageUrl: URL?) -> some View {
        AsyncImage(url: coverImageUrl) { phase in
            if let image = phase.image {
                // 표지 이미지
                image
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(5)
            } else if phase.error != nil {
                // 에러 발생 시 플레이스홀더
                VStack {
                    Image(systemName: "book.closed.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 50)
                        .foregroundColor(.gray)
                        .cornerRadius(5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // 로딩 중
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } /// - if else
        } /// - AsyncImage
        .frame(width: 110, height: 180) // 높이를 명시적인 값으로 변경
        .background(.gray.opacity(0.2))
        .cornerRadius(8)
        .clipped()
    } /// - func bookImage(coverImageUrl: URL?) -> some View
    
    
    /// 책 정보 (제목, 작가, 출판사, 날짜 표시)
    /// - Parameters:
    ///   - bookTitle: 책 제목
    ///   - bookAuthors: 작가 문자열 배열
    ///   - publisher: 출판사
    ///   - date: 출판 날짜
    ///   - status: 도서 상태
    /// - Returns: some View
    func bookContents(
        bookTitle: String,
        bookAuthors: String,
        publisher: String,
        date: String,
        status: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("도서")
                    .jalnanFont(size: 11, color: .gray)
                
                Spacer()
                
                // 즐겨찾기 아이콘
                FavoriteButton(
                    isFavorite: viewModel.isFavorite,
                    action: {
                        print("BookItemView: 즐겨찾기 버튼 탭됨")
                        viewModel.toggleFavorite() // 즐겨찾기 로직
//                        if !viewModel.isFavorite {
//                            viewModel.deleteItem(viewModel.isbn)
//                        }
                    })
                
                
            } /// - HStack
            
            Text(bookTitle)
                .jalnanFont(size: 16, color: .black)
                .lineLimit(2) // 제목 최대 2줄까지 표시
            
            CustimLabelView(title: bookAuthors, fontSize: 11, iconName: "person.fill")
            
            
            HStack {
                CustimLabelView(title: publisher, fontSize: 10, fontColor: .gray, iconName: "building.2.fill")
                
                Spacer()
                
                // 도서 판매 상태 표시
                if status != "" { // 상태 있을 때만
                    Text(status)
                        .jalnanFont(size: 12, color: .black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .overlay( // 외곽선 표시
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                } /// - if
            } /// - HStack
        }
        .frame(maxHeight: .infinity)
    } /// - func bookContents( bookTitle: , bookAuthors: , publisher: , date: , status: ) -> some View
    

    
    /// 즐겨찾기 유무, 도서 판매 상태, 가격 정보 표시
    /// - Parameters:
    ///   - originalPrice: 원가격
    ///   - salePrice: 할인 가격
    ///   - discountPercentage: 할일율
    ///   - isDiscounted: 할인 유무
    ///   - status: 판매 상태
    /// - Returns: some View
//    func priceView(
//        originalPrice: Int,
//        salePrice: Int,
//        discountPercentage: String,
//        isDiscounted: Bool
//    ) -> some View {
//        
//        HStack {
//            Spacer()
//            VStack(alignment: .trailing, spacing: 7) {// 오른쪽 정렬
//                // 책 가격 표시
//                if !isDiscounted {
//                    // 할인된 가격이 없
//                    Text("\(originalPrice) ₩")
//                        .jalnanFont(size: 16, color: .black, weight: .bold)
//                    
//                } else  if salePrice <= 0 || originalPrice <= 0 {
//                    Text("가격 정보 없음")
//                        .jalnanFont(size: 16, color: .black, weight: .bold)
//                } else {
//                    // 할인된 가격이 있을 경우
//                    Text("\(originalPrice) ₩ ")
//                        .jalnanFont(size: 12, color: .gray)
//                        .strikethrough() // 취소선
//                    
//                    HStack(alignment: .bottom) {
//                        Text("\(discountPercentage)%") // 할인율 표시
//                            .jalnanFont(size: 12, color: .red, weight: .bold)
//                        
//                        Text("\(salePrice) ₩")
//                            .jalnanFont(size: 18, color: .black, weight: .bold)
//                    } /// - HStack
//                } /// - if else
//            } /// - VStack
//            .frame(maxHeight: .infinity)
//        } /// - HStack
//    } /// - func priceView(originalPrice: ,salePrice: ,discountPercentage: ,isDiscounted: ) -> some View
} /// - struct BookItemView: View




//MARK: - Preview
#Preview {
    
    let book = BookItemModel(
        title: "미움받을 용기",
        contents: "test",
        url: "https://search.daum.net/search?w=bookpage&bookId=1467038&q=%EB%AF%B8%EC%9B%80%EB%B0%9B%EC%9D%84+%EC%9A%A9%EA%B8%B0",
        isbn: "8996991341 9788996991342",
        authors: ["기시미 이치로", "고가 후미타케"],
        publisher: "인플루엔셜",
        translators:["전경아"],
        price: 19000,
        salePrice: 12000,
        thumbnail: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038",
        status: "정상판매",
        datetime: Date()
    )
    
    let bookItemViewModel = BookItemViewModel(
        book: book,
        favoriteRepository: FavoriteRepositoryImpl(coreDataManager: CoreDataManager.shared)
        , deleteItem: {isbn in print("isbn")}
    )
    
    VStack {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            BookItemView(viewModel: bookItemViewModel)
        }
        
        Spacer()
    }
}

