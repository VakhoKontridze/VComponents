//
//  VStaticList.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.06.22.
//

import SwiftUI
import VCore

// MARK: - V Static List
/// Fixed container that presents rows of data arranged in a single column.
///
///     ScrollView(.vertical, showsIndicators: true, content: {
///         Text("First")
///             .frame(maxWidth: .infinity, alignment: .leading)
///             .padding(.top, 20)
///
///         VStaticList(data: 0..<5, id: \.self, content: {
///             Text(String($0))
///                 .frame(maxWidth: .infinity, alignment: .leading)
///         })
///
///         Text("Second")
///             .frame(maxWidth: .infinity, alignment: .leading)
///             .padding(.top, 20)
///
///         VStaticList(data: 0..<5, id: \.self, content: {
///             Text(String($0))
///                 .frame(maxWidth: .infinity, alignment: .leading)
///         })
///     })
///         .padding()
///
public struct VStaticList<Data, ID, Content>: View
    where
        Data: RandomAccessCollection,
        Data.Element: Hashable,
        ID: Hashable,
        Content: View
{
    // MARK: Properties
    private let uiModel: VStaticListUIModel
    
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content
    
    private var hasSeparator: Bool { uiModel.layout.separatorHeight > 0 }
    
    // MARK: Initializers
    /// Initializes component with data, id, and row content.
    public init(
        uiModel: VStaticListUIModel = .init(),
        data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.uiModel = uiModel
        self.data = data
        self.id = id
        self.content = content
    }
    
    /// Initializes component with data and row content.
    public init(
        uiModel: VStaticListUIModel = .init(),
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where
            Data.Element: Identifiable,
            ID == Data.Element.ID
    {
        self.uiModel = uiModel
        self.data = data
        self.id = \.id
        self.content = content
    }
    
    /// Initializes component with constant range and row content.
    public init(
        uiModel: VStaticListUIModel = .init(),
        data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    )
        where
            Data == Range<Int>,
            ID == Int
    {
        self.uiModel = uiModel
        self.data = data
        self.id = \.self
        self.content = content
    }
    
    // MARK: Body
    public var body: some View {
        LazyVStack(
            alignment: uiModel.layout.alignment,
            spacing: 0,
            pinnedViews: [],
            content: {
                ForEach(data, id: id, content: { element in
                    VStack(spacing: 0, content: {
                        let index: Data.Index? = data.firstIndex(of: element)

                        if
                            index == data.startIndex &&
                            uiModel.layout.showsFirstSeparator
                        {
                            separator
                        }

                        content(element)
                            .padding(.vertical, uiModel.layout.rowPaddingVertical)

                        if index == data.index(before: data.endIndex) {
                            if uiModel.layout.showsLastSeparator {
                                separator
                            }
                        } else {
                            separator
                        }
                    })
                        .background(uiModel.colors.rowBackground)
                })
            }
        )
    }
    
    private var separator: some View {
        separatorColor
            .frame(maxWidth: .infinity)
            .frame(height: uiModel.layout.separatorHeight)
            .padding(uiModel.layout.separatorMargins)
    }
    
    // MARK: Helpers
    private var separatorColor: Color {
        if hasSeparator {
            return uiModel.colors.separator
        } else {
            return .clear
        }
    }
}

// MARK: - Preview
struct VStaticList_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.vertical, showsIndicators: true, content: {
            Text("First")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
            
            VStaticList(data: 0..<5, id: \.self, content: {
                Text(String($0))
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
            
            Text("Second")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
            
            VStaticList(data: 0..<5, id: \.self, content: {
                Text(String($0))
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
        })
            .padding()
    }
}
