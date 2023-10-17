//
//  Double.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation

/// An extension on `Double` providing a method for rounding to a specified number of decimal places.
extension Double {
    /// Rounds the double to the specified number of decimal places.
    ///
    /// - Parameters:
    ///   - fractionDigits: The number of decimal places to round to.
    /// - Returns: A new `Double` value rounded to the specified decimal places.
    ///
    /// - Example:
    ///   ```
    ///   let value = 3.14159265359
    ///   let roundedValue = value.roundToDecimal(2) // Returns 3.14
    ///
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
