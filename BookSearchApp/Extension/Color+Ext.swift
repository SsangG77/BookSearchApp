//
//  Color+Extension.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import SwiftUI

extension Color {
    
    /// Hex String을 받아 SwiftUI의 Color를 반환합니다.
    /// - Parameter hex: #RRGGBB 또는 RRGGBB 형식의 Hex String
    /// - Returns: 변환된 Color 객체
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // # 접두사 건너뛰기

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
    
    
    static var mainColor: Color {
        return Color(hex: "#F94239")
    }
}
