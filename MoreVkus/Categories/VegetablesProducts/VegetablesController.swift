//
//  VegetablesController.swift
//  MoreVkus
//
//  Created by Мурат Кудухов on 21.05.2025.
//

import UIKit
import SystemConfiguration
import Foundation
import Darwin.POSIX.netdb
import Darwin.POSIX.net

class VegetablesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!
    private var basketInfoArray: [[BasketInfo]] = []
    private var isJsonLoaded: Bool = false
    private var isProdDeletedNow: Bool = true
    //let basketController = BasketController()
    
    private var displayDataSource = [CardInfo]()
     

    // Получаем текущую дату и время
    let currentTime: DateFormatter = {
        let date = DateFormatter()
        date.dateFormat = "HH:mm:ss"
        return date
    }()



    private var unavailableProducts = [[BasketInfo]]() {
        didSet {
        }
    }
    private var unavailableInd: [Int] = []
    private var basketInfo = [[BasketInfo]]()
    private var storeProducts: [[String:Any]] = [[:]]

    private let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bgScreen")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()

    private let profileView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.barBg.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()

    private let emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.barBg
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()

    private let emptyView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.barBg
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()

    private var cardsData:[CardInfo] = []
    
    // ActivityIndicator для отображения загрузки
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }()


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshAllProducts()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupUI()
        setupNotifications()
        setupInitialState()
        loadProductsFromAPI()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VegetablesCollectionCell.self, forCellWithReuseIdentifier: VegetablesCollectionCell.id)
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
    }
    
    private func setupUI() {
        view.backgroundColor = R.Colors.background
        title = "Молочные продукты"
        
        view.addSubview(backgroundImage)
        view.addSubview(profileView)
        view.addSubview(activityIndicator)
        
        // Activity indicator constraints
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        setupConstraints()
    }
    
    private func loadProductsFromAPI() {
        // Show activity indicator
        activityIndicator.startAnimating()
        
        // Список URL для попытки подключения
        let urls = [
            Config.getFishURL,  // Основной URL
            Config.productsURL, // Альтернативный эндпоинт
        ]
        
        // Check direct URL access to each URL for debugging
        for urlString in urls {
            testDirectUrlAccess(url: urlString)
        }
        
        // Try to get the device IP for better debugging
        print("Running on device with network interfaces:")
        printAvailableNetworkInterfaces()
        
        // Try all URLs sequentially until one works
        tryNextUrl(urls: urls, index: 0)
    }

    private func tryNextUrl(urls: [String], index: Int) {
        guard index < urls.count else {
            // We've tried all URLs without success
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                
                let alert = UIAlertController(
                    title: "Error",
                    message: "Failed to connect to any server. Please check your network settings.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
            return
        }
        
        let urlString = urls[index]
        print("Trying URL: \(urlString)")
        
        // Make API request
        fetchProducts(from: urlString, urls: urls, index: index)
    }

    private func fetchProducts(from urlString: String, urls: [String], index: Int) {
        guard index < urls.count else {
            print("All URLs failed")
            return
        }
        
        NetworkService.shared.fetchProducts(from: urlString) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                // Фильтруем продукты по категории 3
                let filteredProducts = products.filter { $0.category == 5 }
                
                // Convert API products to CardInfo format
                let cardInfoArray = filteredProducts.map { product in
                    return CardInfo(
                        image: "\(product.name)", // Используем имя продукта для изображения
                        discription: product.description,
                        price: Int(Double(product.price) ?? 0),
                        title: product.name,
                        prodId: product.id,
                        catId: product.category,
                        productCount: Int(product.productCount),
                        inStock: product.inStock
                    )
                }
                
                // Update UI on main thread
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.activityIndicator.stopAnimating()
                    self.cardsData = cardInfoArray
                    self.displayDataSource = cardInfoArray
                    
                    // Синхронизируем с текущим состоянием корзины
                    let basketMap = self.createBasketMap()
                    for i in 0..<self.displayDataSource.count {
                        let productId = self.displayDataSource[i].prodId
                        if let quantity = basketMap[productId] {
                            self.displayDataSource[i].prodCount = quantity
                            self.displayDataSource[i].isInBasket = quantity > 0
                            
                            // Также обновляем cardsData
                            if let cardIndex = self.cardsData.firstIndex(where: { $0.prodId == productId }) {
                                self.cardsData[cardIndex].prodCount = quantity
                                self.cardsData[cardIndex].isInBasket = quantity > 0
                            }
                        }
                    }
                    
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                print("Error fetching products from \(urlString): \(error)")
                
                // Try the next URL
                self.tryNextUrl(urls: urls, index: index + 1)
            }
        }
    }

    private func testDirectUrlAccess(url urlString: String) {
        // Simple test to check if the URL is accessible
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Direct URL access error for \(urlString): \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status code for \(urlString): \(httpResponse.statusCode)")
            }
            
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                print("Direct URL access successful for \(urlString). Sample data: \(String(jsonString.prefix(100)))...")
            }
        }.resume()
    }

    // Utility function to print available network interfaces
    private func printAvailableNetworkInterfaces() {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else {
            print("Failed to get network interfaces")
            return
        }
        defer { freeifaddrs(ifaddr) }
        
        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            
            guard let interface = ptr?.pointee else { continue }
            let name = String(cString: interface.ifa_name)
            
            // Filter out non-IP interfaces
            guard interface.ifa_addr.pointee.sa_family == UInt8(AF_INET) ||
                  interface.ifa_addr.pointee.sa_family == UInt8(AF_INET6) else { continue }
            
            // Convert interface address to a human readable string
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST)
            let address = String(cString: hostname)
            
            print("Network interface: \(name), IP: \(address)")
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateProductData),
            name: Notification.Name(BasketManager.basketUpdatedNotification),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBasketChanges),
            name: Notification.Name(BasketManager.productQuantityChangedNotification),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleProductRemoved),
            name: Notification.Name(BasketManager.productRemovedNotification),
            object: nil
        )
    }

    private func setupInitialState() {
     
        
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }

    @objc private func handleBasketChanges(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let productId = userInfo["productId"] as? Int,
           let newQuantity = userInfo["quantity"] as? Int,
           let action = userInfo["action"] as? String {
            
            print("MilkProducts: handleBasketChanges - productId: \(productId), action: \(action), quantity: \(newQuantity)")
            
            // Найти индексы продукта в cardsData и displayDataSource
            if let cardIndex = cardsData.firstIndex(where: { $0.prodId == productId }),
               let displayIndex = displayDataSource.firstIndex(where: { $0.prodId == productId }) {
                
                // Обновить состояние товара в обоих источниках данных
                cardsData[cardIndex].prodCount = newQuantity
                cardsData[cardIndex].isInBasket = newQuantity > 0
                
                displayDataSource[displayIndex].prodCount = newQuantity
                displayDataSource[displayIndex].isInBasket = newQuantity > 0
                
                // Обновить ячейку, если она видима
                if let cell = collectionView.cellForItem(at: IndexPath(item: displayIndex, section: 0)) as? VegetablesCollectionCell {
                    cell.configure(with: displayDataSource[displayIndex])
                }
            } else {
                // Если продукт не найден в текущем состоянии, обновим полностью коллекцию
                // Это может произойти если мы добавили продукт в корзину из другого экрана
                updateProductData()
            }
        }
    }
    
    @objc private func handleProductDeleted(_ notification: Notification) {
        // Получаем ID удаленного товара из уведомления
        if let userInfo = notification.userInfo,
           let deletedProductId = userInfo["deletedProductId"] as? Int {
            print("MilkProducts: handleProductDeleted - deletedProductId: \(deletedProductId)")
            
            // Находим индекс товара по ID
            if let index = cardsData.firstIndex(where: { $0.prodId == deletedProductId }) {
                // Обновляем данные для этого товара
                cardsData[index].prodCount = 0
                cardsData[index].isInBasket = false
                
                // Обновляем UI для этой ячейки
                if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? VegetablesCollectionCell {
                    cell.configure(with: cardsData[index])
                }
            }
        }
        
        // Метка, что продукт был удален (для совместимости)
        self.isProdDeletedNow = true
    }
    
    @objc private func handleProductRemoved(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let productId = userInfo["productId"] as? Int {
            print("MilkProducts: handleProductRemoved - productId: \(productId)")
            
            // Синхронное обновление для удаления товара
            // Это более прямой способ, чем перебор всех товаров
            for i in 0..<displayDataSource.count {
                if displayDataSource[i].prodId == productId {
                    displayDataSource[i].prodCount = 0
                    displayDataSource[i].isInBasket = false
                    
                    // Обновляем ячейку если она видима
                    if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? VegetablesCollectionCell {
                        cell.configure(with: displayDataSource[i])
                    }
                }
            }
            
            // То же самое для cardsData
            for i in 0..<cardsData.count {
                if cardsData[i].prodId == productId {
                    cardsData[i].prodCount = 0
                    cardsData[i].isInBasket = false
                }
            }
        }
    }
    
    @objc private func refreshAllProducts() {
        print("MilkProducts: refreshAllProducts")
        
        // Получаем актуальную информацию о корзине
        let basketInfo = UserSettings.basketInfo ?? []
        
        // Сначала сбрасываем все счетчики
        for index in 0..<cardsData.count {
            cardsData[index].prodCount = 0
            cardsData[index].isInBasket = false
        }
        
        // Затем восстанавливаем данные из актуальной корзины
        for info in basketInfo {
            if !info.isEmpty {
                let productId = info[0].id
                let quantity = info[0].quantity
                
                if let index = cardsData.firstIndex(where: { $0.prodId == productId }) {
                    cardsData[index].prodCount = quantity
                    cardsData[index].isInBasket = quantity > 0
                }
            }
        }
        
        // Обновляем displayDataSource
        displayDataSource = cardsData
        
        // Полностью обновляем коллекцию
        collectionView.reloadData()
    }
    
    @objc func updateProductData() {
        print("MilkProducts: updateProductData")
        
        // Получаем информацию о товарах в корзине через BasketManager
        let basketMap = createBasketMap()
        
        // Обновляем состояние товаров в соответствии с корзиной
        var needReload = false
        for index in 0..<cardsData.count {
            let productId = cardsData[index].prodId
            let quantity = basketMap[productId] ?? 0
            
            // Обновляем только если количество изменилось
            if cardsData[index].prodCount != quantity {
                cardsData[index].prodCount = quantity
                cardsData[index].isInBasket = quantity > 0
                
                // Обновляем также displayDataSource если нужно
                if let displayIndex = displayDataSource.firstIndex(where: { $0.prodId == productId }) {
                    displayDataSource[displayIndex].prodCount = quantity
                    displayDataSource[displayIndex].isInBasket = quantity > 0
                }
                
                // Обновляем ячейку, если она видима
                if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? VegetablesCollectionCell {
                    cell.configure(with: cardsData[index])
            } else {
                    // Если хотя бы одна ячейка не видна, потребуется полная перезагрузка
                    needReload = true
                }
            }
        }
        
        // Перезагружаем коллекцию только если нужно (невидимые ячейки изменились)
        if needReload {
        collectionView.reloadData()
        }
    }

    // Вспомогательный метод для создания карты товаров в корзине [productId: quantity]
    private func createBasketMap() -> [Int: Int] {
        var basketMap: [Int: Int] = [:]
        
        if let basketInfo = UserSettings.basketInfo {
            for info in basketInfo {
                if !info.isEmpty {
                    basketMap[info[0].id] = info[0].quantity
                }
            }
        }
        
        return basketMap
    }

    @objc func orderPaid() {
        // Обновите данные вашей пользовательской настройки здесь
        // или обновление, специфичное для вашего UI
    }

    @objc
    func prodDeletedFromBasketNow() {
        self.isProdDeletedNow = true
    }

    @objc
    func basketAction() {
        let basketController = BasketController()
        navigationController?.pushViewController(basketController, animated: true)
    }
}

