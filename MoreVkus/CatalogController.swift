//
//  ViewController.swift
//  MoreVkus
//
//  Created by Мурат Кудухов on 12.05.2025.
//


import UIKit


class CatalogController: UIViewController {
    
    private let discountCollection = DiscountCollectionView()
    //private let bonusBlock = BonusBlockView(bonus: "0")
    //private let offersCollection = RecomendationCollection()
    private let recomendationCollection = RecomendationCollection()
    private let sweetsCollection = RecomendationCollection()
    var unavailableInd: [Int] = []
    let controllers = [ProductsController(),ProductsController(),ProductsController(),ProductsController(),ProductsController()]
    
    private let basketButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "basket"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private var profileButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Войти"
        
        // Установка изображения с нужным размером
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        config.image = UIImage(systemName: "person", withConfiguration: imageConfig)
        
        // Расстояние между текстом и картинкой
        config.imagePadding = 8
        config.baseForegroundColor = .black

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20) // Этот параметр сейчас игнорируется, шрифт задается через configuration
        
        return button
    }()
    
    private var basketItemCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.alpha = 0
        label.text = "0"
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.layer.borderColor = R.Colors.background.cgColor
        label.layer.borderWidth = 4
        label.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        return label
    }()
    
    private let deliveryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "truck.box.badge.clock"), for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 22
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.systemGray3.cgColor
        button.layer.shadowOpacity = 0.5;
        button.layer.shadowRadius = 5.0;
        button.layer.shadowOffset = CGSizeMake(4, 4);
        button.alpha = 1
        return button
    }()
    
    private let profileView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.systemGray3.cgColor
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowRadius = 5.0;
        view.layer.shadowOffset = CGSizeMake(4, 4);
        return view
    }()
    
    private let basketView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.systemGray3.cgColor
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowRadius = 5.0;
        view.layer.shadowOffset = CGSizeMake(4, 4);
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let recomedationLabel: UILabel = {
        let label = UILabel()
        label.text = "Рекомендуем"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private let sweetsLabel: UILabel = {
        let label = UILabel()
        label.text = "Рыба"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "text.justify"), for: .normal)
        button.tintColor = .systemGreen
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6.withAlphaComponent(0.5)

        setupUI()
        setupNotifications()
        UserSettings.orderDelivered = true
        UserSettings.orderCanceled = false
        
        if UserSettings.orderDelivered == nil {
            UserSettings.orderDelivered = true
        }
        
        title = "Каталог"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBasketIndicator()
        
//        if UserSettings.orderDelivered {
//            deliveryButton.alpha = 0
//        } else {
//            deliveryButton.alpha = 1
//        }
//        
//        if UserSettings.orderCanceled {
//            deliveryButton.alpha = 0
//        } else {
//            deliveryButton.alpha = 1
//        }
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        middleView.addSubview(discountCollection)
        middleView.addSubview(recomendationCollection)
        
        recomendationCollection.onCellTap = {
            print(UserSettings.currentController)
            self.navigationController?.pushViewController(self.controllers[UserSettings.currentController], animated: true)
        }
        
        middleView.addSubview(recomedationLabel)
        //middleView.addSubview(sweetsCollection)
        //middleView.addSubview(sweetsLabel)
        view.addSubview(basketView)
        view.addSubview(deliveryButton)
        view.addSubview(basketButton)
        view.addSubview(profileView)
        view.addSubview(basketItemCountLabel)
        view.addSubview(profileButton)
        view.addSubview(profileButton)

        contentView.addSubview(middleView)
        scrollView.addSubview(contentView)
        basketButton.addTarget(self, action: #selector(basketAction), for: .touchUpInside)
        
        constraints()
        
        if UserSettings.userLocation == nil {
            UserSettings.userLocation = [:]
        }
        
        deliveryButton.addTarget(self, action: #selector(deilveryButtonAction), for: .touchUpInside)
    }
    
    @objc
    func deilveryButtonAction() {
        //let vc = DeliveryViewController()
        let vc = DeliveryController()
        //present(vc, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupNotifications() {
        // Listen for changes in the basket
        NotificationCenter.default.addObserver(
            self, 
            selector: #selector(updateBasketIndicator), 
            name: Notification.Name(BasketManager.basketUpdatedNotification), 
            object: nil
        )
    }
    
    @objc private func updateBasketIndicator() {
        // Update the basket count indicator
        let itemCount = BasketManager.shared.totalItemsCount()
        
        // Update the UI on the main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if itemCount > 0 {
                self.basketItemCountLabel.text = "\(itemCount)"
                self.basketItemCountLabel.alpha = 1
                self.basketButton.tintColor = R.Colors.active
            } else {
                self.basketItemCountLabel.alpha = 0
                self.basketButton.tintColor = .systemGray
            }
        }
    }
    
    @objc func basketAction() {
        let basketController = BasketController()
        navigationController?.pushViewController(basketController, animated: true)
    }
    
    func constraints() {
       // offersCollection.translatesAutoresizingMaskIntoConstraints = false
        discountCollection.translatesAutoresizingMaskIntoConstraints = false
        //bonusBlock.translatesAutoresizingMaskIntoConstraints = false
        recomendationCollection.translatesAutoresizingMaskIntoConstraints = false
        sweetsCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1600),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            middleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            recomendationCollection.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
            recomendationCollection.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -16),
            recomendationCollection.topAnchor.constraint(equalTo: recomedationLabel.bottomAnchor, constant: 16),
            recomendationCollection.widthAnchor.constraint(equalToConstant: view.bounds.width),
            recomendationCollection.heightAnchor.constraint(equalToConstant: view.bounds.height/2.4),
            
