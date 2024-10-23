import SwiftUI
import CoreData
enum Selected: String, CaseIterable, Identifiable {
    case all
    case local
    case remote
    
    var id: Self { self }
}

struct SportsListView: View {
    @ObservedObject var store: SportsListStore
    
    var body: some View {
        VStack {
            Picker("All", selection: self.$store.selectedType) {
                ForEach(Selected.allCases) { item in
                    Text(item.rawValue)
                }
            }
            .pickerStyle(.segmented)
            List {
                ForEach(self.store.state.sports) { item in
                    NavigationLink {
                        Text("Item at \(item.id.uuidString)")
                    } label: {
                        SportCell(model: item)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(
                        action: {
                            self.store.actions?.didSelectAddSport()
                        }
                    ) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        .task {
            await self.store.actions?.onAppear()
        }
        .refreshable {
            await self.store.actions?.onAppear()
        }
        .navigationTitle("Sports Tracker")
        .onChange(of: self.store.selectedType) { _, selectedSport in
            self.store.actions?.didTapFilterSports(selectedSport)
        }
    }
}

struct SportCell: View {
    let model: SportModel
    
    var body: some View {
        VStack {
            HStack {
                Text(model.name)
                Spacer()
                Text(model.location)
                Spacer()
                Text(model.duration)
            }
        }.background(model.isLocal ? .red : .green)
    }
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
    let store = SportsListStore()
    SportsListView(store: store)
}
