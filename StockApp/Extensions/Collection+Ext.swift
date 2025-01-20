//
//  Collection+Ext.swift
//  StockApp
//
//  Created by Mine Rala on 4.01.2025.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
