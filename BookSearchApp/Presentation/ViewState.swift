//
//  ViewState.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/13/25.
//

import Foundation

// 뷰 상태관리 enum
enum ViewState: Equatable {
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.empty, .empty):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
    
    case idle
    case loading
    case loaded
    case error(String)
    case empty
}
