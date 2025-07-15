//
//  NetworkError.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation

//MARK: - API 에러 별 유형
enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case apiError(String)
}
