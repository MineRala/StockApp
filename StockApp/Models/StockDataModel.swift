//
//  StockDataModel.swift
//  StockApp
//
//  Created by Mine Rala on 21.09.2024.
//

import Foundation

struct StockDataModel: Codable {
    var dataModel: [DataModel]
    
    enum CodingKeys: String, CodingKey {
        case dataModel = "l"
    }
}

struct DataModel: Codable {
    var tke: String
    var clo: String
    var las: String?
    var pdd: String?
    var ddi: String?
    var low: String?
    var hig: String?
    var buy: String?
    var sel: String?
    var pdc: String?
    var cei: String?
    var flo: String?
    var gco: String?
}
