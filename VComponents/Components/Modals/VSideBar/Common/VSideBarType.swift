//
//  VSideBarType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Side Bar Type
public enum VSideBarType {
    case standard(_ model: VSideBarModelStandard = .init())
    
    public static let `default`: VSideBarType = .standard()
}
