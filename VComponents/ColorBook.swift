//
//  ColorBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- Color Book
struct ColorBook {
    private init() {}
}

// MARK:- Primary
extension ColorBook {
    struct Primary {
        private init() {}
        
        struct Fill {
            static let enabled: Color = .init(red: 50/255, green: 130/255, blue: 230/255, opacity: 1)
            static let pressed: Color = .init(red: 30/255, green: 90/255, blue: 160/255, opacity: 1)
            static let disabledDark: Color = .init(red: 130/255, green: 180/255, blue: 240/255, opacity: 1)
            static let disabledLight: Color = .init(red: 150/255, green: 190/255, blue: 240/255, opacity: 1)
            
            private init() {}
        }
        
        struct Text {
            static let enabled: Color = .init(red: 10/255, green: 120/255, blue: 255/255, opacity: 1)
            static let pressed: Color = .init(red: 110/255, green: 160/255, blue: 250/255, opacity: 1)
            static let disabled: Color = .init(red: 130/255, green: 180/255, blue: 240/255, opacity: 1)
            
            private init() {}
        }
    }
}

// MARK:- White
extension ColorBook {
    struct White {
        private init() {}
        
        struct Text {
            static let enabled: Color = .init(red: 255/255, green: 255/255, blue: 255/255, opacity: 1)
            static let pressed: Color = .init(red: 255/255, green: 255/255, blue: 255/255, opacity: 1)
            static let disabled: Color = .init(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.5)
            
            private init() {}
        }
    }
}

// MARK:- Gray
extension ColorBook {
    struct Gray {
        private init() {}

        struct Fill {
            static let enabled: Color = .init(red: 230/255, green: 230/255, blue: 230/255, opacity: 1)
            static let disabled: Color = .init(red: 240/255, green: 240/255, blue: 240/255, opacity: 1)
            
            private init() {}
        }
    }
}
