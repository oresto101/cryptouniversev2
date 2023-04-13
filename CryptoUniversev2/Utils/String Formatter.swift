import Foundation

func formatPercentageToString(percentage: Double) -> String {
    if percentage > 0 {
        return "+" + String(percentage) + "%"
    }
    return String(percentage) + "%"
}

func formatBalancePLAndPercentageToString(balance: Double, percentage: Double) -> String {
    String(roundDoubles(val: balance)) + " (" +
        formatPercentageToString(percentage: roundDoubles(val: percentage)) + ")"
}

func roundDoubles(val: Double) -> Double {
    round(val * 100) / 100
}
