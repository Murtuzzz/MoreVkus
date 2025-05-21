import UIKit
import YandexMapsMobile

class DeliveryController: UIViewController {
    
    // MARK: - UI Elements
    
    var timer: Timer?
    
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
    
    private let mapView: YMKMapView = {
        let mapView = YMKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 12
        mapView.clipsToBounds = true
        return mapView
    }()
    
    private let addressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = UserSettings.userLocation?["Location"] ?? "Адрес не выбран"
        return label
    }()
    
    private let paymentMethodView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let paymentMethodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 16)
        label.textColor = .black
        label.text = "Способ оплаты: Наличными"
        return label
    }()
    
    private let noDeliveryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Нет активных доставок на данный момент"
        return label
    }()
    
    private let orderDetailsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let orderDetailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить заказ", for: .normal)
        button.titleLabel?.font = R.Fonts.avenirBold(with: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 20
        return button
    }()
    
    // MARK: - Properties
    
    private var map: YMKMap!
    private var shopPlacemark: YMKPlacemarkMapObject?
    private var customerPlacemark: YMKPlacemarkMapObject?
    private var isMapInitialized = false
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("UserSettings.activeOrder = \(UserSettings.activeOrder)")
        
        if UserSettings.activeOrder {
            print("noActiveOrder")
            noDeliveryLabel.isHidden = true
            cancelButton.isHidden = false
            orderDetailsLabel.isHidden = false
            orderDetailsView.isHidden = false
            mapView.isHidden = false
            addressView.isHidden = false
            addressLabel.isHidden = false
            paymentMethodView.isHidden = false
            paymentMethodLabel.isHidden = false
        } else {
            print("ActiveOrder")
            noDeliveryLabel.isHidden = false
            cancelButton.isHidden = true
            orderDetailsLabel.isHidden = true
            orderDetailsView.isHidden = true
            mapView.isHidden = true
            addressView.isHidden = true
            addressLabel.isHidden = true
            paymentMethodView.isHidden = true
            paymentMethodLabel.isHidden = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserSettings.orderPaid {
            startCheckingStatus()
        }
        
        setupUI()
        setupActions()
        
        // Закрываем BasketController
        if let basketController = navigationController?.viewControllers.first(where: { $0 is BasketController }) {
            navigationController?.viewControllers.removeAll(where: { $0 == basketController })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(!UserSettings.orderDelivered,!UserSettings.orderCanceled)
        
        
        
        if !isMapInitialized {
            // Добавляем небольшую задержку для гарантии, что view полностью загружены
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.setupMap()
                self?.isMapInitialized = true
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Информация о доставке"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(noDeliveryLabel)
        contentView.addSubview(mapView)
        contentView.addSubview(addressView)
        contentView.addSubview(paymentMethodView)
        contentView.addSubview(orderDetailsView)
        contentView.addSubview(cancelButton)
        
        addressView.addSubview(addressLabel)
        paymentMethodView.addSubview(paymentMethodLabel)
        orderDetailsView.addSubview(orderDetailsLabel)
        
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
            
            noDeliveryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDeliveryLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            mapView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            
            addressView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16),
            addressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            addressLabel.topAnchor.constraint(equalTo: addressView.topAnchor, constant: 12),
            addressLabel.leadingAnchor.constraint(equalTo: addressView.leadingAnchor, constant: 12),
            addressLabel.trailingAnchor.constraint(equalTo: addressView.trailingAnchor, constant: -12),
            addressLabel.bottomAnchor.constraint(equalTo: addressView.bottomAnchor, constant: -12),
            
            paymentMethodView.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 16),
            paymentMethodView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            paymentMethodView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            paymentMethodLabel.topAnchor.constraint(equalTo: paymentMethodView.topAnchor, constant: 12),
            paymentMethodLabel.leadingAnchor.constraint(equalTo: paymentMethodView.leadingAnchor, constant: 12),
            paymentMethodLabel.trailingAnchor.constraint(equalTo: paymentMethodView.trailingAnchor, constant: -12),
            paymentMethodLabel.bottomAnchor.constraint(equalTo: paymentMethodView.bottomAnchor, constant: -12),
            
            orderDetailsView.topAnchor.constraint(equalTo: paymentMethodView.bottomAnchor, constant: 16),
            orderDetailsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            orderDetailsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            orderDetailsLabel.topAnchor.constraint(equalTo: orderDetailsView.topAnchor, constant: 12),
            orderDetailsLabel.leadingAnchor.constraint(equalTo: orderDetailsView.leadingAnchor, constant: 12),
            orderDetailsLabel.trailingAnchor.constraint(equalTo: orderDetailsView.trailingAnchor, constant: -12),
            orderDetailsLabel.bottomAnchor.constraint(equalTo: orderDetailsView.bottomAnchor, constant: -12),
            
            cancelButton.topAnchor.constraint(equalTo: orderDetailsView.bottomAnchor, constant: 24),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        setupOrderDetails()
    }
    
    private func setupMap() {
        guard mapView.frame.width > 0, mapView.frame.height > 0 else {
            print("Map view has zero size")
            return
        }
        
        map = mapView.mapWindow.map
        
        // Добавляем маркер магазина
        let shopPoint = YMKPoint(latitude: 43.039385, longitude: 44.629516) // Координаты магазина
        shopPlacemark = map.mapObjects.addPlacemark(with: shopPoint)
        shopPlacemark?.setIconWith(UIImage(systemName: "building.2.fill")!.withTintColor(.systemBlue))
        
        // Добавляем маркер клиента, если есть координаты
        if let latitude = UserSettings.userLocation?["latitude"],
           let longitude = UserSettings.userLocation?["longitude"],
           let lat = Double(latitude),
           let lon = Double(longitude) {
            let customerPoint = YMKPoint(latitude: lat, longitude: lon)
            customerPlacemark = map.mapObjects.addPlacemark(with: customerPoint)
            customerPlacemark?.setIconWith(UIImage(systemName: "mappin.circle.fill")!.withTintColor(.systemRed))
            
            // Устанавливаем камеру так, чтобы были видны оба маркера
            let boundingBox = YMKBoundingBox(
                southWest: YMKPoint(latitude: min(lat, 43.039385), longitude: min(lon, 44.629516)),
                northEast: YMKPoint(latitude: max(lat, 43.039385), longitude: max(lon, 44.629516))
            )
            let cameraPosition = map.cameraPosition(with: YMKGeometry(boundingBox: boundingBox))
            map.move(with: cameraPosition, animation: YMKAnimation(type: .smooth, duration: 1))
        }
    }
    
    func startCheckingStatus() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(checkDeliveryStatus), userInfo: nil, repeats: true)
    }
    
    //--MARK: Back: checkStatus bbb
    @objc func checkDeliveryStatus() {
        guard let url = URL(string: "\(Config.baseURL)/checkStatus") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let deliveryStatus = jsonResponse["delivered"] as? Bool {
                    print("#DeliveryController#checkDeliveryStatus#deliveryStatus = \(deliveryStatus) ")
                    if deliveryStatus {
                        self.timer?.invalidate()
                        self.timer = nil
                        DispatchQueue.main.async {
                            UserSettings.orderPaid = false
                            UserSettings.orderDelivered = deliveryStatus
                            UserSettings.activeOrder = false
                            
                            self.navigationController?.popViewController(animated: true)
                            //self.doneButtonAction()
                        }
                    }
                }
            } catch {
            }
        }
        
        task.resume()
    }
    
    private func setupOrderDetails() {
        var detailsText = "Состав заказа:\n\n"
        
        if let orderInfo = UserSettings.orderInfo {
            for item in orderInfo {
                if !item.isEmpty {
                    let product = item[0]
                    detailsText += "• \(product.title) - \(product.quantity) шт. x \(String(format: "%.2f", product.price)) ₽\n"
                }
            }
        }
        
        let total = UserSettings.orderSum ?? 0.0
        detailsText += "\nИтого: \(String(format: "%.2f", total)) ₽"
        
        orderDetailsLabel.text = detailsText
    }
    
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        let alert = UIAlertController(
            title: "Отмена заказа",
            message: "Вы уверены, что хотите отменить заказ?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Да, отменить", style: .destructive) { [weak self] _ in
            // Возвращаемся на предыдущий экран
            UserSettings.activeOrder = false
            UserSettings.orderCanceled = true
            UserSettings.orderPaid = false
            UserSettings.orderInfo = []
            self!.timer?.invalidate()
            self?.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
} 
