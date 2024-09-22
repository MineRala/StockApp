//
//  UserDefaultsManager.swift
//  StockApp
//
//  Created by Mine Rala on 21.09.2024.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    var firstSelectedViewKey: String? {
        return getValue(forKey: "firstSelectedView").0
    }
    
    var firstSelectedViewName: String? {
        return getValue(forKey: "firstSelectedView").1
    }
    
    var secondSelectedViewKey: String? {
        return getValue(forKey: "secondSelectedView").0
    }
    
    var secondSelectedViewName: String? {
        return getValue(forKey: "secondSelectedView").1
    }
    
    func getValue(forKey key: String) -> (String?, String?) {
        if let tupleArray = defaults.array(forKey: key) as? [String], tupleArray.count == 2 {
            return (tupleArray[0], tupleArray[1])
        }
        return (nil, nil)
    }
    
    func setValue(value1: String, value2: String, forKey key: String) {
        let tupleArray = [value1, value2]
        defaults.set(tupleArray, forKey: key)
        
        NotificationCenter.default.post(name: .userDefaultsDidChange, object: nil, userInfo: [key: tupleArray])
        UserDefaults.standard.synchronize()
    }
    
    func setDefaultValues(firstSelectedViewKey: String, firstSelectedViewName: String, secondSelectedViewKey: String, secondSelectedViewName: String) {
        let firstTuple = [firstSelectedViewKey, firstSelectedViewName]
        let secondTuple = [secondSelectedViewKey, secondSelectedViewName]
        defaults.set(firstTuple, forKey: "firstSelectedView")
        defaults.set(secondTuple, forKey: "secondSelectedView")
        NotificationCenter.default.post(name: .userDefaultsDidChange, object: nil, userInfo: ["firstSelectedView": firstTuple, "secondSelectedView": secondTuple])
        UserDefaults.standard.synchronize()
    }
    
    func isInitialUserDefaultsEmpty() -> Bool {
        let firstTupleExists = defaults.array(forKey: "firstSelectedView") != nil
        let secondTupleExists = defaults.array(forKey: "secondSelectedView") != nil
        
        return !firstTupleExists && !secondTupleExists
    }
}

extension Notification.Name {
    static let userDefaultsDidChange = Notification.Name("userDefaultsDidChange")
}
