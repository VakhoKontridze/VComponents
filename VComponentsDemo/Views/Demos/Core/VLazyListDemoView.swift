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
    
    private let sections: [DemoSection<VLazyListDemoViewDataSource.LazyListRow>] = [
        .init(id: 0, title: nil, rows: [.vertical, .horizontal])
    ]
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

    private let lazyListType: VLazyListType
    
    @State private var initializedRows: Set<Int> = []
    private var initializedRowsDescription: String {
        Array(initializedRows)
            .sorted()
            .map { String($0) }
            .joined(separator: ", ")
    }
    
    init(
        _ lazyListType: VLazyListType
    ) {
        self.lazyListType = lazyListType
    }
}

private extension VLazyListDemoDetailView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(component: component)
        })
    }
    
    private func component() -> some View {
        VStack(spacing: 25, content: {
            VText(
                type: .oneLine,
                font: .callout,
                color: ColorBook.primary,
                title: "Scroll rows and see lazy initialization"
            )

            switch lazyListType {
            case .vertical: vertical
            case .horizontal: horizontal
            }
            
            VStack(spacing: 10, content: {
                VText(
                    type: .oneLine,
                    font: .callout,
                    color: ColorBook.primary,
                    title: "Initialized Rows"
                )
                
                VText(
                    type: .multiLine(limit: nil, alignment: .leading),
                    font: .footnote,
                    color: ColorBook.primary,
                    title: initializedRowsDescription
                )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 200, alignment: .top)
            })
        })
    }
    
    private var vertical: some View {
        VLazyList(type: .vertical(), range: 1..<101, content: { num in
            VText(
                type: .oneLine,
                font: .body,
                color: ColorBook.primary,
                title: "\(num)"
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
        VLazyList(type: .horizontal(), range: 1..<101, content: { num in
            VText(
                type: .oneLine,
                font: .body,
                color: ColorBook.primary,
                title: "\(num)"
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

// MARK:- Helpers
private struct VLazyListDemoViewDataSource {
    private init() {}
    
    enum LazyListRow: Int, DemoableRow {
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

// MARK:- Preview
struct VLazyListDemoView_Previews: PreviewProvider {
    static var previews: some View {
//        VLazyListDemoView()
        VLazyListDemoDetailView(.vertical(.init()))
    }
}
