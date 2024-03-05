import Foundation
import SwiftData

@Model
final class Item {
    var id: UUID
    var timestamp: Date
    var categoryId: String
    var weight: Float32
    var imageName: String?

    init(timestamp: Date, categoryId: String, weight: Float32, imageName: String? = nil) {
        self.id = UUID()
        self.timestamp = timestamp
        self.categoryId = categoryId
        self.weight = weight
    }

    convenience init(timestamp: Date, category: WasteCategory, weight: Float32, imageName: String? = nil) {
        self.init(timestamp: timestamp, categoryId: category.id, weight: weight, imageName: imageName)
    }

    static func blank() -> Item {
        return Item(timestamp: Date(), categoryId: WasteCategories[0].subcategories[0].id, weight: 0.0)
    }

    func category() -> WasteCategory {
        return WasteCategoryMap[self.categoryId]!
    }
}
