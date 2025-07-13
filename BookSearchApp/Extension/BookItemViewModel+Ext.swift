//
//  BookItemViewModel+Ext.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/13/25.
//

import Foundation

extension BookItemViewModel: Equatable {
    static func == (lhs: BookItemViewModel, rhs: BookItemViewModel) -> Bool {
        return lhs.book.id == rhs.book.id
    }
}
