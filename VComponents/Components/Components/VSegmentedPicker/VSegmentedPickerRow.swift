//
//  VSegmentedPickerRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK:- V Segmented Picker Row
public struct VSegmentedPickerRow<Content> where Content: View {
    // MARK: Properties
    public let content: Content
    public let isEnabled: Bool
    
    // MARK: Initializers
    public init(content: Content, isEnabled: Bool = true) {
        self.content = content
        self.isEnabled = isEnabled
    }
}

// MARK:- V Segmented Picker Text Row
public struct VSegmentedPickerTextRow<S> where S: StringProtocol {
    // MARK: Properties
    public let title: S
    public let isEnabled: Bool
    
    // MARK: Initializers
    public init(title: S, isEnabled: Bool = true) {
        self.title = title
        self.isEnabled = isEnabled
    }
}
