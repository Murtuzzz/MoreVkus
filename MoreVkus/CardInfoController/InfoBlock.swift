//
//  InfoBlock.swift
//  FishShop
//
//  Created by Мурат Кудухов on 18.03.2024.
//

import UIKit

final class ProdInfoView: UIView {
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let info: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        addSubview(info)
        constraints()
    }
    
    init(title: String, info: String) {
        super.init(frame: .zero)
        
        self.title.text = title
        self.info.text = info
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            info.centerXAnchor.constraint(equalTo: centerXAnchor),
            info.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
        ])
        
    }
   
}
