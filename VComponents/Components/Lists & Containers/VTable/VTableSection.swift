//
//  VTableSection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import Foundation

// MARK:- V Table Section
/// Data source that creates `VTableView` sections
public protocol VTableSection: Identifiable {
    associatedtype VTableRow: VComponents.VTableRow
    var rows: [VTableRow] { get }
}
