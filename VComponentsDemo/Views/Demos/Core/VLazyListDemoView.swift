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
            DemoListView(sections: sections)
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
            ZStack(content: {
                ColorBook.layer.edgesIgnoringSafeArea(.bottom)
                lazyList
            })
        })
    }
         
    private var lazyList: some View {
        VStack(spacing: 25, content: {
            Text("Scroll rows and see lazy initialization")
                .font(.callout)

            switch lazyListType {
            case .vertical: vertical
            case .horizontal: horizontal
            }
            
            VStack(spacing: 10, content: {
                Text("Initialized Rows")
                    .font(.callout)
                
                Text(initializedRowsDescription)
                    .frame(height: 200, alignment: .top)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
            })
        })
            .padding()
    }
    
    private var vertical: some View {
        VLazyList(model: .vertical(), range: 1..<101, rowContent: { num in
            Text("\(num)")
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background(ColorBook.accent.opacity(0.75))
                .cornerRadius(5)
                .padding(.vertical, 3)
                .onAppear(perform: { initializedRows.insert(num) })
        })
    }
    
    private var horizontal: some View {
        VLazyList(model: .horizontal(), range: 1..<101, rowContent: { num in
            Text("\(num)")
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
        VLazyListDemoView()
    }
}
