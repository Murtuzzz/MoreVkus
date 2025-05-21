//
//  MilkCell.swift
//  MoreVkus
//
//  Created by Мурат Кудухов on 21.05.2025.
//

import UIKit

final class MilkCollectionCell: UICollectionViewCell {

    static var id = "MilkCollectionCell"

    private var prodId = 0
    private var prodCount = 0

    private var minBasketWidth: CGFloat = 40
    private var basketViewWidth: NSLayoutConstraint? = nil
    private var activeTimer: Timer?
    private var inactiveTimer: Timer?
    private var condition = false
    var bskt: [[BasketInfo]] = []

    var buttonClicked: (() -> Void)?
    var onPlusTap: (() -> Void)?
    var onMinusTap: (() -> Void)?

    weak var cellDelegate: CellDelegate?
    weak var basketDelegate: BasketCellDelegate?

    private let basketView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let imageBg: UIView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private let container: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .gray.withAlphaComponent(0.5)
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = R.Fonts.trebuchet(with: 16)
        label.textAlignment = .left
        return label
    }()

    private var prodCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = R.Fonts.trebuchet(with: 18)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = R.Fonts.avenirBook(with: 12)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    private let basketButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setImage(UIImage(systemName: "basket"), for: .normal)
        button.setTitle("В корзину", for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        return button
    }()

    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        return button
    }()

    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        return button
    }()

    private let infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
       // button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.contentMode = .scaleAspectFit
        button.tintColor = .clear
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
       // contentView.backgroundColor = .systemGray6
       // bskt = UserSettings.basketInfo
        contentView.addSubview(imageBg)
        contentView.addSubview(container)
        contentView.addSubview(priceLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(basketView)
        contentView.addSubview(prodCountLabel)
        contentView.addSubview(removeButton)
        contentView.addSubview(addButton)
        contentView.addSubview(infoButton)
        contentView.addSubview(basketButton)
        
        backgroundColor = .clear
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageBg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageBg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            imageBg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            imageBg.heightAnchor.constraint(equalTo: imageBg.widthAnchor),
            //imageBg.heightAnchor.constraint(equalTo: container.widthAnchor),
            
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.heightAnchor.constraint(equalTo: container.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageBg.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            //priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: basketView.topAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.heightAnchor.constraint(equalToConstant: 32),
            priceLabel.widthAnchor.constraint(equalToConstant: 80),
            
            basketView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            basketView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            basketView.heightAnchor.constraint(equalToConstant: 40),
            basketView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            basketView.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            
            basketButton.centerYAnchor.constraint(equalTo: basketView.centerYAnchor),
            basketButton.centerXAnchor.constraint(equalTo: basketView.centerXAnchor),
            basketButton.heightAnchor.constraint(equalToConstant: 32),
            basketButton.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 16),
            
            prodCountLabel.centerYAnchor.constraint(equalTo: basketView.centerYAnchor),
            prodCountLabel.centerXAnchor.constraint(equalTo: basketView.centerXAnchor),
            
            addButton.centerYAnchor.constraint(equalTo: basketView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: basketView.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            
            removeButton.centerYAnchor.constraint(equalTo: basketView.centerYAnchor),
            removeButton.leadingAnchor.constraint(equalTo: basketView.leadingAnchor),
            removeButton.heightAnchor.constraint(equalToConstant: 40),
            removeButton.widthAnchor.constraint(equalToConstant: 40),
            
            infoButton.topAnchor.constraint(equalTo: container.topAnchor),
            infoButton.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            infoButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            infoButton.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }

    private func setupActions() {
        basketButton.addTarget(self, action: #selector(basketButtonTapped), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    }

    func configure(with item: CardInfo, shouldHideAddButton: Bool = false) {
        container.image = UIImage(named: item.image)
        titleLabel.text = item.title
        priceLabel.text = "\(item.price) ₽"
        prodId = item.prodId
        prodCount = item.prodCount
        prodCountLabel.text = "\(item.prodCount)"
        
        if item.prodCount > 0 {
            basketButton.alpha = 0
            addButton.alpha = (item.inStock && item.prodCount < item.productCount) ? 1 : 0
            removeButton.alpha = 1
            prodCountLabel.alpha = 1
            basketView.alpha = 1
        } else {
            basketButton.alpha = 1
            addButton.alpha = 0
            removeButton.alpha = 0
            prodCountLabel.alpha = 0
            basketView.alpha = 0
        }
        
        hideAddButton(shouldHideAddButton)
        
        if shouldHideAddButton && item.prodCount > 0 {
            addMaxQuantityLabel()
        } else {
            removeMaxQuantityLabel()
        }
    }

    @objc private func basketButtonTapped() {
        basketDelegate?.didTapBasketButton(inCell: self)
    }

    @objc private func infoButtonTapped() {
        cellDelegate?.infoButtonTapped(cell: self)
    }

    @objc private func plusButtonTapped() {
        onPlusTap?()
    }

    @objc private func minusButtonTapped() {
        onMinusTap?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        container.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        prodCountLabel.text = nil
        basketButton.alpha = 1
        addButton.alpha = 0
        removeButton.alpha = 0
        prodCountLabel.alpha = 0
        basketView.alpha = 0
    }

    func hideAddButton(_ hide: Bool) {
        addButton.isHidden = hide
        addButton.isEnabled = !hide
    }

    private var maxQuantityLabel: UILabel?

    private func addMaxQuantityLabel() {
        if maxQuantityLabel == nil {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Макс."
            label.font = R.Fonts.avenirBook(with: 10)
            label.textColor = .systemGray
            label.textAlignment = .center
            contentView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: addButton.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            ])
            
            maxQuantityLabel = label
        }
        maxQuantityLabel?.isHidden = false
    }

    private func removeMaxQuantityLabel() {
        maxQuantityLabel?.isHidden = true
    }
}

extension MilkCollectionCell {
    func blurEffect(someView: UIView) {
        // Создание объекта `UIBlurEffect` со стилем эффекта.
            // .extraLight, .light, .dark, .regular и .prominent - на выбор в зависимости от желаемого эффекта.
        let blurEffect = UIBlurEffect(style: .dark)

            // Создание объекта `UIVisualEffectView`, который будет использовать `blurEffect`.
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //blurEffectView.alpha = 0.9
        blurEffectView.frame = someView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        someView.addSubview(blurEffectView)
    }
}
