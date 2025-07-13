//
//  BookDetailView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/13/25.
//

import SwiftUI
import SafariServices

struct BookDetailView: View {
    @ObservedObject var viewModel: BookItemViewModel

    @State private var showingWebView = false
    
    init(viewModel: BookItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            GeometryReader {
                let rect = $0.frame(in: .global)
                let offset = max(0, rect.origin.y)
                let height = max(0, 300 + offset) // 300은 기본 헤더 높이

                AsyncImage(url: URL(string: viewModel.book.thumbnail ?? "")) {
                    phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: rect.width, height: height)
                            .clipped()
                            .offset(y: -offset)
                    } else if phase.error != nil {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: rect.width, height: height)
                            .foregroundColor(.gray)
                            .background(Color.gray.opacity(0.2))
                            .offset(y: -offset)
                    } else {
                        ProgressView()
                            .frame(width: rect.width, height: height)
                            .background(Color.gray.opacity(0.2))
                            .offset(y: -offset)
                    }
                } /// - AsyncImage
            } /// - GeometryReader
            .frame(height: 300) // 기본 헤더 높이

            VStack(alignment: .leading, spacing: 34) {
                
                HStack(alignment: .top) {
                    Text(viewModel.title)
                        .jalnanFont(size: 28, color: .black)
                    
                    Spacer()
                    
                    // 커스텀 즐겨찾기 버튼
                    FavoriteButton(
                        isFavorite: viewModel.isFavorite,
                        action: {
                            print("BookItemView: 즐겨찾기 버튼 탭됨")
                            viewModel.toggleFavorite() // 즐겨찾기 로직
//                            if !viewModel.isFavorite {
//                                viewModel.deleteItem(viewModel.isbn)
//                            }
                        })
                } /// - HStack
                .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    CustimLabelView(title: viewModel.authorsText, fontSize: 19, iconName: "person.fill")
                    CustimLabelView(title: viewModel.publisher, fontSize: 15, fontColor: .gray, iconName: "building.2.fill")
                    CustimLabelView(title: viewModel.translatorsText, fontSize: 15, fontColor: .gray, iconName: "translate")
                }
                
                
                HStack {
                    if viewModel.status != "" { // 상태 있을 때만
                        Text(viewModel.status)
                            .jalnanFont(size: 18, color: .black, weight: .light)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 7)
                            .overlay( // 외곽선 표시
                                RoundedRectangle(cornerRadius: 7)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    } /// - if
                    
                    Spacer()
                    
                    PriceView(
                        originalPrice: viewModel.originalPrice,
                        salePrice: viewModel.salePrice,
                        discountPercentage: viewModel.discountPercentage,
                        isDiscounted: viewModel.isDiscounted,
                        salePriceSize: 23,
                        originalPriceSize: 20
                    )
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 9) {
                    Text("책 소개")
                        .jalnanFont(size: 26, color: .black)
                    
                    Text(viewModel.contents)
                        .jalnanFont(size: 18, color: .black, weight: .light)
                    
                }
                
                Divider()
                
                
                VStack(alignment: .leading, spacing: 9) {
                    Text("책 정보")
                        .jalnanFont(size: 24, color: .black)
                    
                    CustimLabelView(title: viewModel.koreanFormattedPublishedDate, fontSize: 15, fontColor: .gray, iconName: "calendar")
                    
                    CustimLabelView(title: viewModel.isbn, fontSize: 15, fontColor: .gray, iconName: "tag.fill")
                    
                }
                
                if viewModel.searchURL != "" {
                    Button("검색 결과 보기") {
                        showingWebView = true
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $showingWebView) {
                        SafariView(url: URL(string: viewModel.searchURL)!)
                    }
                }
                
                
                
            } /// - VStack
            .padding()
        } /// - ScrollView
        .ignoresSafeArea(edges: .top)
        .navigationTitle("")
    }
    
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    BookDetailView(
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
            , deleteItem: { isbn in print(isbn)}
        )
    )
}


struct PriceView: View {
    
    let originalPrice: Int
    let salePrice: Int
    let discountPercentage: String
    let isDiscounted: Bool
    let salePriceSize: CGFloat
    let originalPriceSize: CGFloat
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 7) {// 오른쪽 정렬
            // 책 가격 표시
            if !isDiscounted { // 할인된 가격이 없을 때
                Text("\(originalPrice) ₩")
                    .jalnanFont(size: salePriceSize, color: .black, weight: .bold)
                
            } else  if salePrice <= 0 || originalPrice <= 0 {
                Text("가격 정보 없음")
                    .jalnanFont(size: salePriceSize, color: .black, weight: .bold)
            } else {
                // 할인된 가격이 있을 경우
                Text("\(originalPrice) ₩ ")
                    .jalnanFont(size: originalPriceSize, color: .gray)
                    .strikethrough() // 취소선
                
                HStack(alignment: .bottom) {
                    Text("\(discountPercentage)%") // 할인율 표시
                        .jalnanFont(size: originalPriceSize, color: .red, weight: .bold)
                    
                    Text("\(salePrice) ₩")
                        .jalnanFont(size: salePriceSize, color: .black, weight: .bold)
                } /// - HStack
            } /// - if else
        } /// - VStack
        .frame(maxHeight: .infinity)
    }
}
