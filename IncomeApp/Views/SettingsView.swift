//
//  SettingsView.swift
//  IncomeApp
//
//  Created by Janet Ahn on 2026-01-31.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("orderDescending") var orderDescending = false
    @AppStorage("currencySelection") private var currencySelection: Currency = .cad
    @AppStorage("minimumTransaction") var minimumTransaction = 0.0
    
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currencySelection.locale
        return numberFormatter
    }
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Toggle(isOn: $orderDescending) {
                        Text("Order \(orderDescending ? "(Earliest)" : "(Latest)")")
                    }
                }
                HStack {
                    Picker("Currency", selection: $currencySelection) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.title)
                        }
                    }
                }
                HStack {
                    Text("Minimum Filter")
                    TextField("", value: $minimumTransaction, formatter: numberFormatter)
                        .multilineTextAlignment(.trailing)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
