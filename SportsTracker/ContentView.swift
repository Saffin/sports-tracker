//
//  ContentView.swift
//  SportsTracker
//
//  Created by David Šafarik on 23.10.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    private let sportsManagerLocal = SportsManagerLocal()
    @State private var items: [SportModel] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.id.uuidString)")
                    } label: {
                        Text(item.name)
                    }
                }
                //                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(
                        action: {
                            Task {
                                try! await self.sportsManagerLocal.save(
                                    SportModel(
                                        id: UUID(),
                                        name: "name",
                                        location: "location",
                                        duration: "duration"
                                    )
                                )
                                    try await self.items = self.sportsManagerLocal.getAll()
                            }
                        }
                    ) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
        .task {
            self.items = try! await self.sportsManagerLocal.getAll()
        }
    }
    
    //    private func addItem() {
    //        withAnimation {
    //            let newItem = ManagedSport(context: viewContext)
    //            newItem.id = UUID()
    //            newItem.duration = "asd"
    //            newItem.location = "location"
    //            newItem.name = "name"
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
}

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}

#Preview {
    ContentView()
}
