import Foundation

public struct WasteCategory: Hashable, Codable {
    public let id: String
    public var name: String
    public let icon: String
    public let subcategories: [WasteCategory]

    init(id: String, name: String, icon: String, subcategories: [WasteCategory] = []) {
        self.id = id
        self.name = name
        self.icon = icon
        self.subcategories = subcategories
    }
}

public let WasteCategories: [WasteCategory] = [
    WasteCategory(id: "74e082b2-938f-4c0f-9856-3be4893e2f79", name: "General", icon: "square.filled.on.square", subcategories: [
        WasteCategory(id: "8756ecfd-77ee-46bf-bdd0-0ba12ae3201a", name: "Organic", icon: "tree.fill"),
        WasteCategory(id: "beaea53d-37ff-4261-8628-fa728c990048", name: "Mixed paper", icon: "book.pages.fill"),
        WasteCategory(id: "366ba2ec-d1db-48be-80b4-f9a61a55980e", name: "Thick cardboard", icon: "shippingbox.fill"),
        WasteCategory(id: "c57ee6e7-0810-4c3e-8cb4-e085c095b9f9", name: "Textile", icon: "tshirt.fill"),
    ]),
    WasteCategory(id: "4bfb8b66-a6d0-44f3-8db9-6a00e80d682c", name: "Mixed container", icon: "waterbottle.fill", subcategories: [
        WasteCategory(id: "f69e4447-5a35-492b-93d9-9e42c9e2b776", name: "Glass", icon: "wineglass.fill"),
        WasteCategory(id: "541a6bcf-daf7-40d7-a85e-c615082d3aef", name: "Other", icon: "questionmark.circle.fill"),
    ]),
    WasteCategory(id: "f6958db2-719e-4b1c-b52e-93bae8b2add0", name: "Hazardous", icon: "exclamationmark.triangle.fill", subcategories: [
        WasteCategory(id: "13407dc4-d995-4ff5-b47e-2702d9b680d6", name: "Medical", icon: "cross.case.fill"),
        WasteCategory(id: "c36ea42d-b5c6-45f7-b701-8d9e6f3c4167", name: "E-Waste", icon: "gamecontroller.fill"),
        WasteCategory(id: "f0a163a9-db5e-4e49-aff1-2f41ceaddbed", name: "Battery & Light Bulb", icon: "battery.50percent"),
        WasteCategory(id: "a526872b-2b19-495f-90f3-32a8bd15d3ec", name: "Other", icon: "questionmark.circle.fill"),
    ]),
    WasteCategory(id: "27ba060b-20ef-48d6-b455-ecde9c0fa3b9", name: "Other organic or inorganic", icon: "questionmark.circle.fill", subcategories: [
        WasteCategory(id: "a3034750-8881-4e29-8fc5-c65c83b67bbf", name: "Plastics", icon: "bag.fill"),
        WasteCategory(id: "06eb30fa-5ff5-4a1b-ba00-3f34b342bbc0", name: "Other", icon: "questionmark.circle.fill"),
    ]),
]

public var WasteCategoryMap: [String:WasteCategory] = [:]

public func LoadWasteCategoryMap() {
    for category in WasteCategories {
        WasteCategoryMap[category.id] = category
        for var subcategory in category.subcategories {
            subcategory.name = "\(category.name) / \(subcategory.name)"
            WasteCategoryMap[subcategory.id] = subcategory
        }
    }
}
