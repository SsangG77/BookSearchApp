//
//  PriceView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/15/25.
//

import SwiftUI

struct PriceView: View {
    let originalPrice: Int          // 원 가격
    let salePrice: Int              // 할인 가격
    let discountPercentage: String  // 할인율
    let isDiscounted: Bool          // 할인 유무
    let salePriceSize: CGFloat      // 할인 가격 텍스트 크기
    let originalPriceSize: CGFloat  // 원 가격 텍스트 크기
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 7) { // 오른쪽 정렬
            // 책 가격 표시
            if !isDiscounted { // 할인된 가격이 없을 때
                Text("\(originalPrice) ₩")
                    .jalnanFont(size: salePriceSize, color: .black, weight: .bold)
                
            } else  if salePrice <= 0 || originalPrice <= 0 { // API를 통해 가격이 -1인 경우가 있어서 그럴 경우 "가격 정보 없음"으로 표시
                Text("가격 정보 없음")
                    .jalnanFont(size: salePriceSize, color: .black, weight: .bold)
            } else { // 할인된 가격이 있을 경우
                Text("\(originalPrice) ₩ ")
                    .jalnanFont(size: originalPriceSize, color: .gray)
                    .strikethrough() // 취소선
                
                HStack(alignment: .bottom) {
                    Text("\(discountPercentage)%") // 할인율 표시
                        .jalnanFont(size: originalPriceSize, color: .red, weight: .bold)
                    
                    Text("\(salePrice) ₩")
                        .jalnanFont(size: salePriceSize, color: .black, weight: .bold)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}
