//
//  VLazyListDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK:- V Lazy List Demo View
struct VLazyListDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Lazy List"
    
    private let sections: [DemoSection<LazyListRow>] = [
        .init(id: 0, title: nil, rows: [.vertical, .horizontal])
    ]
    
    private enum LazyListRow: Int, DemoableRow {
        case vertical
        case horizontal
        
        var title: String {
            switch self {
            case .vertical: return "Vertical"
            case .horizontal: return "Horizontal"
            }
        }
        
        var body: some View {
            switch self {
            case .vertical: return VLazyListDemoDetailView(.vertical())
            case .horizontal: return VLazyListDemoDetailView(.horizontal())
            }
        }
    }
}

// MARK:- Body
extension VLazyListDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoListView(type: .section, sections: sections)
        })
    }
}

// MARK:- V Lazy List Demo Detail View
private struct VLazyListDemoDetailView: View {
    static let navigationBarTitle: String = "Lazy List"

    private let lazyListType: VLazyListModel
    
    @State private var initializedRows: Set<Int> = []
    private var initializedRowsDescription: String {
        Array(initializedRows)
            .sorted()
            .map { String($0) }
            .joined(separator: ", ")
    }
    
    init(
        _ lazyListType: VLazyListModel
    ) {
        self.lazyListType = lazyListType
    }
}

private extension VLazyListDemoDetailView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .section, content: {
                VStack(spacing: 25, content: {
                    VText(
                        title: "Scroll rows and see lazy initialization",
                        color: ColorBook.primary,
                        font: .callout,
                        type: .oneLine
                    )

                    switch lazyListType {
                    case .vertical: vertical
                    case .horizontal: horizontal
                    }
                    
                    VStack(spacing: 10, content: {
                        VText(
                            title: "Initialized Rows",
                            color: ColorBook.primary,
                            font: .callout,
                            type: .oneLine
                        )
                        
                        VText(
                            title: initializedRowsDescription,
                            color: ColorBook.primary,
                            font: .footnote,
                            type: .multiLine(limit: nil, alignment: .leading)
                        )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 200, alignment: .top)
                    })
                })
            })
        })
    }
    
    private var vertical: some View {
        VLazyList(model: .vertical(), range: 1..<101, content: { num in
            VText(
                title: "\(num)",
                color: ColorBook.primary,
                font: .body,
                type: .oneLine
            )
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background(ColorBook.accent.opacity(0.75))
                .cornerRadius(5)
                .padding(.vertical, 3)
                .onAppear(perform: { initializedRows.insert(num) })
        })
    }
    
    private var horizontal: some View {
        VLazyList(model: .horizontal(), range: 1..<101, content: { num in
            VText(
                title: "\(num)",
                color: ColorBook.primary,
                font: .body,
                type: .oneLine
            )
                .frame(width: 30)
                .frame(maxHeight: .infinity)
                .background(ColorBook.accent.opacity(0.75))
                .cornerRadius(5)
                .padding(.horizontal, 3)
                .onAppear(perform: { initializedRows.insert(num) })
        })
    }
}

// MARK:- Preview
struct VLazyListDemoView_Previews: PreviewProvider {
    static var previews: some View {
//        VLazyListDemoView()
        VLazyListDemoDetailView(.vertical(.init()))
    }
}
