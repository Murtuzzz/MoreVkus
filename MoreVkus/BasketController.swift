import UIKit

class BasketController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var basketItems: [[BasketInfo]] = []
    private var tableView: UITableView!
    
    private let emptyBasketLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваша корзина пуста"
        label.textAlignment = .center
        label.font = R.Fonts.avenirBold(with: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let totalPriceView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let locationLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Итого: 0 ₽"
        label.font = R.Fonts.avenirBold(with: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оформить заказ", for: .normal)
        button.titleLabel?.font = R.Fonts.avenirBold(with: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = R.Colors.active
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black.withAlphaComponent(0.5)
        label.font = R.Fonts.avenirBook(with: 16)
        label.numberOfLines = 2
        label.text = UserSettings.userLocation?["Location"] ?? "Введите адрес доставки"
        return label
    }()
    
    private let changeLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        //button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    private let locationImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        //view.image = UIImage(named:"location")
        view.image = UIImage(systemName:"map")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadBasketItems()
        setupNotifications()
        buttonsActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBasketItems()
        updateTotalPrice()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Корзина"
        
        // Setup tableView
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BasketCell.self, forCellReuseIdentifier: BasketCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add UI elements
        view.addSubview(locationLabelView)
        view.addSubview(locationLabel)
        view.addSubview(changeLocationButton)
        view.addSubview(tableView)
        view.addSubview(emptyBasketLabel)
        view.addSubview(totalPriceView)
        view.addSubview(locationImage)
        
        totalPriceView.addSubview(totalPriceLabel)
        totalPriceView.addSubview(checkoutButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            
            locationImage.leadingAnchor.constraint(equalTo: locationLabelView.leadingAnchor, constant: 20),
            locationImage.centerYAnchor.constraint(equalTo: locationLabelView.centerYAnchor),
            locationImage.heightAnchor.constraint(equalToConstant: 30),
            locationImage.widthAnchor.constraint(equalTo: locationImage.heightAnchor),
            
            changeLocationButton.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            changeLocationButton.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor),
            changeLocationButton.centerYAnchor.constraint(equalTo: locationLabelView.centerYAnchor),
            changeLocationButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationLabelView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImage.trailingAnchor, constant: 8),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            locationLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            locationLabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabelView.bottomAnchor.constraint(equalTo: totalPriceView.topAnchor, constant: -8),
            locationLabelView.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: locationLabelView.topAnchor, constant: -8),
            
            emptyBasketLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyBasketLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            totalPriceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalPriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalPriceView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            totalPriceView.heightAnchor.constraint(equalToConstant: 120),
            
            totalPriceLabel.topAnchor.constraint(equalTo: totalPriceView.topAnchor, constant: 20),
            totalPriceLabel.leadingAnchor.constraint(equalTo: totalPriceView.leadingAnchor, constant: 20),
            
            checkoutButton.leadingAnchor.constraint(equalTo: totalPriceView.leadingAnchor, constant: 20),
            checkoutButton.trailingAnchor.constraint(equalTo: totalPriceView.trailingAnchor, constant: -20),
            checkoutButton.bottomAnchor.constraint(equalTo: totalPriceView.bottomAnchor, constant: -20),
            checkoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Add button actions
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, 
                                              selector: #selector(basketUpdated), 
                                              name: Notification.Name(BasketManager.basketUpdatedNotification), 
                                              object: nil)
    }
    
    @objc private func basketUpdated() {
        loadBasketItems()
        updateTotalPrice()
    }
    
    func buttonsActions() {
        changeLocationButton.addTarget(self, action: #selector(saveLocationButtonAction), for: .touchUpInside)
    }
    
    @objc
    func saveLocationButtonAction() {
        let vc = MapViewController()
        navigationController?.pushViewController(vc, animated: true)
        
        vc.locationPick = { [weak self] in
            self?.locationLabel.text = UserSettings.userLocation!["Location"]
            // Закрываем MapViewController после выбора локации
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func loadBasketItems() {
        if let items = UserSettings.basketInfo {
            // Filter out empty arrays
            basketItems = items.filter { !$0.isEmpty }
            tableView.reloadData()
            
            // Show empty basket label if no items
            emptyBasketLabel.isHidden = !basketItems.isEmpty
            totalPriceView.isHidden = basketItems.isEmpty
            locationImage.isHidden = basketItems.isEmpty
            locationLabel.isHidden = basketItems.isEmpty
            locationLabelView.isHidden = basketItems.isEmpty
        } else {
            basketItems = []
            tableView.reloadData()
            
            // Show empty basket label if no items
            emptyBasketLabel.isHidden = false
            totalPriceView.isHidden = true
            locationImage.isHidden = true
            locationLabel.isHidden = true
            locationLabelView.isHidden = true
        }
    }
    
    private func updateTotalPrice() {
        let total = BasketManager.shared.totalPrice()
        totalPriceLabel.text = "Итого: \(String(format: "%.2f", total)) ₽"
    }
    
    @objc private func checkoutButtonTapped() {
        print(UserSettings.orderDelivered)
        if UserSettings.orderDelivered == false {
            let alert = UIAlertController(
                title: "Обработка",
                message: "Дождитесь завершения предыдущего заказа",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            // Проверяем, выбран ли адрес доставки
            guard let location = UserSettings.userLocation?["Location"], !location.isEmpty else {
                let alert = UIAlertController(
                    title: "Ошибка",
                    message: "Пожалуйста, выберите адрес доставки",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            
            // Проверяем, есть ли товары в корзине
            guard !basketItems.isEmpty else {
                let alert = UIAlertController(
                    title: "Ошибка",
                    message: "Корзина пуста",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            
            // Сохраняем информацию о заказе
            UserSettings.orderSum = BasketManager.shared.totalPrice()
            if let basketInfo = UserSettings.basketInfo {
                UserSettings.orderInfo = basketInfo
                //UserSettings.orderDelivered = false
                //UserSettings.orderCanceled = false
            }
            
            // Очищаем корзину
            BasketManager.shared.clearBasket()
            
            // Открываем экран информации о доставке
            
            let deliveryController = DeliveryController()
            navigationController?.pushViewController(deliveryController, animated: true)
            UserSettings.orderPaid = true
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketCell.identifier, for: indexPath) as? BasketCell else {
            return UITableViewCell()
        }
        
        if !basketItems[indexPath.row].isEmpty {
            let item = basketItems[indexPath.row][0]
            
            // Проверяем, достигнуто ли максимальное количество
            let isMaxReached = item.quantity >= item.prodCount
            
            // Настраиваем ячейку с учетом максимального количества
            cell.configure(with: item, shouldHideIncreaseButton: isMaxReached)
            
            // Add quantity change handlers
            cell.onIncrease = { [weak self] in
                // Сохраняем ID продукта, чтобы получить актуальное состояние
                let productId = item.id
                // Получаем актуальное количество продукта и максимальное доступное количество
                let currentQuantity = BasketManager.shared.quantityForProduct(productId: productId)
                let maxAvailableQuantity = item.prodCount
                
                // Увеличиваем только если не достигнут максимум
                if currentQuantity < maxAvailableQuantity {
                    BasketManager.shared.updateQuantity(
                        productId: productId, 
                        quantity: currentQuantity + 1,
                        maxAvailable: maxAvailableQuantity
                    )
                    
                    // Если после обновления достигнут максимум, скрываем кнопку
                    if currentQuantity + 1 >= maxAvailableQuantity {
                        cell.hideIncreaseButton(true)
                    }
                }
                
                self?.updateTotalPrice()
            }
            
            cell.onDecrease = { [weak self] in
                // Сохраняем ID продукта, чтобы получить актуальное состояние
                let productId = item.id
                // Получаем актуальное количество продукта и максимальное доступное количество
                let currentQuantity = BasketManager.shared.quantityForProduct(productId: productId)
                let maxAvailableQuantity = item.prodCount
                
                if currentQuantity > 1 {
                    // Если количество больше 1, уменьшаем на 1
                    BasketManager.shared.updateQuantity(productId: productId, quantity: currentQuantity - 1)
                    
                    // Показываем кнопку увеличения, если она была скрыта
                    if currentQuantity >= maxAvailableQuantity {
                        cell.hideIncreaseButton(false)
                    }
                } else {
                    // Если количество равно 1, удаляем товар
                    BasketManager.shared.removeFromBasket(productId: productId)
                    self?.loadBasketItems()
                }
                self?.updateTotalPrice()
            }
            
            cell.onRemove = { [weak self] in
                BasketManager.shared.removeFromBasket(productId: item.id)
                self?.loadBasketItems()
                self?.updateTotalPrice()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - BasketCell

class BasketCell: UITableViewCell {
    static let identifier = "BasketCell"
    
    // Callback closures for button actions
    var onIncrease: (() -> Void)?
    var onDecrease: (() -> Void)?
    var onRemove: (() -> Void)?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.avenirBook(with: 16)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.trebuchet(with: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.trebuchet(with: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Add views
        contentView.addSubview(containerView)
        
        containerView.addSubview(productImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(quantityLabel)
        containerView.addSubview(increaseButton)
        containerView.addSubview(decreaseButton)
        containerView.addSubview(removeButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            productImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: removeButton.trailingAnchor, constant: 8),
            productImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            
            quantityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            quantityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 50),
            quantityLabel.heightAnchor.constraint(equalToConstant: 24),
            
            increaseButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 8),
            increaseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            increaseButton.widthAnchor.constraint(equalToConstant: 20),
            increaseButton.heightAnchor.constraint(equalTo: increaseButton.widthAnchor),
            
            decreaseButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: -8),
            decreaseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            decreaseButton.widthAnchor.constraint(equalToConstant: 20),
            decreaseButton.heightAnchor.constraint(equalTo: decreaseButton.widthAnchor),
            
            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            removeButton.heightAnchor.constraint(equalToConstant: 16),
            removeButton.widthAnchor.constraint(equalToConstant: 16),
            
        ])
        
        // Add button actions
        increaseButton.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)
        decreaseButton.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    func configure(with item: BasketInfo, shouldHideIncreaseButton: Bool = false) {
        titleLabel.text = item.title
        priceLabel.text = "\(String(format: "%.2f", item.price)) ₽"
        quantityLabel.text = "\(item.quantity)"
        
        // Попробуем загрузить изображение по имени продукта
        // Если не найдено - используем запасное изображение
        if let image = UIImage(named: item.title) {
            productImageView.image = image
        } else {
            // Используем случайное изображение из ресурсов "food1", "food2", и т.д.
            productImageView.image = UIImage(named: "food\(Int.random(in: 1...5))") 
        }
        
        // Настраиваем кнопку увеличения
        hideIncreaseButton(shouldHideIncreaseButton)
    }
    
    // Добавляем метод для скрытия/показа кнопки увеличения
    func hideIncreaseButton(_ hide: Bool) {
        increaseButton.isHidden = hide
        increaseButton.isEnabled = !hide
        
        // Добавляем индикатор максимального количества, если кнопка скрыта
        if hide {
            addMaxQuantityLabel()
        } else {
            removeMaxQuantityLabel()
        }
    }
    
    // Максимальное количество товара достигнуто
    private var maxQuantityLabel: UILabel?
    
    // Метод для добавления индикатора максимального количества
    private func addMaxQuantityLabel() {
        if maxQuantityLabel == nil {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Макс."
            label.font = R.Fonts.avenirBook(with: 10)
            label.textColor = .systemGray
            label.textAlignment = .center
            containerView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: increaseButton.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: increaseButton.centerYAnchor),
            ])
            
            maxQuantityLabel = label
        }
        maxQuantityLabel?.isHidden = false
    }
    
    // Метод для удаления индикатора максимального количества
    private func removeMaxQuantityLabel() {
        maxQuantityLabel?.isHidden = true
    }
    
    @objc private func increaseButtonTapped() {
        onIncrease?()
    }
    
    @objc private func decreaseButtonTapped() {
        onDecrease?()
    }
    
    @objc private func removeButtonTapped() {
        onRemove?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        quantityLabel.text = nil
        
        onIncrease = nil
        onDecrease = nil
        onRemove = nil
    }
}
