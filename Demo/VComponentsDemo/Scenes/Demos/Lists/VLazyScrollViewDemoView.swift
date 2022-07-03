//
//  VLazyScrollViewDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Lazy Scroll View Demo View
struct VLazyScrollViewDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Lazy Scroll View" }

    @State private var lazyScrollViewType: VLazyScrollViewTypeHelper = .vertical
    
    @State private var initializedRows: Set<Int> = []
    @State private var visibleRows: Set<Int> = []

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
            .onChange(of: lazyScrollViewType, perform: { _ in
                initializedRows = []
                visibleRows = []
            })
    }
    
    private func component() -> some View {
        VStack(spacing: 25, content: {
            VText(
                color: ColorBook.primary,
                font: .callout,
                text: "Scroll rows and see lazy initialization"
            )

            switch lazyScrollViewType {
            case .vertical: vertical
            case .horizontal: horizontal
            }
            
            VStack(alignment: .leading, spacing: 5, content: {
                VText(
                    color: ColorBook.primary,
                    font: .footnote,
                    text: "Initialized: \(Array(initializedRows).rangesPrettyForamtted)"
                )
                
                VText(
                    color: ColorBook.primary,
                    font: .footnote,
                    text: "Visible: \(Array(visibleRows).rangesPrettyForamtted)"
                )
            })
                .frame(maxWidth: .infinity, alignment: .leading)
        })
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $lazyScrollViewType, headerTitle: "Type")
    }
    
    private var vertical: some View {
        VLazyScrollView(type: .vertical(), data: 0..<100, content: { num in
            VText(
                color: ColorBook.primary,
                font: .body,
                text: "\(num)"
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
                text: "\(num)"
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
private enum VLazyScrollViewTypeHelper: StringRepresentableHashableEnumeration {
    case vertical
    case horizontal
    
    var stringRepresentation: String {
        switch self {
        case .vertical: return "Vertical"
        case .horizontal: return "Horizontal"
        }
    }
}

// MARK: - Preview
struct VLazyScrollViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VLazyScrollViewDemoView()
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
