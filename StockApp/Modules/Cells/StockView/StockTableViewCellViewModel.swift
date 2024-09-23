//
//  StockTableViewCellViewModel.swift
//  StockApp
//
//  Created by Mine Rala on 22.09.2024.
//

import Foundation

protocol StockTableViewCellViewModelInterface: AnyObject  {
    func getValue(key: String, model: DataModel) -> String
    func isDifferentValueColor(key: String) -> Bool
}

final class StockTableViewCellViewModel {
    private weak var view: StockTableViewCellInterface?

    init(view: StockTableViewCellInterface) {
        self.view = view
    }
}

// MARK: - StockTableViewCellViewModelInterface
extension StockTableViewCellViewModel: StockTableViewCellViewModelInterface {
    func getValue(key: String, model: DataModel) -> String {
        if key == "las" {
            return model.las ?? "-"
        } else if key == "pdd" {
            return model.pdd ?? "-"
        } else if key == "ddi" {
            return model.ddi ?? "-"
        } else if key == "low" {
            return model.low ?? "-"
        } else if key == "hig" {
            return model.hig ?? "-"
        } else if key == "buy" {
            return model.buy ?? "-"
        } else if key == "sel" {
            return model.sel ?? "-"
        } else if key == "pdc" {
            return model.pdc ?? "-"
        } else if key == "cei" {
            return model.cei ?? "-"
        } else if key == "flo" {
            return model.flo ?? "-"
        } else if key == "gco" {
            return model.gco ?? "-"
        }
        return ""
    }

    func isDifferentValueColor(key: String) -> Bool {
        key == "ddi" || key == "pdd"
    }
}
