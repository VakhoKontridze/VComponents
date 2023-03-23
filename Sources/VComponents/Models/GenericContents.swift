//
//  GenericContents.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.07.22.
//

import SwiftUI

// MARK: - Generic Content (Empty, Content)
enum GenericContent_EmptyContent<Content> where Content: View {
    case empty
    case content(content: () -> Content)
}

// MARK: - Generic Content (Title, Content)
enum GenericContent_TitleContent<Content> where Content: View {
    case title(title: String)
    case content(content: () -> Content)
}

// MARK: - Generic Content (Empty, Title, Content)
enum GenericContent_EmptyTitleContent<Content>: Equatable where Content: View {
    case empty
    case title(title: String)
    case content(content: () -> Content)
    
    var hasLabel: Bool {
        switch self {
        case .empty: return false
        case .title: return true
        case .content: return true
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case (.title(let lhs), .title(let rhs)): return lhs == rhs
        default: return false
        }
    }
}

// MARK: - Generic Content (Title, Icon, Content)
enum GenericContent_TitleIconContent<Content> where Content: View {
    case title(title: String)
    case icon(icon: Image)
    case content(content: () -> Content)
}

// MARK: - Generic Content (Title, Icon Title, Content)
enum GenericContent_TitleIconTitleContent<Content> where Content: View {
    case title(title: String)
    case iconTitle(icon: Image, title: String)
    case content(content: () -> Content)
}

// MARK: - Generic Content (Title, Icon, Icon Title, Content)
enum GenericContent_TitleIconIconTitleContent<Content> where Content: View {
    case title(title: String)
    case icon(icon: Image)
    case iconTitle(icon: Image, title: String)
    case content(content: () -> Content)
}

// MARK: - Generic Content (Titles, DataSourced Content)
enum GenericContent_TitlesDataSourcedContent<Data, Content>
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        Content: View
{
    // MARK: Properties
    case titles(titles: [String])
    case content(data: Data, content: (Data.Element) -> Content)
    
    // MARK: Properties
    var count: Int {
        switch self {
        case .titles(let titles): return titles.count
        case .content(let data, _): return data.count
        }
    }
}
