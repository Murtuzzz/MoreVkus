import UIKit

class CardInfoController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBold(with: 24)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBold(with: 24)
        label.textColor = .black
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 16)
        label.textColor = .systemGreen
        return label
    }()
    
    private let basketView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBold(with: 18)
        label.textColor = .black
        label.text = "0"
        label.textAlignment = .center
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let basketButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить в корзину", for: .normal)
        button.titleLabel?.font = R.Fonts.avenirBold(with: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private var product: CardInfo?
    private var currentQuantity: Int = 0
    private var maxAvailable: Int = 0
    
    init(product: CardInfo) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNotifications()
        configureWithProduct()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Информация о товаре"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(basketView)
        
        basketView.addSubview(quantityLabel)
        basketView.addSubview(addButton)
        basketView.addSubview(removeButton)
        
        contentView.addSubview(basketButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            stockLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            basketView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            basketView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            basketView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            basketView.heightAnchor.constraint(equalToConstant: 50),
            
            quantityLabel.centerXAnchor.constraint(equalTo: basketView.centerXAnchor),
            quantityLabel.centerYAnchor.constraint(equalTo: basketView.centerYAnchor),
            
            addButton.centerYAnchor.constraint(equalTo: basketView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: basketView.trailingAnchor, constant: -16),
            
            removeButton.centerYAnchor.constraint(equalTo: basketView.centerYAnchor),
            removeButton.leadingAnchor.constraint(equalTo: basketView.leadingAnchor, constant: 16),
            
            basketButton.topAnchor.constraint(equalTo: basketView.bottomAnchor, constant: 16),
            basketButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            basketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            basketButton.heightAnchor.constraint(equalToConstant: 50),
            basketButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        basketButton.addTarget(self, action: #selector(basketButtonTapped), for: .touchUpInside)
    }
    
    private func setupNotifications() {
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
    
    private func configureWithProduct() {
        guard let product = product else { return }
        
        productImageView.image = UIImage(named: product.image)
        titleLabel.text = product.title
        descriptionLabel.text = product.discription
        priceLabel.text = "\(product.price) ₽"
        stockLabel.text = product.inStock ? "В наличии" : "Нет в наличии"
        maxAvailable = product.productCount
        
        // Получаем текущее количество товара из корзины
        currentQuantity = BasketManager.shared.quantityForProduct(productId: product.prodId)
        
        // Настраиваем начальное состояние кнопок
        updateUIState()
    }
    
    private func updateUIState() {
        guard let product = product else { return }
        
        // Обновляем количество
        quantityLabel.text = "\(currentQuantity)"
        
        // Обновляем видимость кнопок
        if currentQuantity > 0 {
            basketButton.alpha = 0
            addButton.alpha = product.inStock ? 1 : 0
            removeButton.alpha = 1
            quantityLabel.alpha = 1
            basketView.alpha = 1
        } else {
            basketButton.alpha = 1
            addButton.alpha = 0
            removeButton.alpha = 0
            quantityLabel.alpha = 0
            basketView.alpha = 0
        }
        
        // Скрываем кнопку добавления, если достигнут максимум
        if currentQuantity >= maxAvailable {
            addButton.alpha = 0
        }
    }
    
    @objc private func addButtonTapped() {
        guard let product = product, currentQuantity < maxAvailable else { return }
        currentQuantity += 1
        updateUIState()
        
        // Обновляем корзину
        BasketManager.shared.updateQuantity(
            productId: product.prodId,
            quantity: currentQuantity,
            maxAvailable: maxAvailable
        )
    }
    
    @objc private func removeButtonTapped() {
        guard let product = product, currentQuantity > 0 else { return }
        currentQuantity -= 1
        updateUIState()
        
        // Обновляем корзину
        BasketManager.shared.updateQuantity(
            productId: product.prodId,
            quantity: currentQuantity,
            maxAvailable: maxAvailable
        )
    }
    
    @objc private func basketButtonTapped() {
        guard let product = product else { return }
        currentQuantity = 1
        updateUIState()
        
        // Добавляем в корзину
        BasketManager.shared.addToBasket(product: product)
    }
    
    @objc private func handleBasketChanges(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let productId = userInfo["productId"] as? Int,
              let newQuantity = userInfo["quantity"] as? Int,
              product?.prodId == productId else { return }
        
        currentQuantity = newQuantity
        updateUIState()
    }
    
    @objc private func handleProductRemoved(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let productId = userInfo["productId"] as? Int,
              product?.prodId == productId else { return }
        
        currentQuantity = 0
        updateUIState()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
} 