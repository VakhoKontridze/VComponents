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
            
            VLazyScrollView(
                type: .vertical(uiModel: {
                    var uiModel: VLazyScrollViewVerticalUIModel = .init()
                    uiModel.layout.rowSpacing = 20
                    return uiModel
                }()),
                data: sections.enumeratedArray(),
                id: \.element.id,
                content: { (i, section) in
                    VDisclosureGroup(
                        uiModel: {
                            var uiModel: VDisclosureGroupUIModel = .init()
                            uiModel.layout.contentMargins.top = 5
                            uiModel.layout.contentMargins.bottom = 5
                            return uiModel
                        }(),
                        state: $disclosureGroupStates[i],
                        headerTitle: section.title ?? "",
                        content: {
                            VStaticList(
                                uiModel: {
                                    var model: VStaticListUIModel = .init()
                                    model.layout.showsFirstSeparator = false
                                    model.layout.showsLastSeparator = false
                                    return model
                                }(),
                                data: section.rows,
                                content: { row in DemoListRowView(title: row.title, destination: row.body) }
                            )
                        }
                    )
                    
                    if i == sections.enumeratedArray().count - 1 {
                        Spacer()
                            .frame(height: UIDevice.safeAreaInsetBottom + 10)
                    }
                }
            )
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
