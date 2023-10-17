//
//  AddView.swift
//  iExpense
//
//  Created by Paige Stephenson on 10/16/23.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var currencyCode = ""
    
    @ObservedObject var expenses: Expenses
//    ^^ adding a property to store an Expenses object. It doesn't create the object here, which is why you are using @ObservableObject rather than @StateObject. This allows you to pass the existing Expenses object from one view to another - they will both share the same object, and will both monitor it for changes.
    
    @Environment(\.dismiss) var dismiss
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount, currencyCode: currencyCode)
                    
                    expenses.items.append(item)
                    dismiss() 
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
