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
