//
//  TransactionView.swift
//  IncomeApp
//
//  Created by Janet Ahn on 2026-01-25.
//

import SwiftUI

struct TransactionView: View {
    let transaction: Transaction
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("date")
                    .font(.system(size: 14))
                Spacer()
            }
            .padding(.vertical, 5)
            .background(Color.primaryLightGray)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            HStack {
                Image(systemName: transaction.type == .income ? "arrow.up.forward" : "arrow.down.forward")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(transaction.type == .income ? Color.green : Color.red)
                VStack (alignment: .leading) {
                    HStack {
                        Text(transaction.title)
                            .font(.system(size: 15, weight: .bold))
                        Spacer()
                        Text("CAD $5.00")
                            .font(.system(size: 15, weight: .bold))
                    }
                    Text("Completed")
                        .font(.system(size: 14))
                }
            }
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    TransactionView(transaction: Transaction(title: "Apple", type: .expense, amount: 5.00, date: Date()))
}
