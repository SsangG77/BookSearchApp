//
//  Font+Extension.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import UIKit
import SwiftUI

//MARK: - View Extension
extension View {
    
    // 여기어떄 서체 적용 modifier
    func jalnanFont(
        size: CGFloat,
        color: Color = .white,
        weight: Font.Weight = .regular
    ) -> some View {
        self
            .font(.custom("Jalnan2", size: size))
            .foregroundColor(color)
            .fontWeight(weight)
    }
    
    
    // 리스트뷰 하단 요소(로딩중, "마지막 페이지 입니다.")에 적용하는 커스텀 modifier
    func listBottomEffect() -> some View {
       self
           .frame(width: UIScreen.main.bounds.width)
           .padding()
           .background(Color.mainColor)
           .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
           .listRowSeparator(.hidden)
   }
}
