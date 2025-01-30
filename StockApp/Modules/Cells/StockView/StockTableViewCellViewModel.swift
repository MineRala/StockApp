//
//  StockTableViewCellViewModel.swift
//  StockApp
//
//  Created by Mine Rala on 22.09.2024.
//

import UIKit

struct StockTableViewCellViewModel {
    private(set) var title: String
    private(set) var date: String
    private(set) var arrowType: ArrowType
    private(set) var valueOne: String
    private(set) var valueTwo: String
    private(set) var valueOneColor: UIColor
    private(set) var valueTwoColor: UIColor

    init(
        title: String,
        date: String,
        arrowType: ArrowType,
        valueOne: String,
        valueTwo: String,
        valueOneColor: UIColor,
        valueTwoColor: UIColor
    ) {
        self.title = title
        self.date = date
        self.arrowType = arrowType
        self.valueOne = valueOne
        self.valueTwo = valueTwo
        self.valueOneColor = valueOneColor
        self.valueTwoColor = valueTwoColor
    }

      mutating func withUpdatedDate(newDate: String) {
          self.date = newDate
      }
}
