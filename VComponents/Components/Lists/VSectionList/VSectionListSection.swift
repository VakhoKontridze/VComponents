//
//  VSectionListSectionViewModelable.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import Foundation

// MARK: - V Section List Section ViewModelable
/// ViewModel that creates `VSectionList` sections
public protocol VSectionListSectionViewModelable: Identifiable {
    associatedtype VSectionListRowViewModelable: Identifiable
    var rows: [VSectionListRowViewModelable] { get }
}
