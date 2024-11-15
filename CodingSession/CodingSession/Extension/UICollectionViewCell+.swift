//
//  UICollectionViewCell+.swift
//  CodingSession
//
//  Created by Dzmitry Pats on 15.11.24.
//

import UIKit

protocol ReuseIdentifiable {
    static func reuseIdentifier() -> String
}

extension ReuseIdentifiable {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReuseIdentifiable {}
