//
//  BookSearchAppApp.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import SwiftUI

@main
struct BookSearchApp: App {
    init() {
        // UITabBarAppearance를 사용하여 탭바 배경색 설정
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white // 원하는 배경색으로 설정
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        // UISearchBarAppearance를 사용하여 검색창 색상 설정
        UISearchBar.appearance().tintColor = UIColor.white // 검색창 텍스트 색상 (커서, 취소 버튼 등)
        UISearchBar.appearance().searchTextField.backgroundColor = UIColor.white // 검색 텍스트 필드 배경색

    }

    var body: some Scene {
        WindowGroup {
            TabView {
                BooksListView(
                    viewModel: DIContainer.shared.makeSearchBooksListViewModel()
                )
                .tabItem {
                    Label("검색", systemImage: "magnifyingglass")
                }
                
                BooksListView(
                    viewModel: DIContainer.shared.makeFavoritesBooksListViewModel()
                )
                .tabItem {
                    Label("즐겨찾기", systemImage: "heart.fill")
                }
            }
        }
    }
}
