//
//  BookItemView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import SwiftUI

struct BookItemView: View {
    let viewModel: BookItemViewModel
    
    init(viewModel: BookItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            bookImage(coverImageUrl: viewModel.coverURL)
            bookContents(
                bookTitle: viewModel.title,
                bookAuthors: viewModel.authorsText,
                publisher: viewModel.publisher,
                date: viewModel.publishedDateText
            )
            Spacer()
            favoriteAndPriceView(
                originalPrice: viewModel.originalPrice,
                salePrice: viewModel.salePrice,
                discountPercentage: viewModel.discountPercentage,
                isDiscounted: viewModel.isDiscounted,
                status: viewModel.status
            )
        }
        .padding(5)
        .background(.white)
        .cornerRadius(12)
        .frame(height: 180)
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
        .frame(width: 100, height: .infinity)
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
    /// - Returns: some View
    func bookContents(
        bookTitle: String,
        bookAuthors: String,
        publisher: String,
        date: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text("도서")
                .foregroundColor(.gray)
                .jalnanFont(size: 11)
            
            Text(bookTitle)
                .jalnanFont(size: 17)
                .lineLimit(2)
            
            Label { // Label로 아이콘 + 저자 표시
                Text(bookAuthors)
                    .jalnanFont(size: 12)
                    .foregroundColor(.gray)
                    .lineLimit(2) // 저자 최대 2줄까지 표시
                    .fixedSize(horizontal: false, vertical: true) // 텍스트가 수평 공간에 맞춰 자연스럽게 줄바꿈되도록 허용
            } icon: {
                Image(systemName: "person.fill") // 저자(사람) 아이콘
                    .foregroundColor(.gray)
            }
            
            Label { // 출판사 Label 추가
                Text(publisher)
                    .jalnanFont(size: 12)
                    .foregroundColor(.gray)
                    .lineLimit(1) // 출판사는 1줄만 표시
            } icon: {
                Image(systemName: "building.2.fill") // 출판사 아이콘
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 5)
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
    func favoriteAndPriceView(
        originalPrice: Int,
        salePrice: Int,
        discountPercentage: String,
        isDiscounted: Bool,
        status: String
    ) -> some View {
        VStack(alignment: .trailing, spacing: 7) {// 오른쪽 정렬
            
            // 즐겨찾기 아이콘
            Button(action: {
                // 즐겨찾기 토글 액션 (여기에 실제 로직 추가)
                print(viewModel.title)
            }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.yellow)
            }
            
            Spacer() // 가격을 아래로 밀기
            
            Text(status)
                .foregroundColor(.gray)
                .jalnanFont(size: 15)
            
            Divider()
            
            
            // 책 가격 표시
            if isDiscounted { //할인됨 유무 확인
                // 할인된 가격이 있을 경우 분기 처리
                
                Text("\(originalPrice) ₩ ")
                    .jalnanFont(size: 11)
                    .foregroundColor(.gray)
                    .strikethrough() // 취소선
                
                Text("\(salePrice) ₩")
                    .jalnanFont(size: 16)
                    .fontWeight(.bold)
                    
                Text("\(discountPercentage)%") // 할인율 표시
                    .jalnanFont(size: 14)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            } else {
                // 할인된 가격이 없을 경우
                Text("\(originalPrice) ₩")
                    .jalnanFont(size: 16)
                    .fontWeight(.bold)
            }
        }
        .padding(9)
        .frame(maxHeight: .infinity)
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
                    isbn: "8996991341 9788996991342",
                    coverURL: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038",
                    title: "미움받을 용기",
                    authors: ["기시미 이치로", "고가 후미타케"],
                    publisher: "인플루엔셜",
                    date: Date(),
                    status: "절판",
                    price: 19000,
                    salePrice: 12000
                ))
            )
        }
        
        Spacer()
    }
}

