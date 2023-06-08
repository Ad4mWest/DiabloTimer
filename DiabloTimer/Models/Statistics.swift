//  Statistics.swift
//  DiabloTimer
//  Created by Adam West on 08.06.23.

import Foundation

final class UserDefaultsValues {
    
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case total
    }
    
    var totalTimeSegments: Int {
        get {
            return userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
}
