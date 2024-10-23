import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject private var coordinator: SportsTrackerCoordinator = .init()
    
    var body: some View {
        NavigationStack(path: self.$coordinator.navigation) {
            self.coordinator.start()
                .navigationDestination(
                    for: SportsTrackerDestination.self) { destination in
                        self.coordinator.getView(for: destination)
                    }
        }
        .navigationTitle("Sports Tracker")
    }
}

#Preview {
    ContentView()
}
