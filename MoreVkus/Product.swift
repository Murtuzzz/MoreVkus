import Foundation

// Product model conforming to both Decodable and Encodable
struct Product: Decodable, Encodable {
    let id: Int
    let name: String
    let description: String
    let price: String
    let inStock: Bool
    let productCount: Double
    let category: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case inStock = "in_stock"
        case productCount = "product_count"
        case quantity
        case category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        price = try container.decode(String.self, forKey: .price)
        inStock = try container.decode(Bool.self, forKey: .inStock)
        category = try container.decode(Int.self, forKey: .category)
        
        // Try to decode productCount, if not available try quantity, otherwise default to 0
        if let pCount = try? container.decode(Double.self, forKey: .productCount) {
            productCount = pCount
        } else if let quantity = try? container.decode(Double.self, forKey: .quantity) {
            productCount = quantity
        } else {
            productCount = 0
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(price, forKey: .price)
        try container.encode(inStock, forKey: .inStock)
        try container.encode(productCount, forKey: .productCount)
        try container.encode(category, forKey: .category)
    }
}