//MARK: - TableSettings

extension VegetablesController: CellDelegate, BasketCellDelegate {
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VegetablesCollectionCell.id, for: indexPath) as? VegetablesCollectionCell else {
            return UICollectionViewCell()
        }
        
        let item = displayDataSource[indexPath.item]
        
        // Check if product is in basket and update its state
        let quantity = BasketManager.shared.quantityForProduct(productId: item.prodId)
        var updatedItem = item
        updatedItem.prodCount = quantity
        updatedItem.isInBasket = quantity > 0
        
        // Проверяем, достигнуто ли максимальное количество
        let isMaxQuantityReached = quantity >= item.productCount
        
        // Configure cell with updated item and max quantity info
        cell.configure(with: updatedItem, shouldHideAddButton: isMaxQuantityReached)
        
        // ВАЖНО: Не захватываем updatedItem в замыкании, вместо этого используем productId
        let productId = updatedItem.prodId
        
        cell.onPlusTap = { [weak self] in
            guard let self = self else { return }
            
            // Получаем актуальное количество продукта и максимально доступное количество
            let currentQuantity = BasketManager.shared.quantityForProduct(productId: productId)
            let maxAvailableQuantity = self.displayDataSource[indexPath.item].productCount
            
            // Проверяем, не превышает ли текущее количество максимально доступное
            if currentQuantity < maxAvailableQuantity {
                BasketManager.shared.updateQuantity(
                    productId: productId,
                    quantity: currentQuantity + 1,
                    maxAvailable: maxAvailableQuantity,
                    categoty: item.catId)
                
                // Если после обновления достигнуто максимальное количество, обновляем UI ячейки
                if currentQuantity + 1 >= maxAvailableQuantity {
                    cell.hideAddButton(true)
                }
            }
        }
        
        cell.onMinusTap = { [weak self] in
            // Получаем актуальное количество продукта прямо перед изменением
            let currentQuantity = BasketManager.shared.quantityForProduct(productId: productId)
            let maxAvailableQuantity = self?.displayDataSource[indexPath.item].productCount ?? 0
            
            if currentQuantity > 0 {
                if currentQuantity == 1 {
                    BasketManager.shared.removeFromBasket(productId: productId)
                } else {
                    BasketManager.shared.updateQuantity(productId: productId, quantity: currentQuantity - 1,maxAvailable: maxAvailableQuantity, categoty: item.catId)
                }
                
                // Если после уменьшения количество стало меньше максимального, показываем кнопку плюс
                if currentQuantity >= maxAvailableQuantity {
                    cell.hideAddButton(false)
                }
            }
        }
        
        cell.basketDelegate = self
        cell.cellDelegate = self
     
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 8 // отступ между ячейками
        let totalSpacing: CGFloat = spacing * 4 // 2 крайних отступа + 2 отступа между ячейками
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = availableWidth / 3
        return CGSize(width: itemWidth, height: itemWidth * 2)
    }

    func infoButtonTapped(cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell),
              indexPath.item < displayDataSource.count else { return }
       
        let product = displayDataSource[indexPath.item]
        let cardInfoController = CardInfoController(product: product)
        navigationController?.pushViewController(cardInfoController, animated: true)
    }
    
    func didTapBasketButton(inCell cell: UICollectionViewCell) {
       guard let indexPath = collectionView.indexPath(for: cell) else { return }
       
       let item = displayDataSource[indexPath.item]
       let productId = item.prodId
       let maxAvailableQuantity = item.productCount
       
       // Получаем текущее количество и увеличиваем на 1, если не превышает максимум
        let currentQuantity = BasketManager.shared.quantityForProduct(productId: productId)
       
       if currentQuantity == 0 {
           // Если товара еще нет в корзине, добавляем его с проверкой максимального количества
           BasketManager.shared.addToBasket(product: item, quantity: 1)
       } else if currentQuantity < maxAvailableQuantity {
           // Если товар уже есть и не достигнут максимум, увеличиваем на 1
           BasketManager.shared.updateQuantity(
               productId: productId,
               quantity: currentQuantity + 1,
               maxAvailable: maxAvailableQuantity, categoty: item.catId
           )
       }
       
       // Обновляем UI ячейки если достигнуто максимальное количество
       if currentQuantity + 1 >= maxAvailableQuantity {
           if let productCell = cell as? VegetablesCollectionCell {
               productCell.hideAddButton(true)
           }
       }
    }
}

