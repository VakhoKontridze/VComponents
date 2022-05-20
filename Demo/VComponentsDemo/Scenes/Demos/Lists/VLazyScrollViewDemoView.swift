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
        DemoListView(type: .section, sections: sections)
            .standardNavigationTitle(Self.navBarTitle)
    }
}

// MARK: - V Lazy Scroll View Demo Detail View
private struct VLazyScrollViewDemoDetailView: View {
    // MARK: Properties
    static var navBarTitle: String { "Lazy Scroll View" }

    private let lazyScrollViewType: VLazyScrollViewType
    
    @State private var initializedRows: Set<Int> = []
    @State private var visibleRows: Set<Int> = []
    
    // MARK: Initializers
    init(
        _ lazyScrollViewType: VLazyScrollViewType
    ) {
        self.lazyScrollViewType = lazyScrollViewType
    }

    // MARK: Body
    fileprivate var body: some View {
        DemoView(component: component)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VStack(spacing: 25, content: {
            VText(
                color: ColorBook.primary,
                font: .callout,
                title: "Scroll rows and see lazy initialization"
            )

            switch lazyScrollViewType {
            case .vertical: vertical
            case .horizontal: horizontal
            }
            
            VStack(alignment: .leading, spacing: 5, content: {
                VText(
                    color: ColorBook.primary,
                    font: .footnote,
                    title: "Initialized: \(Array(initializedRows).rangesPrettyForamtted)"
                )
                
                VText(
                    color: ColorBook.primary,
                    font: .footnote,
                    title: "Visible: \(Array(visibleRows).rangesPrettyForamtted)"
                )
            })
                .frame(maxWidth: .infinity, alignment: .leading)
        })
    }
    
    private var vertical: some View {
        VLazyScrollView(type: .vertical(), data: 0..<100, content: { num in
            VText(
                color: ColorBook.primary,
                font: .body,
                title: "\(num)"
            )
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background(ColorBook.accent.opacity(0.75))
                .cornerRadius(5)
                .padding(.vertical, 3)
                .onAppear(perform: { initializedRows.insert(num); visibleRows.insert(num) })
                .onDisappear(perform: { visibleRows.remove(num) })
        })
    }
    
    private var horizontal: some View {
        VLazyScrollView(type: .horizontal(), data: 0..<100, content: { num in
            VText(
                color: ColorBook.primary,
                font: .body,
                title: "\(num)"
            )
                .frame(width: 30)
                .frame(maxHeight: .infinity)
                .background(ColorBook.accent.opacity(0.75))
                .cornerRadius(5)
                .padding(.horizontal, 3)
                .onAppear(perform: { initializedRows.insert(num); visibleRows.insert(num) })
                .onDisappear(perform: { visibleRows.remove(num) })
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

// MARK: - Helpers
extension Array where Element == Int {
    fileprivate var rangesPrettyForamtted: String {
        self
            .ranges
            .map { range in
                guard range.lowerBound != range.upperBound else { return String(range.lowerBound) }
                return "\(range.lowerBound) - \(range.upperBound)"
            }
            .joined(separator: ", ")
    }
    
    fileprivate var ranges: [ClosedRange<Int>] {
        let array: [Int] = self.sorted()
        
        var firstIndex: Int = 0
        guard var firstElement: Int = array.first else { return [] }
        
        guard count > 1 else { return [firstElement...firstElement] }
        
        var ranges: [ClosedRange<Int>] = []
        
        for (i, num) in array.enumerated().dropFirst() {
            if
                firstElement + (i - firstIndex) == num,
                i != count - 1
            {
                continue
            
            } else {
                let lastElement: Int = {
                    if i != count - 1 {
                        return array[i-1]
                    } else {
                        return num
                    }
                }()
                
                ranges.append(firstElement...lastElement)

                firstIndex = i
                firstElement = num
            }
        }
        
        return ranges
    }
}
