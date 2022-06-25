//
//  VContextMenuContentView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.06.22.
//

import SwiftUI

// MARK: - V Menu Content View
struct VContextMenuContentView: View {
    // MARK: Properties
    private let rows: [VContextMenuRow]
    
    // MARK: Initializers
    init(rows: [VContextMenuRow]) {
        self.rows = rows
    }

    // MARK: Body
    var body: some View {
        ForEach(rows.enumeratedArray(), id: \.offset, content: { (_, row) in
            switch row._contextMenuRow {
            case .title(let action, let title):
                Button(title, action: action)
                
            case .titleAssetIcon(let action, let title, let name, let bundle):
                Button(action: action, label: {
                    Text(title)
                    Image(name, bundle: bundle)
                })
                
            case .titleIcon(let action, let title, let icon):
                Button(action: action, label: {
                    Text(title)
                    icon
                })
                
            case .titleSystemIcon(let action, let title, let name):
                Button(action: action, label: {
                    Text(title)
                    Image(systemName: name)
                })
            
            case .menu(let title, let rows):
                Menu(
                    content: { VContextMenuContentView(rows: rows) },
                    label: { Text(title) }
                )
            }
        })
    }
}

// MARK: - Preview
struct VContextMenuContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Lorem ipsum")
            .vContextMenu(rows: [
                .titleIcon(action: {}, title: "One", assetIcon: "XMark", bundle: .module),
                .titleIcon(action: {}, title: "Two", icon: .init(systemName: "swift")),
                .titleIcon(action: {}, title: "Three", systemIcon: "swift"),
                .title(action: {}, title: "Four"),
                .title(action: {}, title: "Five"),
                .menu(title: "Five...", rows: [
                    .title(action: {}, title: "One"),
                    .title(action: {}, title: "Two"),
                    .title(action: {}, title: "Three"),
                    .menu(title: "Four...", rows: [
                        .title(action: {}, title: "One"),
                        .title(action: {}, title: "Two")
                    ])
                ])
            ])
    }
}
