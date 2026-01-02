//
//  Reusable.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation
import UIKit.UINib

public protocol Reusable {
    static var nib: UINib { get }
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    /// Assume that nib file name matches class name
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension UICollectionView {
    /// Dequeues a reusable cell of the specified type.
    /// - Note: This will trigger an assertionFailure in debug builds if the cell is not registered,
    ///         but will attempt to register and dequeue in release builds to prevent crashes.
    func dequeue<T: Reusable>(indexPath: IndexPath) -> T where T: UICollectionViewCell {
        if let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T {
            return cell
        }
        // Cell not registered - try to register and dequeue again
        assertionFailure("cell type \(T.self) is not registered - attempting auto-registration")
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        // Safe cast after registration - return the dequeued cell or a new instance as fallback
        if let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T {
            return cell
        }
        // Final fallback - should never happen, but prevents crash
        assertionFailure("Failed to dequeue cell of type \(T.self) even after registration")
        return T.init()
    }
    
    func registerNib<T: Reusable>(_ type: T.Type) {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerClass<T: Reusable>(_ type: T.Type) where T: UICollectionViewCell {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}
