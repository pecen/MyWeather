//
//  StringExtensions.swift
//  MyWeather
//
//  Created by Peter Centellini on 2018-11-16.
//  Copyright © 2018 redesajn interactive solutions ab. All rights reserved.
//

import Foundation

extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    // The following code is just another way of doing it, i.e. the following code
    // does the same as firstUppercased above
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func isNumeric() -> Bool {
        return Double(self) != nil
    }
    
    func removeLast2Chars() -> Substring {
        let endIndex = self.index(self.endIndex, offsetBy: -2)
        return self[..<endIndex]
    }
}

extension Substring {
    func isNumeric() -> Bool {
        return Double(self) != nil
    }
}
