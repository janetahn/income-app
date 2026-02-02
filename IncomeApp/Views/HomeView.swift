//
//  HomeView.swift
//  IncomeApp
//
//  Created by Janet Ahn on 2026-01-25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @State private var showAddTransactionView = false
    @State private var showSettings = false
    @State private var transactionToEdit: TransactionItem?
    
    @AppStorage("orderDescending") var orderDescending = false
    @AppStorage("minimumTransaction") var minimumTransaction = 0.0
    @AppStorage("currencySelection") private var currencySelection: Currency = .cad
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<TransactionItem>
    
    private var displayTransactions: [TransactionItem] {
        let sortTransactions = orderDescending ? transactions.sorted(by: { $0.wrappedDate < $1.wrappedDate }) : transactions.sorted(by: { $0.wrappedDate > $1.wrappedDate })
        guard minimumTransaction > 0 else {
            return sortTransactions
        }
        let filteredTransactions = sortTransactions.filter({ $0.amount > minimumTransaction })
        return filteredTransactions
    }
    
    private var totalExpenses: String {
        let sumExpenses = transactions.filter({ $0.wrappedTransactionType == .expense }).reduce(0, { $0 + $1.wrappedAmount })
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currencySelection.locale
        return numberFormatter.string(from: sumExpenses as NSNumber) ?? "0.00"
    }
    
    private var totalIncomes: String {
        let sumIncomes = transactions.filter({ $0.wrappedTransactionType == .income }).reduce(0, { $0 + $1.wrappedAmount})
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currencySelection.locale
        return numberFormatter.string(from: sumIncomes as NSNumber) ?? "0.00"
    }
    
    private var totalBalance: String {
        let sumExpenses = transactions.filter({ $0.wrappedTransactionType == .expense }).reduce(0, { $0 + $1.wrappedAmount })
        let sumIncomes = transactions.filter({ $0.wrappedTransactionType == .income }).reduce(0, { $0 + $1.wrappedAmount})
        let total = sumIncomes - sumExpenses
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currencySelection.locale
        return numberFormatter.string(from: total as NSNumber) ?? "$0.00"
    }
    
    // only used in the HomeView so no need to make it a view itself
    // the view is not going to be reused
    fileprivate func FloatingButtion() -> some View {
        VStack {
            Spacer()
            NavigationLink {
                AddTransactionView()
            } label: {
                Text("+")
                    .font(.largeTitle)
                    .frame(width: 70, height: 70)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 7)
            }
            .background(Color.primaryGreen)
            .clipShape(Circle())
        }
    }
    
    fileprivate func BalanceView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primaryGreen)
            VStack (alignment: .leading, spacing: 8) {
                HStack {
                    VStack (alignment: .leading) {
                        Text("BALANCE")
                            .font(.caption)
                            .foregroundStyle(Color.white)
                        Text(totalBalance)
                            .font(.system(size: 42, weight: .light))
                            .foregroundStyle(Color.white)
                    }
                    Spacer()
                }
                .padding(.top)
                
                HStack (spacing: 25) {
                    VStack (alignment: .leading) {
                        Text("Expense")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.white)
                        Text(totalExpenses)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(Color.white)
                    }
                    VStack (alignment: .leading) {
                        Text("Income")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.white)
                        Text(totalIncomes)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(Color.white)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .frame(height: 150)
        .padding(.horizontal)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    BalanceView()
                    List {
                        ForEach(displayTransactions) { transaction in
                            Button {
                                transactionToEdit = transaction
                            } label: {
                                TransactionView(transaction: transaction)
                                    .foregroundStyle(Color.black)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .scrollContentBackground(.hidden)
                }
                FloatingButtion()
            }
            .navigationTitle("Income")
            .navigationDestination(item: $transactionToEdit, destination: { transactionToEdit in
                AddTransactionView(transactionToEdit: transactionToEdit)
            })
            .navigationDestination(isPresented: $showAddTransactionView, destination: {
                AddTransactionView()
            })
            .sheet(isPresented: $showSettings, content: {
                SettingsView()
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(Color.black)
                    }

                }
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let transactionToDelete = transactions[index]
            viewContext.delete(transactionToDelete)
        }
    }
}

#Preview {
    let dataManager = DataManager.sharedPreview
    return HomeView().environment(\.managedObjectContext, dataManager.container.viewContext)
}


