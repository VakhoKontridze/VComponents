//
//  DemoListView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VComponents

// MARK: - Demo List View
struct DemoListView<Row>: View where Row: DemoableRow {
    // MARK: Properties
    private let sections: [DemoSection<Row>]
    @State private var disclosureGroupStates: [VDisclosureGroupState]
    
    // MARK: Initializers
    init(sections: [DemoSection<Row>]) {
        self.sections = sections
        self._disclosureGroupStates = .init(initialValue: .init(repeating: .collapsed, count: sections.count))
    }

    // MARK: Body
    var body: some View {
        ZStack(content: {
            ColorBook.canvas.ignoresSafeArea()
            
            ScrollView(content: {
                LazyVStack(spacing: 20, content: {
                    ForEach(sections.enumeratedArray(), id: \.element.id, content: { (i, section) in
                        VDisclosureGroup(
                            state: $disclosureGroupStates[i],
                            headerTitle: section.title ?? "",
                            content: {
                                LazyVStack(spacing: 0, content: {
                                    ForEach(section.rows.enumeratedArray(), id: \.element.id, content: { (j, row) in
                                        VListRow(separator: .noFirstAndLastSeparators(isFirst: j == 0), content: {
                                            DemoListRowView(title: row.title, destination: row.body)
                                        })
                                    })
                                })
                            }
                        )
                    })
                })
                
                Spacer()
                    .frame(height: UIDevice.safeAreaInsetBottom + 10)
            })
                .padding(.top, 10)
        })
            .ignoresSafeArea(.container, edges: .bottom)
    }
}

// MARK: Preview
struct DemoListView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView_Previews.previews
    }
}
