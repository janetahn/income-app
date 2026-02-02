//
//  TransactionItem+CoreDataProperties.swift
//  IncomeApp
//
//  Created by Janet Ahn on 2026-02-01.
//
//

import Foundation
import CoreData


extension TransactionItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionItem> {
        return NSFetchRequest<TransactionItem>(entityName: "TransactionItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var amount: Double
    @NSManaged public var transactionType: Int16
    @NSManaged public var date: Date?

}

extension TransactionItem : Identifiable {

}

extension TransactionItem {
    var wrappedId: UUID {
        return id!
    }
    var wrappedTitle: String {
        return title ?? ""
    }
    var wrappedDate: Date {
        return date ?? Date()
    }
    var wrappedTransactionType: TransactionType {
        return TransactionType(rawValue: Int(transactionType)) ?? .expense
    }
    var wrappedAmount: Double {
        return amount
    }
    var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: wrappedDate)
    }
    func displayNumber(currency: Currency) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currency.locale
        return numberFormatter.string(from: amount as NSNumber) ?? "$0.00"
    }
}
