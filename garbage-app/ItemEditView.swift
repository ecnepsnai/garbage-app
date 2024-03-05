import SwiftUI

@Observable
private class ItemEditViewError {
    var error = ""
    var showError = false
}

struct ItemEditView: View {
    public var item: Binding<Item>
    public let onSave: () -> Void
    @State private var weightStr = ""
    @State private var invalidWeight = false
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var errorState = ItemEditViewError()
    @Environment(\.dismiss) private var dismiss
    @State private var showCategoryList = false

    var body: some View {
        NavigationStack {
            List {
                Section("Details") {
                    Button {
                        self.showCategoryList = true
                    } label: {
                        HStack {
                            Text("Category")
                            Spacer()
                            HStack {
                                Image(systemName: item.wrappedValue.category().icon)
                                Text(item.wrappedValue.category().name)
                            }.foregroundStyle(.accent)
                        }
                    }.buttonStyle(.plain)
                    HStack {
                        Text("Weight")
                        Spacer()
                        TextField("Weight", text: $weightStr, prompt: Text("0.00"))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .foregroundStyle(invalidWeight ? Color.red : Color.primary)
                        Text("g")
                            .foregroundStyle(.gray)
                    }
                }
                Section("Picture") {
                    Button {
                        showCamera = true
                    } label: {
                        Label("Take a Picture", systemImage: "camera.circle.fill")
                    }
                    Button {
                        showImagePicker = true
                    } label: {
                        Label("Select a Picture", systemImage: "photo.circle.fill")
                    }
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 200, maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .circular))
                            .overlay {
                                Button {
                                    PhotoManager.deletePhoto(name: self.item.wrappedValue.imageName)
                                    self.selectedImage = nil
                                    self.item.wrappedValue.imageName = nil
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .tint(.red)
                                        .clipShape(Circle())
                                }
                                .position(x: 0, y: 0)
                            }
                            .padding()
                    }
                }
                Section {
                    Button {
                        saveItem()
                    } label: {
                        Label("Save Item", systemImage: "square.and.arrow.down.fill")
                    }
                    .disabled(invalidWeight)
                }
            }
            .navigationTitle("Edit Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveItem()
                    } label: {
                        Text("Save").bold()
                    }
                    .disabled(invalidWeight)
                }
            }
            .onAppear {
                if item.wrappedValue.weight > 0 {
                    weightStr = String(format: "%2.2f", arguments: [item.wrappedValue.weight])
                } else {
                    invalidWeight = true
                }

                if let image = PhotoManager.getPhoto(name: item.wrappedValue.imageName) {
                    self.selectedImage = image
                }
            }
            .onChange(of: weightStr) { oldValue, newValue in
                if let weight = Float32(newValue) {
                    item.wrappedValue.weight = weight
                    invalidWeight = false
                } else {
                    invalidWeight = true
                }
            }
            .fullScreenCover(isPresented: $showImagePicker, content: {
                ImagePickerView(selectedImage: $selectedImage, sourceType: .photoLibrary)
            })
            .fullScreenCover(isPresented: $showCamera, content: {
                ImagePickerView(selectedImage: $selectedImage, sourceType: .camera)
            })
            .fullScreenCover(isPresented: $showCategoryList, content: {
                CategoryListView { categoryId in
                    item.wrappedValue.categoryId = categoryId
                }
            })
            .alert("Error saving item", isPresented: $errorState.showError) {
                Button {
                    //
                } label: {
                    Text("Dismiss")
                }
            } message: {
                Text(errorState.error)
            }
        }
    }

    func saveItem() {
        do {
            if let image = selectedImage {
                let imageName = try PhotoManager.addPhoto(image: image)
                item.wrappedValue.imageName = imageName
            }
            dismiss()
            onSave()
        } catch {
            errorState.error = error.localizedDescription
            errorState.showError = true
        }
    }
}

#Preview {
    ItemEditView(item: .constant(Item(timestamp: Date(), category: WasteCategories[0], weight: 0.0)), onSave: {
        //
    })
}
