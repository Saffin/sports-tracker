import SwiftUI

enum SelectedStorage: String, CaseIterable, Identifiable {
    case all
    case local
    case remote
    
    var id: Self { self }
}

struct SportsListView: View {
    @StateObject var store: SportsListStore
    
    var body: some View {
        ZStack {
            Color.white
            if self.store.state.isLoading {
                ProgressView()
            } else {
                self.contentView
            }
        }
        .toolbar {
            self.toolbar
        }
        .task {
            await self.store.actions?.load()
        }
        .refreshable {
            await self.store.actions?.load()
        }
        .navigationTitle("Sports Tracker")
        .onChange(of: self.store.selectedType) { _, selectedSport in
            Task {
                await self.store.actions?.didTapFilterSports(selectedSport)
            }
        }
        .sheet(isPresented: self.$store.state.isCreateSheetPresented, onDismiss: {
            self.store.actions?.onSheetDismiss()
        }) {
            CreateSportView(
                store: CreateSportComposer.compose().store,
                onDismiss: self.store.actions?.onSheetDismiss ?? {}
            )
        }
        //        .alert(
        //            self.store.state.errorViewModel?.title ?? "Error",
        //            isPresented: self.$store.isErrorShown,
        //            actions: {
        //                ForEach(store.state.errorViewModel?.actions ?? [], id: \.title) { viewModel in
        //                    Button(viewModel.title,
        //                           role: viewModel.buttonRole,
        //                           action: viewModel.action ?? {}
        //                    )
        //                }
        //            },
        //            message: self.store.state.errorViewModel?.message ?? ""
        //        )
    }
}

private extension SportsListView {
    var contentView: some View {
        VStack {
            self.picker
                .padding()
            if self.$store.state.sports.isEmpty {
                Text("No records found. You can add one by pressing the plus button")
                    .padding()
            } else {
                self.list
            }
            Spacer()
        }
    }
    
    var picker: some View {
        VStack {
            Picker("", selection: self.$store.selectedType) {
                ForEach(SelectedStorage.allCases) { item in
                    Text(item.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    var list: some View {
        List {
            ForEach(self.store.state.sports) { item in
                Button {
                    self.store.actions?.didSelectDetail(item)
                } label: {
                    SportCell(model: item)
                }
                .buttonStyle(.plain)
            }
            .onDelete { index in
                self.store.actions?.didSelectDelete(index: index)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    var toolbar: some ToolbarContent {
        ToolbarItem {
            Button(
                action: {
                    self.store.actions?.didSelectAddSport()
                }
            ) {
                Label("Add record", systemImage: "plus")
            }
        }
    }
}

#Preview {
    let store = SportsListStore()
    SportsListView(store: store)
}
