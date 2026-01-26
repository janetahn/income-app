//
//  TransactionType.swift
//  IncomeApp
//
//  Created by Janet Ahn on 2026-01-25.
//

import Foundation

enum TransactionType: String, CaseIterable, Identifiable {
    case income, expense
    var id: Self { self }
    
    var title: String {
        switch self {
        case .income:
            return "Income"
        case.expense:
            return "Expense"
        }
    }
}
