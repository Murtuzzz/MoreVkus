import Foundation

struct Config {
    #if targetEnvironment(simulator)
    // URL для симулятора
    static let baseURL = "http://127.0.0.1:5002"
    #else
    // URL для реального устройства
    static let baseURL = "http://192.168.31.49:5002"
    #endif
    
    static let productsURL = "\(baseURL)/api/products"
    //static let getURL = "\(baseURL)/get-url"
    static let getFishURL = "\(baseURL)/get-fish-url"
    static let getSausURL = "\(baseURL)/get-saus-url"
}
