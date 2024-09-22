//
//  ArrowType.swift
//  StockApp
//
//  Created by Mine Rala on 21.09.2024.
//

import UIKit

public enum ArrowType {
   case down
   case up
   case stable

   var viewColor: UIColor {
       switch self {
       case .up:
           return .green
       case .down:
           return .red
       case .stable:
           return .darkGray
       }
   }
}
