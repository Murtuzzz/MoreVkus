import Foundation

class BasketManager {
    static let shared = BasketManager()
    
    // Notification names
    static let basketUpdatedNotification = "basketUpdated"
    static let productAddedNotification = "productAdded"
    static let productRemovedNotification = "productRemoved"
    static let productQuantityChangedNotification = "productQuantityChanged"
    
    private init() {
        // Load basket data from UserSettings if available
        loadBasketFromUserSettings()
    }
    
    // Dictionary to store products in basket with productId as key and quantity as value
    private var basketItems: [Int: Int] = [:]
    
    // Array to store BasketInfo arrays for compatibility with existing code
    private var basketInfoArray: [[BasketInfo]] = []
    
    // Add a product to the basket
    func addToBasket(product: CardInfo, quantity: Int = 1) {
        // Получаем текущее количество товара в корзине (если есть)
        var currentQuantity = basketItems[product.prodId] ?? 0
        currentQuantity += quantity
        basketItems[product.prodId] = currentQuantity
        
        // Update basketInfoArray
        updateBasketInfoArray(for: product, quantity: currentQuantity)
        
        // Save to UserSettings
        UserSettings.basketInfo = basketInfoArray
        
        // Post notification
        let userInfo: [String: Any] = [
            "productId": product.prodId,
            "quantity": currentQuantity,
            "action": currentQuantity == quantity ? "add" : "update"
        ]
        
        let notificationName = currentQuantity == quantity ? 
            BasketManager.productAddedNotification : 
            BasketManager.productQuantityChangedNotification
        
        NotificationCenter.default.post(name: Notification.Name(notificationName), object: nil, userInfo: userInfo)
        NotificationCenter.default.post(name: Notification.Name(BasketManager.basketUpdatedNotification), object: nil)
    }
    
    // Remove a product from the basket
    func removeFromBasket(productId: Int) {
        basketItems[productId] = nil
        
        // Remove from basketInfoArray
        if let index = basketInfoArray.firstIndex(where: { !$0.isEmpty && $0[0].id == productId }) {
            basketInfoArray[index] = []
        }
        
        // Save to UserSettings
        UserSettings.basketInfo = basketInfoArray
        
        // Post notification
        let userInfo: [String: Any] = [
            "productId": productId,
            "action": "remove"
        ]
        NotificationCenter.default.post(name: Notification.Name(BasketManager.productRemovedNotification), object: nil, userInfo: userInfo)
        NotificationCenter.default.post(name: Notification.Name(BasketManager.basketUpdatedNotification), object: nil)
    }
    
    // Update quantity for a product
    func updateQuantity(productId: Int, quantity: Int, maxAvailable: Int? = nil, categoty: Int) {
        guard quantity >= 0 else { return }
        
        if quantity == 0 {
            removeFromBasket(productId: productId)
            return
        }
        
        // Если указано максимальное количество, проверяем, не превышает ли новое количество максимальное
        if let maxAvailable = maxAvailable, quantity > maxAvailable {
            // Если превышает, устанавливаем максимальное количество
            basketItems[productId] = maxAvailable
        } else {
            basketItems[productId] = quantity
        }
        
        // Update basketInfoArray
        if let index = basketInfoArray.firstIndex(where: { !$0.isEmpty && $0[0].id == productId }) {
            let currentInfo = basketInfoArray[index][0]
            let finalQuantity = basketItems[productId] ?? quantity
            let maxCount = maxAvailable ?? currentInfo.prodCount
            
            basketInfoArray[index] = [
                BasketInfo(
                    title: currentInfo.title,
                    price: currentInfo.price,
                    quantity: finalQuantity,
                    id: currentInfo.id,
                    inBasket: true,
                    catId: currentInfo.catId,
                    inStock: currentInfo.inStock,
                    prodCount: maxCount
                )
            ]
        }
        
        // Save to UserSettings
        UserSettings.basketInfo = basketInfoArray
        
        // Post notification
        let userInfo: [String: Any] = [
            "productId": productId,
            "quantity": basketItems[productId] ?? quantity,
            "action": "update"
        ]
        NotificationCenter.default.post(name: Notification.Name(BasketManager.productQuantityChangedNotification), object: nil, userInfo: userInfo)
        NotificationCenter.default.post(name: Notification.Name(BasketManager.basketUpdatedNotification), object: nil)
    }
    
    // Check if a product is in the basket
    func isInBasket(productId: Int) -> Bool {
        return basketItems[productId] != nil
    }
    
    // Get quantity for a product
    func quantityForProduct(productId: Int) -> Int {
        return basketItems[productId] ?? 0
    }
    
    // Get total number of items in basket
    func totalItemsCount() -> Int {
        return basketItems.values.reduce(0, +)
    }
    
    // Get total price of all items in basket
    func totalPrice() -> Double {
        var total = 0.0
        for infoArray in basketInfoArray {
            if !infoArray.isEmpty {
                let info = infoArray[0]
                total += info.price * Double(info.quantity)
            }
        }
        return total
    }
    
    // Clear the entire basket
    func clearBasket() {
        basketItems.removeAll()
        basketInfoArray = []
        UserSettings.basketInfo = basketInfoArray
        NotificationCenter.default.post(name: Notification.Name(BasketManager.basketUpdatedNotification), object: nil)
    }
    
    // Load basket from UserSettings
    private func loadBasketFromUserSettings() {
        if let savedBasketInfo = UserSettings.basketInfo {
            basketInfoArray = savedBasketInfo
            
            // Rebuild basketItems from basketInfoArray
            basketItems.removeAll()
            for infoArray in savedBasketInfo {
                if !infoArray.isEmpty {
                    let info = infoArray[0]
                    basketItems[info.id] = info.quantity
                }
            }
        }
    }
    
    // Update basketInfoArray for a specific product
    private func updateBasketInfoArray(for product: CardInfo, quantity: Int) {
        // Try to find existing entry in basketInfoArray
        if let index = basketInfoArray.firstIndex(where: { !$0.isEmpty && $0[0].id == product.prodId }) {
            // Update existing entry
            let currentInfo = basketInfoArray[index][0]
            basketInfoArray[index] = [
                BasketInfo(
                    title: product.title,
                    price: Double(product.price),
                    quantity: quantity,
                    id: product.prodId,
                    inBasket: true,
                    catId: product.catId,
                    inStock: product.inStock,
                    prodCount: product.productCount
                )
            ]
        } else {
            // Add new entry
            // Find an empty slot or add to the end
            var addedToExistingSlot = false
            
            for (index, infoArray) in basketInfoArray.enumerated() {
                if infoArray.isEmpty {
                    basketInfoArray[index] = [
                        BasketInfo(
                            title: product.title,
                            price: Double(product.price),
                            quantity: quantity,
                            id: product.prodId,
                            inBasket: true,
                            catId: product.catId,
                            inStock: product.inStock,
                            prodCount: product.productCount
                        )
                    ]
                    addedToExistingSlot = true
                    break
                }
            }
            
            if !addedToExistingSlot {
                // Add at the end
                basketInfoArray.append([
                    BasketInfo(
                        title: product.title,
                        price: Double(product.price),
                        quantity: quantity,
                        id: product.prodId,
                        inBasket: true,
                        catId: product.catId,
                        inStock: product.inStock,
                        prodCount: product.productCount
                    )
                ])
            }
        }
    }
} 
