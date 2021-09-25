//
//  DemoableRow.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI

// MARK: - Demoable ROw
protocol DemoableRow: Identifiable, RawRepresentable, CaseIterable where RawValue == Int {
    var title: String { get }
    
    associatedtype Content: View
    var body: Content { get }
}

// MARK: - ID
extension DemoableRow {
    var id: Int { rawValue }
}
