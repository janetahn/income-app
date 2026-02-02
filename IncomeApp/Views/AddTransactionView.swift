//
//  AddTransactionView.swift
//  IncomeApp
//
//  Created by Janet Ahn on 2026-01-26.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var amount = 0.0
    @State private var selectedTransactionType: TransactionType = .expense
    @State private var transactionTitle = ""
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    var transactionToEdit: TransactionItem?
    
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        return numberFormatter
    }
    
    var body: some View {
        VStack {
            TextField("0.00", value: $amount, formatter: numberFormatter)
                .font(.system(size: 60, weight: .thin))
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
            Rectangle()
                .fill(Color(uiColor: .lightGray))
                .frame(height: 0.5)
                .padding(.horizontal)
            Picker("Choose Type", selection: $selectedTransactionType) {
                ForEach(TransactionType.allCases) { transactionType in
                    Text(transactionType.title)
                        .tag(transactionType)
                }
            }
            TextField("Title", text: $transactionTitle)
                .font(.system(size: 15))
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 30)
                .padding(.top)
            Button {
                guard transactionTitle.count >= 2 else {
                    alertTitle = "Invalid Title"
                    alertMessage = "Title must be longer than 2 characters."
                    showAlert = true
                    return
                }
                if let transactionToEdit = transactionToEdit {
                    transactionToEdit.title = transactionTitle
                    transactionToEdit.transactionType = Int16(selectedTransactionType.rawValue)
                    transactionToEdit.amount = amount
                    
                    do {
                        try viewContext.save()
                    } catch {
                        alertTitle = "Something went wrong"
                        alertMessage = "Couldn't update Transaction"
                        showAlert = true
                        return
                    }
                } else {
                    let transaction = TransactionItem(context: viewContext)
                    transaction.id = UUID()
                    transaction.title = transactionTitle
                    transaction.transactionType = Int16(selectedTransactionType.rawValue)
                    transaction.amount = amount
                    transaction.date = Date()
                    
                    do {
                        try viewContext.save()
                    } catch {
                        alertTitle = "Something went wrong"
                        alertMessage = "Could not save new Transaction"
                        showAlert = true
                        return
                    }
                }
                
                dismiss()
            } label: {
                Text(transactionToEdit == nil ? "Create" : "Update")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.primaryGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .padding(.top)
            .padding(.horizontal, 30)
            Spacer()
        }
        .onAppear(perform: {
            if let transactionToEdit = transactionToEdit {
                amount = transactionToEdit.amount
                transactionTitle = transactionToEdit.wrappedTitle
                selectedTransactionType = transactionToEdit.wrappedTransactionType
            }
        })
        .padding(.top)
        .alert(alertTitle, isPresented: $showAlert) {
            
        } message: {
            Text(alertMessage)
        }

    }
}

#Preview {
    let dataManager = DataManager.sharedPreview
    return AddTransactionView().environment(\.managedObjectContext, dataManager.container.viewContext)
}
