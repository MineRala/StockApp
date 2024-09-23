//
//  PopoverViewModel.swift
//  StockApp
//
//  Created by Mine Rala on 22.09.2024.
//

import Foundation

protocol PopoverViewModelInterface: AnyObject {
    var numberOfRowsInSection: Int { get }
    var heightForRowAt: Double { get }
    
    func getSelectedViewOption() -> SelectedViewOption?
    func setSelectedViewOption(option: SelectedViewOption)
    func getDataName(index: Int) -> String
    func didSelectRowAt(index: Int)
}

final class PopoverViewModel {
    private weak var view: PopoverViewInterface?
    private var myPage = [MyPage]()
    private var selectedViewOption: SelectedViewOption?
    
    init(view: PopoverViewInterface, myPage: [MyPage]) {
        self.view = view
        self.myPage = myPage
    }
}

// MARK: - PopoverViewModelInterface
extension PopoverViewModel: PopoverViewModelInterface {
    var numberOfRowsInSection: Int {
        myPage.count
    }
    
    var heightForRowAt: Double {
        35
    }
    
    func setSelectedViewOption(option: SelectedViewOption) {
        selectedViewOption = option
    }
    
    func getSelectedViewOption() -> SelectedViewOption? {
        selectedViewOption
    }
    
    func getDataName(index: Int) -> String {
        myPage[index].name
    }
    
    func didSelectRowAt(index: Int) {
        guard let selectedViewOption else { return }
        
        if index < myPage.count {
            let selectedKey =  myPage[index].key
            let selectedName = myPage[index].name
            
            switch selectedViewOption {
            case .first:
                UserDefaultsManager.shared.setValue(valueKey: selectedKey, valueName: selectedName, forKey: "firstSelectedView")
            case .second:
                UserDefaultsManager.shared.setValue(valueKey: selectedKey, valueName: selectedName, forKey: "secondSelectedView")
            }
        }
    }
}
