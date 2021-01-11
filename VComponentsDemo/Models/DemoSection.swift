//
//  DemoSection.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import Foundation

// MARK:- Demo Section
struct DemoSection<Row>: Identifiable where Row: DemoableRow {
    let id: Int
    let title: String?
    let rows: [Row]
}
