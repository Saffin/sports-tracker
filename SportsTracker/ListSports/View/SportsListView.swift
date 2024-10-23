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
                .onDelete { index in
                    self.store.actions?.didSelectDelete(index: index)
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

#Preview {
    let store = SportsListStore()
    SportsListView(store: store)
}
