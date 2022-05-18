//
//  VMenuPickerRowContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI

// MARK: - V Menu Picker Row Content
/// Enum that represens menu picker row, such as title, or title with various icon configurations.
public enum VMenuPickerRowContent {
    /// Row with title.
    case title(title: String)
    
    /// Row with title and icon.
    case titleIcon(title: String, icon: Image)
    
    /// Row with title and icon from assets catalog.
    case titleAssetIcon(title: String, icon: String, bundle: Bundle? = nil)
    
    /// Row with title and sytem icon.
    case titleSystemIcon(title: String, icon: String)
}
