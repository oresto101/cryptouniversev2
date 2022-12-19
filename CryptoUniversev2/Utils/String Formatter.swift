//
//  String Formatter.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 12/12/2022.
//

import Foundation

func formatPercentageToString(percentage: Double) -> String {
    if (percentage > 0) {
        return "+" + String(percentage) + "%"
    }
    return String(percentage) + "%"
}

func formatBalancePLAndPercentageToString(balance: Double, percentage: Double) -> String {
    return String(roundDoubles(val: balance)) + " (" + formatPercentageToString(percentage: roundDoubles(val: percentage)) + ")"
}

func roundDoubles(val: Double) -> Double {
    return round(val * 100) / 100
}
