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

extension DataModel: Equatable {
    static func == (lhs: DataModel, rhs: DataModel) -> Bool {
        lhs.las == rhs.las
    }
}

extension DataModel {
    /// `las` değerini güvenli bir şekilde Float olarak döndürür
    var floatLas: Float {
        las?.toFloat() ?? 0
    }

    /// DataModel alanları için anahtarlar
    enum Key: String, CaseIterable, Codable {
        case las, pdd, ddi, low, hig, buy, sel, pdc, cei, flo, gco

        /// Enum'u ilgili `KeyPath`'e bağlama
        var keyPath: PartialKeyPath<DataModel> {
            switch self {
            case .las: return \DataModel.las
            case .pdd: return \DataModel.pdd
            case .ddi: return \DataModel.ddi
            case .low: return \DataModel.low
            case .hig: return \DataModel.hig
            case .buy: return \DataModel.buy
            case .sel: return \DataModel.sel
            case .pdc: return \DataModel.pdc
            case .cei: return \DataModel.cei
            case .flo: return \DataModel.flo
            case .gco: return \DataModel.gco
            }
        }

        /// Renk farklılığı gereken alanları belirler
        var isDifferentColor: Bool {
            [.pdd, .ddi].contains(self)
        }
    }

    /// Verilen `Key` ile DataModel'den değeri alır
    func getValue(for key: Key) -> String {
        guard let value = self[keyPath: key.keyPath] as? String else {
            return "-"
        }
        return value
    }
}

