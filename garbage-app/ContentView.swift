import SwiftUI
import SwiftData
import UniformTypeIdentifiers

@Observable
class ContentViewState {
    var item = Item.blank()
    var showEditView = false
    var isNewItem = true
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var itemState = ContentViewState()
    @State private var showExporter = false
    @State private var exportedSpreadsheet: CSVFile?
    private let exportedFileName = "Waste Composition Results.csv"

    var body: some View {
        NavigationStack {
            if items.count == 0 {
                VStack {
                    Image(uiImage: UIImage(named: "AppIcon")!)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 15)))
                    Text("Garbage App").font(.title)
                    Text("Add a new entry to get started").font(.subheadline)
                    Button(action: addItem) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Entry")
                        }
                    }.buttonStyle(.borderedProminent)
                }.padding(.top, 20)
            } else {
                List {
                    Section {
                        Button(action: addItem) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Entry")
                            }
                        }
                    }
                    Section("Records") {
                        ForEach(items) { item in
                            NavigationLink {
                                ItemView(item: item)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: item.category().icon)
                                                .foregroundStyle(.accent)
                                            Text(item.category().name)
                                                .foregroundStyle(.accent)
                                        }
                                        Text("\(item.timestamp.formatted())")
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                    Divider()
                                    Text(String(format: "%2.2f g", arguments: [item.weight]))
                                }
                            }
                            .swipeActions {
                                Button {
                                    itemState.item = item
                                    itemState.isNewItem = false
                                    itemState.showEditView = true
                                } label: {
                                    Label("Edit", systemImage: "square.and.pencil")
                                }
                                Button(role: .destructive) {
                                    modelContext.delete(item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        EditButton()
                            .disabled(items.count == 0)
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Button {
                                self.exportToCsv()
                            } label: {
                                Label("Export Spreadsheet", systemImage: "tablecells.badge.ellipsis")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }.disabled(items.count == 0)
                    }
                }
                .navigationTitle("Garbage App")
            }
        }
        .fullScreenCover(isPresented: $itemState.showEditView, content: {
            ItemEditView(item: $itemState.item) {
                withAnimation {
                    if itemState.isNewItem {
                        modelContext.insert(itemState.item)
                    }
                    itemState.item = Item.blank()
                    itemState.isNewItem = true
                }
            }
        })
        .fileExporter(isPresented: $showExporter, document: exportedSpreadsheet, contentType: .commaSeparatedText, defaultFilename: self.exportedFileName, onCompletion: { result in
            //
        })
    }

    private func addItem() {
        itemState.item = Item.blank()
        itemState.isNewItem = true
        itemState.showEditView.toggle()
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let entry = items[index]
                PhotoManager.deletePhoto(name: entry.imageName)
                modelContext.delete(items[index])
            }
        }
    }

    public func exportToCsv() {
        var csvData = "Record Date,Category,Weight (gram)\n"

        for item in items {
            let weight = String(format: "%2.2f", item.weight)
            csvData += "\(item.timestamp.ISO8601Format(.iso8601WithTimeZone())),\(item.category().name),\(weight)\n"
        }

        self.exportedSpreadsheet = CSVFile(initialText: csvData)
        self.showExporter = true
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
