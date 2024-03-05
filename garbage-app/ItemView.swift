import SwiftUI
import PDFKit

struct ItemView: View {
    let item: Item

    var body: some View {
        List {
            Section("Details") {
                HStack {
                    Text("Date").bold()
                    Spacer()
                    Text(item.timestamp.formatted())
                }
                HStack {
                    Text("Category").bold()
                    Spacer()
                    Text(item.category().name)
                }
                HStack {
                    Text("Weight").bold()
                    Spacer()
                    Text(String(format: "%2.2f", arguments: [item.weight]))
                }
            }
            .navigationTitle("Item")
            if let image = PhotoManager.getPhoto(name: item.imageName) {
                Section("Image") {
                    NavigationLink {
                        PDFKitRepresentedView(image: image)
                            .navigationTitle("Image")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 200, maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .circular))
                    }
                }
            }
        }
    }
}

#Preview {
    ItemView(item: Item(timestamp: Date(), category: WasteCategories[0], weight: 50.0))
}
