//
//  VRoundedCaptionedButtonCaption.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

import SwiftUI

// MARK: - V Rounded Captioned Button Caption
@available(macOS, unavailable)
@available(tvOS, unavailable)
enum VRoundedCaptionedButtonCaption<Caption> where Caption: View {
    case title(title: String)
    case iconTitle(icon: Image, title: String)
    case caption(caption: (VRoundedCaptionedButtonInternalState) -> Caption)
}
