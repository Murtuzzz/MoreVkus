//
//  DiscountCollectionView.swift
//  SparMainScreen
//
//  Created by Мурат Кудухов on 11.08.2023.
//

import UIKit


struct DiscountItems {
    let title: String
    let image: UIImage
    let discount: Bool
}

final class DiscountCollectionView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    private var dataSource:[DiscountItems] = []
    private var collectionView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionApperance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func collectionApperance() {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        dataSource = [.init(title: "Привелегии Мой SPAR", image: UIImage(named: "Image")!, discount: false),
                      .init(title: "Мы в соцсетях", image: UIImage(named: "poster")!, discount: true),
                      
        ]
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         
        guard let collectionView = collectionView else {return}
        
        collectionView.register(DiscountCollectionCell.self, forCellWithReuseIdentifier: DiscountCollectionCell.id)
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                   collectionView.topAnchor.constraint(equalTo: topAnchor),
                   collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                   collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                   collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
               ])
    }
}



extension DiscountCollectionView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscountCollectionCell.id, for: indexPath) as! DiscountCollectionCell
        
        let item = dataSource[indexPath.row]
        
        cell.configure(label: item.title, image: item.image, discount: item.discount)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 174)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


