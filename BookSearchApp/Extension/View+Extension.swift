//
//  Font+Extension.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import UIKit
import SwiftUI

struct JalnanFont: ViewModifier {
    var size: CGFloat
    var color: Color
    var weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Jalnan2", size: size))
            .foregroundColor(color)
            .fontWeight(weight)
    }
}

extension View {
    func jalnanFont(
        size: CGFloat,
        color: Color = .white,
        weight: Font.Weight = .regular
    ) -> some View {
        self.modifier(JalnanFont(size: size, color: color, weight: weight))
    }
}
