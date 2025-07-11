//
//  BookItemModel.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import Foundation

struct BookItemModel: Identifiable, Codable {
    var id = UUID()
    let isbn: String?
    let coverURL: String
    let title: String
    let authors: [String]
    let publisher: String
    let date: Date
    let status: String
    let price: Int
    let salePrice: Int
}



struct DetailBookItemModel: Codable {
    
}
