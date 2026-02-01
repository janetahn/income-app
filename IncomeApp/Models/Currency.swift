//
//  Currency.swift
//  IncomeApp
//
//  Created by Janet Ahn on 2026-01-31.
//

import Foundation

enum Currency: Int, CaseIterable {
    case cad, usd, gb
    
    var title: String {
        switch self {
        case .cad:
            return "CAD"
        case .usd:
            return "USD"
        case .gb:
            return "GB"
        }
    }
    
    var locale: Locale {
        switch self {
        case .cad:
            return Locale(identifier: "en_CA")
        case .usd:
            return Locale(identifier: "en_US")
        case .gb:
            return Locale(identifier: "en_GB")
        }
    }
}
