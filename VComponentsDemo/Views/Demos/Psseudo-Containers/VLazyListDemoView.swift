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
    
    @State private var initializedRows: Set<Int> = []
    private var initializedRowsDescription: String {
        Array(initializedRows)
            .sorted()
            .map { String($0) }
            .joined(separator: ", ")
    }
}

// MARK:- Body
extension VLazyListDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            ZStack(content: {
                VComponents.ColorBook.layer.edgesIgnoringSafeArea(.bottom)
                lazyList
            })
        })
    }
    
    private var lazyList: some View {
        VStack(spacing: 10, content: {
            Text("Scroll rows and see lazy initialization")
                .font(.callout)
            
            Spacer().frame(height: 20)
            
            VLazyList(range: 1..<101, rowContent: { num in
                Text("\(num)")
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                    .background(VComponents.ColorBook.accent.opacity(0.75))
                    .cornerRadius(5)
                    .padding(.vertical, 3)
                    .onAppear(perform: { initializedRows.insert(num) })
            })
            
            Spacer().frame(height: 20)
            
            Text("Initialized Rows")
                .font(.callout)
            
            Text(initializedRowsDescription)
                .frame(height: 200, alignment: .top)
                .font(.footnote)
                .multilineTextAlignment(.leading)
        })
            .padding()
    }
}

// MARK:- Preview
struct VLazyListDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VLazyListDemoView()
    }
}
