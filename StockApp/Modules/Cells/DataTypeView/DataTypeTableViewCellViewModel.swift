//
//  DataTypeTableViewCellViewModel.swift
//  StockApp
//
//  Created by Mine Rala on 22.09.2024.
//

import Foundation

protocol DataTypeTableViewCellViewModelInterface: AnyObject  {
    func isCheckmarkIconVisible(dataType: String, selectedViewOption: SelectedViewOption) -> Bool
}

final class DataTypeTableViewCellViewModel {
    private weak var view: DataTypeTableViewCellInterface?
    
    init(view: DataTypeTableViewCellInterface) {
        self.view = view
    }
}

// MARK: - DataTypeTableViewCellViewModelInterface
extension DataTypeTableViewCellViewModel: DataTypeTableViewCellViewModelInterface {
    func isCheckmarkIconVisible(dataType: String, selectedViewOption: SelectedViewOption) -> Bool {
        let retrievedValue: String?
        
        switch selectedViewOption {
        case .first:
            retrievedValue = UserDefaultsManager.shared.firstSelectedViewName
        case .second:
            retrievedValue = UserDefaultsManager.shared.secondSelectedViewName
        }
        return !(retrievedValue == dataType)
    }
}
