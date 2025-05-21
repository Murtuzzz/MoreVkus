//
//  UserSettings.swift
//  FishShop
//
//  Created by Мурат Кудухов on 26.03.2024.
//

import Foundation

struct BasketInfo: Codable {
    let title: String
    let price: Double
    var quantity: Int
    let id: Int
    var inBasket: Bool
    let catId: Int
    let inStock: Bool
    let prodCount: Int
    var orderTime: String = ""
    
    static func == (lhs: BasketInfo, rhs: BasketInfo) -> Bool {
            return lhs.id == rhs.id && lhs.title == rhs.title
        }
}

struct StoreData: Codable {
    let id: Int
    let title: String
    let description: String
    let price: String
    let inStock: Bool
    var quantity: Int
    let categoryId: Int
    
}

struct Adress: Codable {
    var adress: String
    var latitude: Double
    var longitude: Double
}

class UserSettings {
    
    private enum SettingsKeys: String {
        case basketInfo
        case deletedFromBasketNow
        case unavailableProducts
        case basketProdQuant
        case address
        case orderPaid
        case orderInfo
        case activeOrder
        case orderCanceled
        case orderSum
        case ordersHistory
        case userLocation
        case isLocChanging
        case storeData
        case dataFromStore
        case orderDelivered
        case currentController
    }
    
    static var dataFromStore: [[String: Any]]? {
        get {
            guard let data = UserDefaults.standard.data(forKey: SettingsKeys.dataFromStore.rawValue) else { return nil }
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: SettingsKeys.dataFromStore.rawValue)
                return
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: newValue, options: [])
                UserDefaults.standard.set(data, forKey: SettingsKeys.dataFromStore.rawValue)
            } catch {
            }
        }
    }
    
    static var basketInfo: [[BasketInfo]]! {
        get {
            guard let data = UserDefaults.standard.data(forKey: SettingsKeys.basketInfo.rawValue) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode([[BasketInfo]].self, from: data)
        } set {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(newValue)
            UserDefaults.standard.set(encoded, forKey: SettingsKeys.basketInfo.rawValue)
        }
    }
    
    static var unavailableProducts: [[BasketInfo]]! {
        get {
            guard let data = UserDefaults.standard.data(forKey: SettingsKeys.unavailableProducts.rawValue) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode([[BasketInfo]].self, from: data)
        } set {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(newValue)
            UserDefaults.standard.set(encoded, forKey: SettingsKeys.unavailableProducts.rawValue)
        }
    }
    
    static var storeData: [[StoreData]]! {
        get {
            guard let data = UserDefaults.standard.data(forKey: SettingsKeys.storeData.rawValue) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode([[StoreData]].self, from: data)
        } set {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(newValue)
            UserDefaults.standard.set(encoded, forKey: SettingsKeys.storeData.rawValue)
        }
    }
    
    static var userLocation: [String: String]? {
        get {
            guard let data = UserDefaults.standard.data(forKey: SettingsKeys.userLocation.rawValue) else { return nil }
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: SettingsKeys.userLocation.rawValue)
                return
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: newValue, options: [])
                UserDefaults.standard.set(data, forKey: SettingsKeys.userLocation.rawValue)
            } catch {
                print("Ошибка при сохранении данных: \(error.localizedDescription)")
            }
        }
    }
    
    static var currentController: Int! {
        get {
            return UserDefaults.standard.integer(forKey: SettingsKeys.currentController.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.currentController.rawValue
            if let today = newValue {
                defaults.set(today, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var orderDelivered: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.orderDelivered.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.orderDelivered.rawValue
            if let today = newValue {
                defaults.set(today, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var isLocChanging: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.isLocChanging.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.isLocChanging.rawValue
            if let today = newValue {
                defaults.set(today, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var orderSum: Double! {
        get {
            return UserDefaults.standard.double(forKey: SettingsKeys.orderSum.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.orderSum.rawValue
            if let today = newValue {
                defaults.set(today, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var ordersHistory: [[[BasketInfo]]]! {
        get {
            guard let data = UserDefaults.standard.data(forKey: SettingsKeys.ordersHistory.rawValue) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode([[[BasketInfo]]].self, from: data)
        } set {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(newValue)
            UserDefaults.standard.set(encoded, forKey: SettingsKeys.ordersHistory.rawValue)
        }
    }
    
    static var activeOrder: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.activeOrder.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.activeOrder.rawValue
            if let today = newValue {
                defaults.set(today, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var orderCanceled: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.orderCanceled.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.orderCanceled.rawValue
            if let today = newValue {
                defaults.set(today, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var orderPaid: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.orderPaid.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.orderPaid.rawValue
            if let today = newValue {
                defaults.set(today, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var orderInfo: [[BasketInfo]]! {
        get {
            guard let data = UserDefaults.standard.data(forKey: SettingsKeys.orderInfo.rawValue) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode([[BasketInfo]].self, from: data)
        } set {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(newValue)
            UserDefaults.standard.set(encoded, forKey: SettingsKeys.orderInfo.rawValue)
        }
    }
    
}
