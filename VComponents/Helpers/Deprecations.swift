//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import Foundation

// MARK:- V List
@available(*, deprecated, renamed: "VList")
public typealias VSection = VList

@available(*, deprecated, renamed: "VListLayoutType")
public typealias VSectionLayoutType = VListLayoutType

@available(*, deprecated, renamed: "VListModel")
public typealias VSectionModel = VListModel

// MARK:- V Lazy Scroll View
@available(*, deprecated, renamed: "VLazyScrollView")
public typealias VLazyList = VLazyScrollView

@available(*, deprecated, renamed: "VLazyScrollViewType")
public typealias VLazyListType = VLazyScrollViewType

@available(*, deprecated, renamed: "VLazyScrollViewModelVertical")
public typealias VLazyListModelVertical = VLazyScrollViewModelVertical

@available(*, deprecated, renamed: "VLazyScrollViewModelHorizontal")
public typealias VLazyListModelHorizontal = VLazyScrollViewModelHorizontal
