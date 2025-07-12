//
//  BookItemView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import SwiftUI

struct BookItemView: View {
    @ObservedObject var viewModel: BookItemViewModel
    
    init(viewModel: BookItemViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        // BookItemView body 로드됨 프린트문 추가
        HStack(alignment: .center, spacing: 10) {
            bookImage(coverImageUrl: viewModel.coverURL)
            
            VStack {
                bookContents(
                    bookTitle: viewModel.title,
                    bookAuthors: viewModel.authorsText,
                    publisher: viewModel.publisher,
                    date: viewModel.publishedDateText,
                    status: viewModel.status
                )
                
                priceView(
                    originalPrice: viewModel.originalPrice,
                    salePrice: viewModel.salePrice,
                    discountPercentage: viewModel.discountPercentage,
                    isDiscounted: viewModel.isDiscounted
                )
                
            }
            .padding(7)
            
            
        }
        .padding(5)
        .background(.white)
        .cornerRadius(12)
        .frame(height: 190)
        .listRowBackground(Color.clear) // 리스트 행의 배경을 투명하게 설정
        
    }
    
    
    /// 책 표지 이미지
    /// - Parameter coverImageUrl: 이미지 표지 url
    /// - Returns: some View
    func bookImage(coverImageUrl: URL?) -> some View {
        AsyncImage(url: coverImageUrl) { phase in
            if let image = phase.image {
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
            }
        }
        .frame(width: 110, height: 180) // 높이를 명시적인 값으로 변경
        .background(.gray.opacity(0.2))
        .cornerRadius(8)
        .clipped()
    }
    
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
                Button(action: {
                    print("BookItemView: 즐겨찾기 버튼 탭됨") // 확인용 프린트문 유지
                    viewModel.toggleFavorite()
                }) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.title) // 폰트 크기 조절
                        .foregroundColor(Color.mainColor)
                }
                
            }
            
            
            Text(bookTitle)
                .jalnanFont(size: 16, color: .black)
                .lineLimit(2)
            
            Label { // Label로 아이콘 + 저자 표시
                Text(bookAuthors)
                    .jalnanFont(size: 11, color: .black)
                    .lineLimit(2) // 저자 최대 2줄까지 표시
                    .fixedSize(horizontal: false, vertical: true) // 텍스트가 줄바꿈되도록 허용
            } icon: {
                Image(systemName: "person.fill") // 사람 아이콘
                    .foregroundColor(.gray)
            }
            
            
            HStack {
                Label { // 출판사 Label 추가
                    Text(publisher)
                        .jalnanFont(size: 10, color: .gray)
                        .lineLimit(1) // 출판사는 1줄만 표시
                } icon: {
                    Image(systemName: "building.2.fill") // 출판사 아이콘
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if status != "" {
                    Text(status)
                        .jalnanFont(size: 12, color: .black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                
            }
            
            
        }
        .frame(maxHeight: .infinity)
    }
    

    
    /// 즐겨찾기 유무, 도서 판매 상태, 가격 정보 표시
    /// - Parameters:
    ///   - originalPrice: 원가격
    ///   - salePrice: 할인 가격
    ///   - discountPercentage: 할일율
    ///   - isDiscounted: 할인 유무
    ///   - status: 판매 상태
    /// - Returns: some View
    func priceView(
        originalPrice: Int,
        salePrice: Int,
        discountPercentage: String,
        isDiscounted: Bool
    ) -> some View {
        
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 7) {// 오른쪽 정렬
                // 책 가격 표시
                if !isDiscounted {
                    // 할인된 가격이 없
                    Text("\(originalPrice) ₩")
                        .jalnanFont(size: 16, color: .black, weight: .bold)
                    
                } else  if salePrice <= 0 || originalPrice <= 0 {
                    Text("가격 정보 없음")
                        .jalnanFont(size: 16, color: .black, weight: .bold)
                } else {
                    // 할인된 가격이 있을 경우
                    Text("\(originalPrice) ₩ ")
                        .jalnanFont(size: 12, color: .gray)
                        .strikethrough() // 취소선
                    
                    HStack(alignment: .bottom) {
                        Text("\(discountPercentage)%") // 할인율 표시
                            .jalnanFont(size: 12, color: .red, weight: .bold)
                        
                        Text("\(salePrice) ₩")
                            .jalnanFont(size: 18, color: .black, weight: .bold)
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}




//MARK: - Preview
#Preview {
    VStack {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            BookItemView(
                viewModel: BookItemViewModel(
                    book: BookItemModel(
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
                    ),
                    favoriteRepository: FavoriteRepositoryImpl(coreDataManager: CoreDataManager.shared)
                )
            )
        }
        
        Spacer()
    }
}

