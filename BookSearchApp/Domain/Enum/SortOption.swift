//
//  SortOption.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation

/// 정렬 옵션 열거형
enum SortOption: String, CaseIterable {
    // API
    case accuracy = "정확도순"
    case latest = "발간일순"
    
    // Local
    case titleAsc = "제목 오름차순"
    case titleDesc = "제목 내림차순"
    case priceFilter = "금액 필터 (15000원 이상)"
    
    var queryValue: String {
        switch self {
        case .accuracy: return "accuracy"
        case .latest: return "latest"
        default: return "" // 로컬 정렬은 queryValue 사용 안함
        }
    }
    
    var displayName: String {
        return self.rawValue
    }
}

