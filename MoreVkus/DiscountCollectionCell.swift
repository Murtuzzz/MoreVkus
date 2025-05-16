//
//  DiscountCollectionCell.swift
//  SparMainScreen
//
//  Created by Мурат Кудухов on 11.08.2023.
//

import UIKit

class DiscountCollectionCell: UICollectionViewCell {
    
    static var id = "DiscountCollectionCell"
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let infoViewOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let infoViewTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let imageViewBackground: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "products")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Album"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabelOne: UILabel = {
        let label = UILabel()
        label.text = "СКИДКИ ДО 30%"
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabelTwo: UILabel = {
        let label = UILabel()
        label.text = "C 13 ПО 15 ИЮЛЯ"
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.addSubview(container)
        contentView.addSubview(imageViewBackground)
        contentView.addSubview(imageView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(infoViewOne)
        contentView.addSubview(infoViewTwo)
        contentView.addSubview(infoLabelOne)
        contentView.addSubview(infoLabelTwo)
        
        contentView.clipsToBounds = true
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    public func configure(label: String, image: UIImage) {
        mainLabel.text = label
        imageViewBackground.image = image
        
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            
            infoLabelOne.centerXAnchor.constraint(equalTo: infoViewOne.centerXAnchor),
            infoLabelOne.centerYAnchor.constraint(equalTo: infoViewOne.centerYAnchor),
            
            infoLabelTwo.centerXAnchor.constraint(equalTo: infoViewTwo.centerXAnchor),
            infoLabelTwo.centerYAnchor.constraint(equalTo: infoViewTwo.centerYAnchor),
            
            infoViewOne.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            infoViewOne.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            infoViewOne.heightAnchor.constraint(equalToConstant: 25),
            infoViewOne.widthAnchor.constraint(equalToConstant: 115),
            
            infoViewTwo.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            infoViewTwo.leadingAnchor.constraint(equalTo: infoViewOne.trailingAnchor, constant: 8),
            infoViewTwo.heightAnchor.constraint(equalToConstant: 25),
            infoViewTwo.widthAnchor.constraint(equalToConstant: 115),
            
            imageViewBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageViewBackground.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -8),
            imageViewBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageViewBackground.topAnchor.constraint(equalTo: topAnchor),
            
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 72),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            mainLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            mainLabel.widthAnchor.constraint(equalToConstant: 80)
          
            
        ])
    }
    
}




