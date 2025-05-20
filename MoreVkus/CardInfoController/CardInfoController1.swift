//
//  CardInfoController.swift
//  FishShop
//
//  Created by Мурат Кудухов on 13.03.2024.
//

import UIKit

final class CardInfoController1: UIViewController {
    
    private var infoSection = Stack(title: "", weight: "", size: "", temp: "")
    private var prodCount = 0
    var descPlusTap: (() -> Void)?
    var descMinusTap: (() -> Void)?
    var descBasketTap: (() -> Void)?
    var check: (() -> Void)?
    var inStock = true
    
    var bskt: [[BasketInfo]] = []
    
    private let arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "arrowLeft")!.withRenderingMode(.alwaysTemplate), for: .normal)
        button.layer.masksToBounds = true
        button.tintColor = .white
        return button
    }()
    
    private let prodImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.image = UIImage(named: "salmon")
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .systemGray6
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray6
        label.font = R.Fonts.avenirBook(with: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let weightLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "350 г"
        label.textColor = .systemGray6
        label.numberOfLines = 1
        return label
    }()
    
    private let caloriesLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "248 Ккал"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray6
        label.backgroundColor = R.Colors.barBg
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.numberOfLines = 1
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    }()
    
    private let buyButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        view.alpha = 0
        return view
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("В корзину", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName:"minus"), for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName:"plus"), for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 10
        button.tintColor = .white
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var prodCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.alpha = 0
        return label
    }()
    
    private let weightLabel = UILabelBG()
    private let caloriesLabel = UILabelBG()
    
    private let arrowView = RoundedView()
    
    override func viewWillAppear(_ animated: Bool) {
        print("-------------------------------CardInfoController------------------------------------")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserSettings.basketInfo != nil {
            self.bskt = UserSettings.basketInfo
        }
        view.backgroundColor = R.Colors.background
        //self.navigationItem.hidesBackButton = false
        navigationController?.navigationBar.barTintColor = .white
        view.addSubview(prodImage)
        view.addSubview(arrowView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(buyButton)
        view.addSubview(buyButtonView)
        view.addSubview(plusButton)
        view.addSubview(minusButton)
        view.addSubview(prodCountLabel)
        
        stackView.addArrangedSubview(weightLabel)
        stackView.addArrangedSubview(caloriesLabel)
        view.addSubview(stackView)
        
        //arrowView.alpha = 0.5
        //view.addSubview(arrowButton)
        
        if UserSettings.basketInfo != nil {
            setProdCountLabel()
        }
        buttonsAction()
        constraints()
        
    }
    
    init(title: String, image: String, description: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.weightLabel.text(text: "⚖️ 350 г")
        
        self.caloriesLabel.text(text: "🍽️ 253 Ккал")
        self.titleLabel.text = title
        self.prodImage.image = UIImage(named: image)
        self.descriptionLabel.text =
    """
    🎣 \(description)
    
    💡 Идеально подходит для:
    ✔ Ужинов в кругу семьи
    ✔ Званых ужинов и праздничного стола
    ✔ ЗОЖ-питания и спортивного рациона
    ✔ Любителей вкусной и полезной еды
    
    """
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProdCountLabel() {
        let bskt = UserSettings.basketInfo
        for (listIndex, list) in bskt!.enumerated() { // Итерация по каждому подмассиву
            if let itemIndex = list.firstIndex(where: { $0.title == self.titleLabel.text }) { // Пытаемся найти индекс элемента
                self.prodCountLabel.text = "\(bskt![listIndex][0].quantity)"
                self.prodCount = bskt![listIndex][0].quantity
                break
            }
        }
        
        check?()
        
        if prodCount > 0 && inStock == true {
            buyButton.alpha = 0
            buyButtonView.alpha = 1
            minusButton.alpha = 1
            prodCountLabel.alpha = 1
            buyButton.alpha = 0
            plusButton.alpha = 1
        } else {
            if prodCount > 0 && inStock == false {
                buyButton.alpha = 0
                buyButtonView.alpha = 1
                minusButton.alpha = 1
                prodCountLabel.alpha = 1
                buyButton.alpha = 0
                plusButton.alpha = 0
            }
        }
    }
    
    func buttonsAction() {
        arrowButton.addTarget(self, action: #selector(arrowButtonAction), for: .touchUpInside)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func arrowButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func updateProdCount(in lists: inout [[BasketInfo]], newValue: Int) {
        for (listIndex, list) in lists.enumerated() { // Итерация по каждому подмассиву
            if let itemIndex = list.firstIndex(where: { $0.title == self.titleLabel.text }) { // Пытаемся найти индекс элемента
                lists[listIndex][itemIndex].quantity = newValue
                
                if newValue == 0 {
                    lists[listIndex] = []
                } else {
                    lists[listIndex][itemIndex].quantity = newValue
                }
                break
            }
        }
    }
    
    @objc
    func buyButtonTapped() {
        descBasketTap?()
        
        if prodCount == 0 {
            buyButton.alpha = 0
            buyButtonView.alpha = 1
            minusButton.alpha = 1
            plusButton.alpha = 1
            prodCountLabel.alpha = 1
        }
        
        prodCount += 1
        prodCountLabel.text = "\(prodCount)"
        bskt = UserSettings.basketInfo
        //updateProdCount(in: &bskt!, newValue: prodCount)
        //UserSettings.basketInfo = bskt
        
        print("#CardInfoController#buyButtonTapped#BasketInfo = \(UserSettings.basketInfo ?? [])")
    }
    
    @objc
    func minusButtonTapped() {
        descMinusTap?()
        if prodCount != 0 {
            prodCount -= 1
            prodCountLabel.text = "\(prodCount)"
            
            updateProdCount(in: &bskt, newValue: prodCount)
            
            
            UserSettings.basketInfo = bskt
            //UserSettings.basketProdQuant -= 1
        }
        
        if prodCount == 0 {
            buyButton.alpha = 1
            buyButtonView.alpha = 0
            minusButton.alpha = 0
            plusButton.alpha = 0
            prodCountLabel.alpha = 0
        }
        
        print("#CardInfoController#minusButtonTapped#BasketInfo = \(UserSettings.basketInfo ?? [])")
    }
    
    @objc
    func plusButtonTapped() {
        descPlusTap?()
        prodCount += 1
        prodCountLabel.text = "\(prodCount)"
        
        updateProdCount(in: &bskt, newValue: prodCount)
        //UserSettings.basketProdQuant += 1
        UserSettings.basketInfo = bskt
    }
    
    func checkAvailability(inStock: Bool) {
        if prodCount != 0 {
            if inStock == false {
                plusButton.alpha = 0
                self.inStock = inStock
            } else {
                plusButton.alpha = 1
                self.inStock = inStock
            }
        }
        print("#CardInfoController#plusButtonTapped#BasketInfo = \(UserSettings.basketInfo ?? [])")
    }
    
    func constraints() {
        
        NSLayoutConstraint.activate([
            
            prodImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            prodImage.topAnchor.constraint(equalTo: view.topAnchor),
            prodImage.widthAnchor.constraint(equalToConstant: view.bounds.width - 24),
            prodImage.heightAnchor.constraint(equalToConstant: view.bounds.height/3.5),
            
            titleLabel.topAnchor.constraint(equalTo: prodImage.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: prodImage.leadingAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            //stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: prodImage.trailingAnchor),
            
            buyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buyButton.widthAnchor.constraint(equalToConstant: view.bounds.width - 32),
            buyButton.heightAnchor.constraint(equalToConstant: 50),
            
            buyButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            buyButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buyButtonView.widthAnchor.constraint(equalToConstant: view.bounds.width - 32),
            buyButtonView.heightAnchor.constraint(equalToConstant: 50),
            
            minusButton.leadingAnchor.constraint(equalTo: buyButton.leadingAnchor),
            minusButton.topAnchor.constraint(equalTo: buyButton.topAnchor),
            minusButton.bottomAnchor.constraint(equalTo: buyButton.bottomAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: 50),
            
            plusButton.trailingAnchor.constraint(equalTo: buyButton.trailingAnchor),
            plusButton.topAnchor.constraint(equalTo: buyButton.topAnchor),
            plusButton.bottomAnchor.constraint(equalTo: buyButton.bottomAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 50),
            
            prodCountLabel.centerXAnchor.constraint(equalTo: buyButtonView.centerXAnchor),
            prodCountLabel.centerYAnchor.constraint(equalTo: buyButtonView.centerYAnchor),
            prodCountLabel.heightAnchor.constraint(equalToConstant: 30),
            prodCountLabel.widthAnchor.constraint(equalToConstant: 30),
            
            //            arrowButton.centerXAnchor.constraint(equalTo: arrowView.centerXAnchor),
            //            arrowButton.centerYAnchor.constraint(equalTo: arrowView.centerYAnchor),
            //            arrowButton.heightAnchor.constraint(equalToConstant: 18),
            //            arrowButton.widthAnchor.constraint(equalToConstant: 9),
            //
            //            arrowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            //            arrowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //            arrowView.heightAnchor.constraint(equalToConstant: 56),
            //            arrowView.widthAnchor.constraint(equalToConstant: 80),
        ])
        
        
    }
}


