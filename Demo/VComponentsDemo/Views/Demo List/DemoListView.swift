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
    private let demoType: DemoType
    enum DemoType {
        case disclosureGroup
        case section
    }
    
    private let sections: [DemoSection<Row>]
    @State private var disclosureGroupStates: [VDisclosureGroupState]
    
    private let lazyScrollViewModel: VLazyScrollViewVerticalModel = {
        var model: VLazyScrollViewVerticalModel = .init()
        model.layout.rowSpacing = 20
        return model
    }()
    
    // MARK: Initializers
    init(type demoType: DemoType, sections: [DemoSection<Row>]) {
        self.demoType = demoType
        self.sections = sections
        self._disclosureGroupStates = .init(initialValue: .init(repeating: .collapsed, count: sections.count))
    }

    // MARK: Body
    var body: some View {
        ZStack(content: {
            ColorBook.canvas.ignoresSafeArea(.all, edges: .all)
            
            switch demoType {
            case .disclosureGroup:
                VLazyScrollView(
                    type: .vertical(model: lazyScrollViewModel),
                    data: sections.enumeratedArray(),
                    id: \.element.id,
                    content: { (i, section) in
                        VDisclosureGroup(
                            state: $disclosureGroupStates[i],
                            headerTitle: section.title ?? "",
                            content: {
                                VList(
                                    layout: .fixed,
                                    data: section.rows,
                                    rowContent: { row in DemoListRowView(title: row.title, destination: row.body) }
                                )
                            }
                        )
                    }
                )
                    .padding(.bottom, 1)  // SwiftUI is bugged
                    .padding(.top, 10)
                
            case .section:
                VSheet()
                
                VLazyScrollView(
                    type: .vertical(model: lazyScrollViewModel),
                    data: sections.enumeratedArray(),
                    id: \.element.id,
                    content: { (i, section) in
                        VList(data: section.rows, rowContent: { row in
                            DemoListRowView(title: row.title, destination: row.body)
                        })
                            .padding(.trailing, 15)
                    }
                )
                    .padding([.leading, .top, .bottom], 15)
            }
        })
    }
}

// MARK: Preview
struct DemoListView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView_Previews.previews
    }
}

// MARK: - Helpers
extension Collection {
    func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
        .init(self.enumerated())
    }
}
