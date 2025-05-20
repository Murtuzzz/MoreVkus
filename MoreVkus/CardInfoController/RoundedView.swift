//
//  КщгтвувМшуц.swift
//  FishShop
//
//  Created by Мурат Кудухов on 17.03.2024.
//

import UIKit

class RoundedView: UIView {
    
    private let viewOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.bar
        return view
    }()
    
    private let viewTwo: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = R.Colors.bar
        //view.backgroundColor = R.Colors.barBg
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(viewOne)
        addSubview(viewTwo)
        
        translatesAutoresizingMaskIntoConstraints = false 
        constraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            viewOne.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewOne.topAnchor.constraint(equalTo: topAnchor),
            viewOne.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewOne.trailingAnchor.constraint(equalTo: viewTwo.leadingAnchor, constant: 24),
            
            viewTwo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            viewTwo.topAnchor.constraint(equalTo: topAnchor),
            viewTwo.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewTwo.trailingAnchor.constraint(equalTo: trailingAnchor),
        
        ])
    }
}
