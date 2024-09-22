//
//  Swift+Ext.swift
//  StockApp
//
//  Created by Mine Rala on 21.09.2024.
//

import UIKit

extension String {
    func toFloat() -> Float? {
        return Float(self.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    func checkNumberSign() -> UIColor {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.hasPrefix("-") {
            return .red
        }
        return .green
    }

    func getSTCS(myPageDefaults: [MyPageDefaults]?) -> String {
        guard let myPageDefaults else { return ""}
        var resultString = ""

        for (index, element) in myPageDefaults.enumerated() {
            resultString += element.tke
            if index < myPageDefaults.count - 1 {
                resultString += "~"
            }
        }
        return resultString
    }

}
