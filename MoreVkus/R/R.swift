//
//  R.swift
//  FishShop
//
//  Created by Мурат Кудухов on 08.03.2024.
//

import UIKit

enum R {
    enum Colors {
        static let green = UIColor(hexString: "#00D971")
        static let sep = UIColor(hexString: "#2D344B")
        static let text = UIColor(hexString: "#EBEBF5")
        static let active = UIColor(hexString: "#4870FF")
        static let inactive = UIColor(hexString: "#8E8E93")
        //static let background = UIColor(hexString: "#121516")
        static let background = UIColor.white//UIColor(hexString: "#f5f6fa")
        static let white = UIColor(hexString: "#ecf0f1")
        static let silver = UIColor(hexString: "#bdc3c7")
        static let bar = UIColor(hexString: "#1C1E1F")
        //static let barBg = UIColor(hexString: "#252627")
        static let barBg = UIColor.systemGray6
        static let mapColor = UIColor(hexString: "#F8F4EB")
    }
    enum Images {
       
        
    }
    
    enum Fonts {
        //        static func AbbZee(with size: CGFloat) -> UIFont {
        //            UIFont(name: "ABeeZee", size: size) ?? UIFont()
        static func Italic(with size: CGFloat) -> UIFont {
            UIFont(name: "GillSans-SemiBoldItalic", size: size) ?? UIFont()
        }
        
        static func avenirBook(with size: CGFloat) -> UIFont {
            UIFont(name: "Avenir-Book", size: size) ?? UIFont()
        }
        
        static func avenirBold(with size: CGFloat) -> UIFont {
            UIFont(name: "AvenirNext-Bold", size: size) ?? UIFont()
        }
        static func nonItalic(with size: CGFloat) -> UIFont {
            UIFont(name: "GillSans-SemiBold", size: size) ?? UIFont()
        }
        
        static func trebuchet(with size: CGFloat) -> UIFont {
            UIFont(name: "TrebuchetMS-Bold", size: size) ?? UIFont()
        }
        
        static func gillSans(with size: CGFloat) -> UIFont {
            UIFont(name: "Gill Sans", size: size) ?? UIFont()
        }
    }
}
