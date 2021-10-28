//
//  Optional.LetBlockTransformation.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 10/28/21.
//

import Foundation

// MARK: - Optional Let Block Transformation
extension Optional {
    func `let`<T>(_ transform: (Wrapped) throws -> T?) rethrows -> T? {
        guard
            let self = self,
            let result: T = try transform(self)
        else {
            return nil
        }
        
        return result
    }
}
