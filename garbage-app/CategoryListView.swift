import SwiftUI

struct CategoryListView: View {
    public let save: (String) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(WasteCategories, id:\.self) { category in
                    Section(category.name) {
                        ForEach(category.subcategories, id:\.self) { subcategory in
                            HStack {
                                Label(subcategory.name, systemImage: subcategory.icon)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .opacity(0.5)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.dismiss()
                                self.save(subcategory.id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        self.dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
    }
}

#Preview {
    CategoryListView { _ in
        //
    }
}
