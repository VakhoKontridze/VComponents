//
//  VSectionListSection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import Foundation

// MARK:- V Section List Section
/// Data source that creates `VSectionList` sections
public protocol VSectionListSection: Identifiable {
    associatedtype VSectionListRow: VComponents.VSectionListRow
    var rows: [VSectionListRow] { get }
}
