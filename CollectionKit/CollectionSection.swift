//
//  CollectionSection.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
//todo: добавть equals и перенести все методы по работе с секцией в протокол, добавить в ридми про абстрактные секции
public protocol AbstractCollectionSection : class {
    var identifier: String { get }
    var headerItem: AbstractCollectionItem? { get set }
    var footerItem: AbstractCollectionItem? { get set }
    
    var insetForSection: UIEdgeInsets { get set }
    var minimumInterItemSpacing: CGFloat { get set }
    var lineSpacing: CGFloat { get set }
    
    var isEmpty: Bool { get }
    
    func numberOfItems() -> Int
    func item(for index: Int) -> AbstractCollectionItem
    func reload()
    func insert(item: AbstractCollectionItem, at index: Int)
    func contains(item: AbstractCollectionItem) -> Bool
    func index(for item: AbstractCollectionItem) -> Int?
    func clear()
}

extension AbstractCollectionSection {
    public var isEmpty: Bool { return numberOfItems() == 0 }
    
    public func reload() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.reloadSection.rawValue),
                                        object: self)
    }
    
    public func insert(item: AbstractCollectionItem, at index: Int) {
        
    }
}

public func ==(lhs: AbstractCollectionSection, rhs: AbstractCollectionSection) -> Bool {
    return lhs.identifier == rhs.identifier
}


open class CollectionSection : AbstractCollectionSection {
    public let identifier: String = UUID().uuidString
    public func item(for index: Int) -> AbstractCollectionItem {
        return items[index]
    }

    public func numberOfItems() -> Int {
        return items.count
    }

    open var items: [AbstractCollectionItem] = []
    open var headerItem: AbstractCollectionItem?
    open var footerItem: AbstractCollectionItem?
    
    open var insetForSection: UIEdgeInsets = .zero
    open var minimumInterItemSpacing: CGFloat = CGFloat.leastNormalMagnitude
    open var lineSpacing: CGFloat = 0
    
    public init() {}

    public func append(item: AbstractCollectionItem, shouldNotify: Bool = false) {
        items.append(item)
        //TODO: это нужно не всегда
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.sectionChanges.rawValue),
                                        object: self,
                                        userInfo: [ CollectionChange.insertItem.rawValue : items.count - 1 ])
    }
    
    public func clear() {
        items.removeAll()
    }

    public func insert(item: AbstractCollectionItem, at index: Int) {
        items.insert(item, at: index)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.sectionChanges.rawValue),
                                        object: self,
                                        userInfo: [ CollectionChange.insertItem.rawValue : index ])
    }
    
    public func remove(at index: Int) {
        items.remove(at: index)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.sectionChanges.rawValue),
                                        object: self,
                                        userInfo: [ CollectionChange.removeItem.rawValue : index ])
    }
    
    
    public func reload() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.reloadSection.rawValue),
                                        object: self)
    }
    
    public func contains(item: AbstractCollectionItem) -> Bool {
        return items.contains(where: {$0 == item})
    }
    
    public func index(for item: AbstractCollectionItem) -> Int? {
        return items.index(where: {$0 == item})
    }
}

open class ExpandableSection: CollectionSection {
    open var collapsedItemsCount: Int
    open var isExpanded: Bool = false
    
    //TODO: consider pass isInitiallyExpanded paramater
    public init(collapsedItemsCount: Int) {
        self.collapsedItemsCount = collapsedItemsCount
    }
}
