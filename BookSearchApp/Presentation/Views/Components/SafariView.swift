//
//  SafariView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/15/25.
//

import SwiftUI
import SafariServices

//MARK: - 상세페이지에서 도서 정보 검색 결과 보여주는 Safari 뷰
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
