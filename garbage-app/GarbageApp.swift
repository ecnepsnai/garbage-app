import SwiftUI
import SwiftData

@main
struct GarbageApp: App {
    var sharedModelContainer: ModelContainer = {
        LoadWasteCategoryMap()

        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView().onAppear {
                PhotoManager.setup()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
