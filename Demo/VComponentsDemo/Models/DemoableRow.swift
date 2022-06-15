//
//  DemoableRow.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI

// MARK: - Demoable Row
protocol DemoableRow: Identifiable, RawRepresentable, CaseIterable where RawValue == Int {
    var title: String { get }
    
    associatedtype Content: View
    var body: Content { get }
}

extension DemoableRow {
    var id: Int { rawValue }
}
