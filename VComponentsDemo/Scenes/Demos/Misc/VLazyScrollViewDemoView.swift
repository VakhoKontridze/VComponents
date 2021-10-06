//
//  VLazyScrollViewDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK: - V Lazy Scroll View Demo View
struct VLazyScrollViewDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Lazy Scroll View" }
    
    private let sections: [DemoSection<VLazyScrollViewDemoViewDataSource.LazyScrollViewRow>] = [
        .init(id: 0, title: nil, rows: [.vertical, .horizontal])
    ]

    // MARK: Body
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoListView(type: .section, sections: sections)
        })
    }
}

// MARK: - V Lazy Scroll View Demo Detail View
private struct VLazyScrollViewDemoDetailView: View {
    // MARK: Properties
    static var navBarTitle: String { "Lazy Scroll View" }

    private let lazyScrollViewType: VLazyScrollViewType
    
    @State private var initializedRows: Set<Int> = []
    private var initializedRowsDescription: String {
        Array(initializedRows)
            .sorted()
            .map { String($0) }
            .joined(separator: ", ")
    }
    
    // MARK: Initializers
    init(
        _ lazyScrollViewType: VLazyScrollViewType
    ) {
        self.lazyScrollViewType = lazyScrollViewType
    }

    // MARK: Body
    fileprivate var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
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

            switch lazyScrollViewType {
            case .vertical: vertical
            case .horizontal: horizontal
            @unknown default: fatalError()
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
        VLazyScrollView(type: .vertical(), range: 1..<101, content: { num in
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
        VLazyScrollView(type: .horizontal(), range: 1..<101, content: { num in
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

// MARK: - Helpers
private struct VLazyScrollViewDemoViewDataSource {
    private init() {}
    
    enum LazyScrollViewRow: Int, DemoableRow {
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
            case .vertical: return VLazyScrollViewDemoDetailView(.vertical())
            case .horizontal: return VLazyScrollViewDemoDetailView(.horizontal())
            }
        }
    }
}

// MARK: - Preview
struct VLazyScrollViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
//        VLazyScrollViewDemoView()
        VLazyScrollViewDemoDetailView(.vertical(.init()))
    }
}
