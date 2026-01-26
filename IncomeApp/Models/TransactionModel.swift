//
//  TransactionModel.swift
//  IncomeApp
//
//  Created by Janet Ahn on 2026-01-25.
//

import Foundation

struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let type: TransactionType
    let amount: Double
    let date: Date
}
