//
//  VMenuSubMenu.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI

// MARK:- V Menu Sub Menu
struct VMenuSubMenu: View {
    // MARK: Properties
    private let rows: [VMenuRow]
    
    // MARK: Initializers
    init(rows: [VMenuRow]) {
        self.rows = rows
    }
}

// MARK:- Body
extension VMenuSubMenu {
    var body: some View {
        ForEach(rows.reversed().enumeratedArray(), id: \.offset, content: { (i, button) in
            switch button {
            case .button(let action, let title):
                Button(title, action: action)
                
            case .buttonSystemIcon(let action, let title, let name):
                Button(action: action, label: {
                    Text(title)
                    Image(systemName: name)
                })
            
            case .buttonAssetIcon(let action, let title, let name, let bundle):
                Button(action: action, label: {
                    Text(title)
                    Image(name, bundle: bundle)
                })
            
            case .menu(let title, let rows):
                Menu(
                    content: { VMenuSubMenu(rows: rows) },
                    label: { Text(title) }
                )
            }
        })
    }
}

// MARK:- Preview
struct VMenuSubMenu_Previews: PreviewProvider {
    static var previews: some View {
        VMenu_Previews.previews
    }
}
