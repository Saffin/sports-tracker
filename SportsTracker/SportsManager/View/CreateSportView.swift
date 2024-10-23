import Foundation
import SwiftUI

struct CreateSportView: View {
    @ObservedObject var store: CreateSportStore
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            self.contentView
                .padding()
                .navigationTitle("Add record")
                .toolbar {
                    self.toolbarButtons
                }
                .confirmationDialog(
                    "Pick a storage",
                    isPresented: self.$store.isConfirmationDialogPresented,
                    titleVisibility: .visible,
                    actions: {
                        self.confirmationButtons
                    }
                )
        }
    }
}

private extension CreateSportView {
    var contentView: some View {
        VStack {
            self.nameInput
                .padding()
            self.locationInput
                .padding()
            self.durationInput
                .padding()
            Spacer()
        }
    }

    var confirmationButtons: some View {
        Group {
            Button("Local") {
                Task {
                    try await self.store.actions?.didTapSave(storage: .local) {
                        self.onDismiss()
                    }
                }
            }
            
            Button("Remote") {
                Task {
                    try await self.store.actions?.didTapSave(storage: .remote) {
                        self.onDismiss()
                    }
                }
            }
        }
    }
    
    var toolbarButtons: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.onDismiss()
                }) {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.store.actions?.didTapSaveButton()
                }) {
                    Text("Save")
                }
                .disabled(self.store.state.isSaveButtonDisabled)
            }
        }
    }
    
    var nameInput: some View {
        InputView(
            text: Binding(
                get: { self.store.state.name },
                set: { text in
                    self.store.actions?.onNameChange(text)
                }
            ),
            placeholder: "Name",
            keyboardType: .alphabet
        )
    }
    
    var locationInput: some View {
        InputView(
            text: Binding(
                get: { self.store.state.location },
                set: { text in
                    self.store.actions?.onLocationChange(text)
                }
            ),
            placeholder: "Location",
            keyboardType: .alphabet
        )
    }
    
    var durationInput: some View {
        InputView(
            text: Binding(
                get: { store.state.duration },
                set: { text in
                    self.store.actions?.onDurationChange(text)
                }
            ),
            placeholder: "Duration",
            keyboardType: .numberPad
        )
    }
}

#Preview {
    CreateSportView(store: CreateSportStore(), onDismiss: {})
}
