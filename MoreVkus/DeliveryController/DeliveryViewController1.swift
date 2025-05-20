//
//  MapViewController.swift
//  MapRouting
//

import UIKit
import YandexMapsMobile

struct Order {
    let title: String
    let quantity: Int
    let price: Int
    let id: Int
    let time: String
}

final class DeliveryController1: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Delivery Items
    
    private var tableView = UITableView()
    var orderProdData: [Order] = []
    var timer: Timer?
    var isFullScreen = false
    
    
    private let orderInfoTitle: UILabel = {
        let label = UILabel()
        label.text = "Информация о заказе"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let orderDetailsLabel: UILabel = {
        let orderDetailsLabel = UILabel()
        orderDetailsLabel.textColor = .systemGray2
        orderDetailsLabel.numberOfLines = 0
        orderDetailsLabel.textAlignment = .center
        orderDetailsLabel.font = .systemFont(ofSize: 12)
        orderDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        return orderDetailsLabel
    }()
    
    private var orderInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.barBg
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.backgroundColor = .red.withAlphaComponent(0.5)
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Сумма заказа: \(UserSettings.orderSum + 299)"
        return label
    }()
    
    private let payType: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Способ оплаты: Наличные"
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray
        //button.setTitle("Отменить заказ", for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Отменить заказ", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
        return button
    }()
    
    private let orderDoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .orange
        button.setImage(UIImage(systemName: "swift"), for: .normal)
        return button
    }()
    
    private let fullScreenView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .black.withAlphaComponent(0.5)
        view.contentMode = .scaleAspectFit
        view.alpha = 0
        return view
    }()
    
    private let fullScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue
        button.backgroundColor = .gray.withAlphaComponent(0.5)
        button.setImage(UIImage(systemName: "map"), for: .normal)
        button.alpha = 0
        return button
    }()
    
    private let fullScreenButton2: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemOrange
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        //button.backgroundColor = .gray.withAlphaComponent(0.5)
        button.setImage(UIImage(systemName: "map"), for: .normal)
        return button
    }()
    
    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        startCheckingStatus()
        mapView = YMKMapView(frame: view.frame)
        view.addSubview(mapView)
        map = mapView.mapWindow.map

       // map.addInputListener(with: mapInputListener)

        routingViewModel.placemarksCollection = map.mapObjects.add()
        routingViewModel.routesCollection = map.mapObjects.add()

        move()

        Const.defaultPoints
            .forEach { routingViewModel.addRoutePoint($0) }
        
        setupOrderInfoView()
        tableApperance()
        view.addSubview(cancelButton)
        view.addSubview(orderDoneButton)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        orderDoneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        fullScreenButton.addTarget(self, action: #selector(fullScreenAction), for: .touchUpInside)
        fullScreenButton2.addTarget(self, action: #selector(fullScreenAction), for: .touchUpInside)
        view.addSubview(fullScreenView)
        setupConstraints()
        
        
       //routingViewModel.addRoutePoint(Const.endPoint)
    }
    
    func setupOrderInfoView() {
        orderInfoView.backgroundColor = R.Colors.background
        //orderInfoView.backgroundColor = .clear
        
        
        
        orderInfoView.addSubview(orderInfoTitle)
        
        orderInfoView.addSubview(orderDetailsLabel)
        
        view.addSubview(orderInfoView)
        view.addSubview(priceLabel)
        view.addSubview(payType)
        view.addSubview(fullScreenButton)
        view.addSubview(fullScreenButton2)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            orderInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            orderInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            orderInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 32),
            orderInfoView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -128),
            
            fullScreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            fullScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            fullScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            fullScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            
            orderInfoTitle.topAnchor.constraint(equalTo: orderInfoView.topAnchor, constant: 16),
            //label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orderInfoTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: orderInfoTitle.bottomAnchor,constant: 16),
            tableView.leadingAnchor.constraint(equalTo: orderInfoView.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: orderInfoView.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height/6),
            
            orderDetailsLabel.topAnchor.constraint(equalTo: orderInfoTitle.bottomAnchor, constant: 8),
            orderDetailsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
            cancelButton.heightAnchor.constraint(equalToConstant: 16),
            
            orderDoneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            orderDoneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orderDoneButton.widthAnchor.constraint(equalToConstant: 24),
            orderDoneButton.heightAnchor.constraint(equalToConstant: 24),
            
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -56),
            priceLabel.heightAnchor.constraint(equalToConstant: 25),
            priceLabel.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            payType.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payType.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            payType.heightAnchor.constraint(equalToConstant: 16),
            payType.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            fullScreenButton.topAnchor.constraint(equalTo: view.topAnchor),
            fullScreenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullScreenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fullScreenButton.bottomAnchor.constraint(equalTo: orderInfoView.topAnchor, constant: 16),
            
            fullScreenButton2.centerYAnchor.constraint(equalTo: orderInfoTitle.centerYAnchor),
            fullScreenButton2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
    }
    
    func tableApperance() {
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.backgroundColor = R.Colors.barBg
        self.tableView.estimatedRowHeight = 150
        self.tableView.layer.cornerRadius = 20
        self.tableView.allowsSelection = false
        self.tableView.isEditing = false
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.register(DeliveryCell.self, forCellReuseIdentifier: DeliveryCell.id)
        
        
        if UserSettings.orderInfo == nil {
            UserSettings.orderInfo = []
        }
        
        for i in UserSettings.orderInfo {
            orderProdData.append(.init(title: i[0].title, quantity: i[0].quantity, price: Int(i[0].price), id: i[0].id, time: i[0].orderTime))
        }
        
        tableView.reloadData()
        
        view.addSubview(tableView)
    }
    
    @objc
    func cancelButtonAction() {
        UserSettings.orderDelivered = false
        navigationController?.popViewController(animated: true)
        timer?.invalidate()
    }
    
    @objc
    func fullScreenAction() {
        if isFullScreen {
            orderInfoView.alpha = 1
            tableView.alpha = 1
            priceLabel.alpha = 1
            orderInfoTitle.alpha = 1
            //fullScreenButton2.alpha = 0
            fullScreenButton2.setImage(UIImage(systemName: "map"), for: .normal)
            //fullScreenButton.alpha = 1
            isFullScreen.toggle()
        } else {
            orderInfoView.alpha = 0
            tableView.alpha = 0
            priceLabel.alpha = 0
            orderInfoTitle.alpha = 0
            //fullScreenButton.alpha = 0
            //fullScreenButton2.alpha = 1
            fullScreenButton2.setImage(UIImage(systemName: "map.fill"), for: .normal)
            isFullScreen.toggle()
        }

    }
    
    @objc
    func doneButtonAction() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        
        // Выводим текущую дату и время
        
        UserSettings.orderDelivered = false
        self.timer?.invalidate()
        if UserSettings.ordersHistory == nil {
            UserSettings.ordersHistory = []
        }
        
        var order: [[BasketInfo]] = UserSettings.orderInfo
        order[0][0].orderTime = dateString
        
        UserSettings.isLocChanging = false
        UserSettings.ordersHistory.append(order)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - MapRoute methods

    private func move(to cameraPosition: YMKCameraPosition = Const.startPosition) {
        map.move(with: cameraPosition, animation: YMKAnimation(type: .smooth, duration: 1.0))
    }

    @objc
    private func handleResetRoutePointsButtonTap() {
        routingViewModel.resetRoutePoints()
    }

    // MARK: - Private properties

    private var mapView: YMKMapView!
    private var map: YMKMap!

    private lazy var routingViewModel = RoutingViewModel(controller: self)
    //private lazy var mapInputListener: YMKMapInputListener = MapInputListener(routingViewModel: routingViewModel)

    private let resetRoutePointsButton = UIButton()

    // MARK: - Private nesting
    private enum Const {
        static let startPoint = YMKPoint(latitude: 43.035260, longitude: 44.636676)
       
        static let endPoint: YMKPoint = {
                if let userLocation = UserSettings.userLocation,
                   let latitude = userLocation["latitude"],
                   let longitude = userLocation["longitude"] {
                    return YMKPoint(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0)
                } else {
                    // Обработайте случай, когда координаты недоступны (например, верните точку по умолчанию)
                    return YMKPoint(latitude: 0.0, longitude: 0.0)
                }
            }()

        static let centerLatitude = (startPoint.latitude + endPoint.latitude) / 2
        static let centerLongitude = (startPoint.longitude + endPoint.longitude) / 2
        static let centerPoint = YMKPoint(latitude: centerLatitude - 0.03, longitude: centerLongitude)
        static let startPointCamera = (YMKPoint(latitude: endPoint.latitude - 0.03, longitude: endPoint.longitude))

//        static let startPosition = YMKCameraPosition(target: YMKPoint(latitude: 43.005260, longitude: 44.649676), zoom: 13.0, azimuth: .zero, tilt: .zero)
        static let startPosition = YMKCameraPosition(target: startPointCamera, zoom: 13.0, azimuth: .zero, tilt: .zero)
        static let defaultPoints: [YMKPoint] = [
            YMKPoint(latitude: 43.035260, longitude: 44.636676),
            YMKPoint(latitude: Const.endPoint.latitude, longitude: Const.endPoint.longitude)
        ]
    }

    private enum Layout {
        static let buttonSize: CGFloat = 50.0
        static let buttonMargin: CGFloat = 50.0
        static let buttonCornerRadius: CGFloat = 8.0
    }
}

extension DeliveryController1 {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderProdData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryCell.id, for: indexPath) as! DeliveryCell
        let basketData = self.orderProdData[indexPath.row]
        
        if basketData.quantity != 0 {
            cell.config(title: basketData.title, quantity: basketData.quantity, price: basketData.price)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
        
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
                            self.doneButtonAction()
                        }
                    }
                }
            } catch {
            }
        }
        
        task.resume()
    }
}

