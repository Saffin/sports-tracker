import SwiftUI

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
        .task {
            // just to simulate the login process
            // and make it easy
            await self.coordinator.logIn()
        }
    }
}

#Preview {
    ContentView()
}
