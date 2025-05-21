//
//  CatalogCollection.swift
//  FishShop
//
//  Created by Мурат Кудухов on 12.05.2025.
//

import UIKit


struct RecomendationItems {
    let title: String
    let image: UIImage
    let categoryId: Int
    
}

final class RecomendationCollection: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private var dataSource:[RecomendationItems] = []
    private var collectionView: UICollectionView?
    var onCellTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionApperance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func collectionApperance() {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        dataSource = [.init(title: "Рыба", image: UIImage(named: "frzFish")!, categoryId: 1),
                      .init(title: "Колбасы, сосиски",image: UIImage(named: "sosi")!,categoryId: 2),
                      .init(title: "Полуфабрикаты", image: UIImage(named: "froz")!,categoryId: 3),
                      .init(title: "Молочные продукты", image: UIImage(named: "milk")!,categoryId: 4),
                      .init(title: "Овощи", image: UIImage(named: "veget")!,categoryId: 5),
                      .init(title: "Напитки", image: UIImage(named: "drinks")!, categoryId: 6),
                      
        ]
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         
        guard let collectionView = collectionView else {return}
        
        collectionView.register(RecomendationCell.self, forCellWithReuseIdentifier: RecomendationCell.id)
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        
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

extension RecomendationCollection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendationCell.id, for: indexPath) as! RecomendationCell
        
        let item = dataSource[indexPath.row]
        
        cell.configure(label: item.title, image: item.image, categoryId: 1)
        
        cell.layer.shadowColor = UIColor.systemGray3.cgColor
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shadowRadius = 5.0;
        cell.layer.shadowOffset = CGSizeMake(4, 4);
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        let totalSpacing = layout.minimumInteritemSpacing * (2 - 1)
        let width = (collectionView.bounds.width - totalSpacing) / 3
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        print(item.title)
        UserSettings.currentController = indexPath.row
        onCellTap?()
    }
}



