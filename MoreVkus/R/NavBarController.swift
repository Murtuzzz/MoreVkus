//
//  NavBarController.swift
//  FishShop
//
//  Created by Мурат Кудухов on 08.03.2024.
//

import UIKit

final class NavBarController: UINavigationController {
    override func viewDidLoad() {
        navigationBar.isTranslucent = false
        view.backgroundColor = R.Colors.background
        navigationBar.tintColor = .black
    }
}
