//
//  IdentifiableElement.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import Foundation

// MARK: - Identifiable Element
struct IdentifiableElement<ID, Value>: Identifiable where ID: Hashable {
    // MARK: Properties
    let id: ID
    let value: Value
    
    // MARK: Initializers
    init(id: ID, value: Value) {
        self.id = id
        self.value = value
    }
}
