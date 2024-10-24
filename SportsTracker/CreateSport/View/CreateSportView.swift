import Foundation
import SwiftUI

struct CreateSportView: View {
    @ObservedObject var store: CreateSportStore
    let onDismiss: () -> Void
    
    let hours = Array(0...12)
    let minutes = Array(0...59)
    
    var body: some View {
        NavigationStack {
            self.contentView
                .padding()
                .frame(maxWidth: .infinity)
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
        VStack(spacing: 32) {
            Text("Create Sports Record")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            
            self.nameInput
            self.locationInput
            self.pickerInput
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
            placeholder: "Name"
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
            placeholder: "Location"
        )
    }
    
    var pickerInput: some View {
        HStack {
            VStack {
                Text("Hours")
                    .font(.headline)
                Picker(
                    "Hours",
                    selection: Binding(
                        get: { self.store.state.selectedHours },
                        set: { text in
                            self.store.actions?.onHoursChange(text)
                        }
                    )) {
                        ForEach(minutes, id: \.self) { minute in
                            Text("\(minute) m")
                        }
                    }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
            }
            
            VStack {
                Text("Minutes")
                    .font(.headline)
                Picker(
                    "Minutes",
                    selection: Binding(
                        get: { self.store.state.selectedMinutes },
                        set: { text in
                            self.store.actions?.onMinutesChange(text)
                        }
                    )) {
                        ForEach(minutes, id: \.self) { minute in
                            Text("\(minute) m")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100)
            }
        }
    }
}

#Preview {
    CreateSportView(store: CreateSportStore(), onDismiss: {})
}
