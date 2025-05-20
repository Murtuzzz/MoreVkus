//
//  DeliveryCell.swift
//  FishShop
//
//  Created by Мурат Кудухов on 05.04.2024.
//

import UIKit

final class DeliveryCell: UITableViewCell {
    
    static var id = "DeliveryCell"
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = R.Fonts.avenirBook(with: 14)
        label.text = ""
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = R.Fonts.avenirBook(with: 18)
        label.text = ""
        return label
    }()
    
    private let prodImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(mainView)
        addSubview(prodImage)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(countLabel)
        backgroundColor = .clear
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(title: String, quantity: Int, price: Int) {
        self.titleLabel.text = "\(title)"
        prodImage.image = UIImage(named: "\(title)")
        countLabel.text = "\(quantity)"
        priceLabel.text = "\(price) ₽"
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: prodImage.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -8),
            titleLabel.widthAnchor.constraint(equalToConstant: bounds.width - 24),
            
            priceLabel.leadingAnchor.constraint(equalTo: prodImage.trailingAnchor, constant: 16),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: bounds.width - 24),
            
            prodImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8),
            prodImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            prodImage.widthAnchor.constraint(equalToConstant: 64),
            prodImage.heightAnchor.constraint(equalToConstant: 64),
            
            countLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.widthAnchor.constraint(equalToConstant: 8),
            countLabel.heightAnchor.constraint(equalToConstant: 24),
            
            mainView.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

