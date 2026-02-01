//
//  TransactionModel.swift
//  IncomeApp
//
//  Created by Janet Ahn on 2026-01-25.
//

import Foundation

struct Transaction: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let type: TransactionType
    let amount: Double
    let date: Date
    
    var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    func displayNumber(currency: Currency) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currency.locale
        return numberFormatter.string(from: amount as NSNumber) ?? "$0.00"
    }
}
