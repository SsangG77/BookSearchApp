//
//  SortOptionsSectionView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import SwiftUI

struct SortOptionsSectionView: View {
    @ObservedObject var viewModel: BooksListViewModel
    @Binding var showingSortOptions: Bool
    let searchText: String

    var body: some View {
        VStack(spacing: 8) {
            sortHeaderSection

            if showingSortOptions {
                sortDropdownSection
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showingSortOptions)
    }

    private var sortHeaderSection: some View {
        HStack {
            Spacer()
            sortButton
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var sortButton: some View {
        Button {
            withAnimation { showingSortOptions.toggle() }
        } label: {
            HStack(spacing: 4) {
                Text(viewModel.currentSortOption.displayName)
                    .jalnanFont(size: 14)
                    .foregroundColor(.white)

                Image(systemName: showingSortOptions ? "chevron.up" : "chevron.down")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        }
    }

    private var sortDropdownSection: some View {
        VStack(spacing: 4) {
            ForEach(viewModel.availableSortOptions, id: \.self) { option in
                Button {
                    viewModel.currentSortOption = option
                    viewModel.loadBooks(searchText: searchText)
                    showingSortOptions = false
                } label: {
                    HStack {
                        Text(option.displayName)
                            .font(.system(size: 14))
                            .foregroundColor(.white)

                        Spacer()

                        if viewModel.currentSortOption == option {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(6)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}
