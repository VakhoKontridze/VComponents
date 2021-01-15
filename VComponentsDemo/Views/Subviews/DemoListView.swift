//
//  DemoListView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VComponents

// MARK:- Demo List View
struct DemoListView<Row>: View where Row: DemoableRow {
    // MARK: Properties
    private let demoType: DemoType
    enum DemoType {
        case accordion
        case section
    }
    
    private let sections: [DemoSection<Row>]
    @State private var accordionStates: [VAccordionState]
    
    private let lazyListModel: VLazyListModelVertical = {
        var model: VLazyListModelVertical = .init()
        model.layout.spacing = 20
        return model
    }()
    
    // MARK: Initializers
    init(type demoType: DemoType, sections: [DemoSection<Row>]) {
        self.demoType = demoType
        self.sections = sections
        self._accordionStates = .init(initialValue: .init(repeating: .collapsed, count: sections.count))
    }
}

// MARK:- Body
extension DemoListView {
    var body: some View {
        ZStack(content: {
            ColorBook.canvas.edgesIgnoringSafeArea(.bottom)
            
            switch demoType {
            case .accordion:
                VLazyList(model: .vertical(lazyListModel), data: sections.enumeratedArray(), id: \.element.id, content: { (i, section) in
                    VAccordion(
                        state: $accordionStates[i],
                        header: { VModalDefaultHeader(title: section.title ?? "") },
                        data: section.rows,
                        content: { row in DemoListRowView(title: row.title, destination: row.body) }
                    )
                })
                    .padding(.vertical, 1)  // SwiftUI is bugged
                
            case .section:
                VLazyList(model: .vertical(lazyListModel), data: sections.enumeratedArray(), id: \.element.id, content: { (i, section) in
                    VSection(title: section.title, data: section.rows, content: { row in
                        DemoListRowView(title: row.title, destination: row.body)
                    })
                        .padding(.trailing, 16)
                })
                    .padding([.leading, .top, .bottom], 16)
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

// MARK:- Helpers
extension Collection {
    func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
        .init(self.enumerated())
    }
}
