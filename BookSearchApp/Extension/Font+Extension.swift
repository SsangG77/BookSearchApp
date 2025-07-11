//
//  Font+Extension.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import UIKit
import SwiftUI

extension UIFont {
    static func jalnanFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Jalnan2", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}



struct JalnanFont: ViewModifier {
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content.font(.custom("Jalnan2", size: size))
    }
}

extension View {
    func jalnanFont(size: CGFloat) -> some View {
        self.modifier(JalnanFont(size: size))
    }
}
