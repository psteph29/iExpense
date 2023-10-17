//
//  ContentView.swift
//  iExpense
//
//  Created by Paige Stephenson on 10/16/23.
//

import SwiftUI

//Create something to store an array of expense items inside a single object. Use published to make sure change announcements get sent whenever the items array gets modified.
//Where you store all the expense item structs that have been created, and that is also where you attach the property observer to write out changes as they happen
class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]()
    func didSet() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "Items")
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
                
//                the data(forKey: "Items") line attempts to read whatever is in "Items" as a Data object
//                try? JSONDecoder().decode... does the actual job of unarchiving the Data object into an array of ExpenseItem objects.
//                Use .self after [ExpenseItem] to say that you mean you are referring to the type itself, the type object. Otherwise swift would be wondering if we were trying to make a copy of the class, or if we were planning to reference a static property or method, maybe an instance of the class...
            }
        }
        items = []
    }
}

struct ContentView: View {
//    Add an @StateObject property in the view to create an instance of the Expenses class
//    Using @StateObject assks SwiftUI to watch the object for any change announcments, so any time one of the @Published properties changes the view will refresh its body.
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    

    var body: some View {
        NavigationView {
            List {
//                ForEach(expenses.items, id: \.name) { item in
//                    Text(item.name)
//                    This tells the ForEach to identify each expense item uniquely by its name, then prints the name out as the list row.
//                }
//                Now that you made a UUID, we can write the ForEach this way:
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text(item.amountFormatted)
                            .foregroundColor(textColor(forAmount: item.amount))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
//                    let expense = ExpenseItem(name: "Test Expense", type: "Test Type", amount: 10)
//                    expenses.items.append(expense)
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses)
        }
    }
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func textColor(forAmount amount: Double) -> Color {
        if amount < 10 {
               return Color.gray
           } else if amount >= 10 && amount < 100 {
               return Color.yellow
           } else {
               return Color.red
           }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