//            sweetsCollection.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
//            sweetsCollection.topAnchor.constraint(equalTo: sweetsLabel.bottomAnchor, constant: 16),
//            sweetsCollection.widthAnchor.constraint(equalToConstant: view.bounds.width),
//            sweetsCollection.heightAnchor.constraint(equalToConstant: view.bounds.height/2.4),
//            
            recomedationLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
            recomedationLabel.topAnchor.constraint(equalTo: discountCollection.bottomAnchor, constant: 16),
            
//            sweetsLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
//            sweetsLabel.topAnchor.constraint(equalTo: recomendationCollection.bottomAnchor),
            
            basketView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            basketView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -16),
            basketView.heightAnchor.constraint(equalToConstant: 56),
            basketView.widthAnchor.constraint(equalToConstant: 80),
            
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            profileView.heightAnchor.constraint(equalToConstant: 56),
            profileView.widthAnchor.constraint(equalToConstant: 136),
            
            profileButton.widthAnchor.constraint(equalToConstant: 136),
            profileButton.heightAnchor.constraint(equalToConstant: 56),
            profileButton.leadingAnchor.constraint(equalTo: profileView.leadingAnchor),
            profileButton.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            
            deliveryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deliveryButton.centerYAnchor.constraint(equalTo: basketButton.centerYAnchor),
            deliveryButton.heightAnchor.constraint(equalToConstant: 56),
            deliveryButton.widthAnchor.constraint(equalTo: deliveryButton.heightAnchor),
            
            discountCollection.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 104),
            discountCollection.leadingAnchor.constraint(equalTo: middleView.leadingAnchor,constant: 8),
            discountCollection.widthAnchor.constraint(equalToConstant: view.bounds.width),
            discountCollection.heightAnchor.constraint(equalToConstant: 174),
            
            basketButton.trailingAnchor.constraint(equalTo: basketView.trailingAnchor, constant: 8),
            basketButton.centerYAnchor.constraint(equalTo: basketView.centerYAnchor),
            basketButton.heightAnchor.constraint(equalToConstant: 80),
            basketButton.widthAnchor.constraint(equalTo: basketButton.heightAnchor),
            
            basketItemCountLabel.topAnchor.constraint(equalTo: basketButton.topAnchor, constant: -5),
            basketItemCountLabel.trailingAnchor.constraint(equalTo: basketButton.trailingAnchor, constant: 5),
            basketItemCountLabel.widthAnchor.constraint(equalToConstant: 30),
            basketItemCountLabel.heightAnchor.constraint(equalToConstant: 30),
            
//            bonusBlock.topAnchor.constraint(equalTo: discountCollection.bottomAnchor, constant: 16),
//            bonusBlock.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
//            bonusBlock.widthAnchor.constraint(equalToConstant: view.bounds.width - 16),
//            bonusBlock.heightAnchor.constraint(equalToConstant: 130),
//
//            offersCollection.topAnchor.constraint(equalTo: bonusBlock.bottomAnchor, constant: 16),
//            offersCollection.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
//            offersCollection.widthAnchor.constraint(equalToConstant: view.bounds.width - 16),
//            offersCollection.heightAnchor.constraint(equalToConstant: 140),
        
        ])
    }


}



