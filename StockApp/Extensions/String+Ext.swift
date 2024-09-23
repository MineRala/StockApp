//
//  Swift+Ext.swift
//  StockApp
//
//  Created by Mine Rala on 21.09.2024.
//

import UIKit

extension String {
    func toFloat() -> Float? {
        let normalizedString = self
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")

        return Float(normalizedString.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    func checkNumberSign() -> UIColor {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.hasPrefix("-") {
            return .red
        }
        return .green
    }
}
