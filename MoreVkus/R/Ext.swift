//
//  Ext.swift
//  FishShop
//
//  Created by Мурат Кудухов on 18.03.2024.
//

import UIKit
import ImageIO

public extension UIImage {

    @nonobjc class var gifAsset: UIImage? {
        if let asset = NSDataAsset(name: "fishGif") {
            return UIImage.gif(data: asset.data)
        }
        return nil
    }

    static func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }

        var images = [CGImage]()

        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
        }
        
        return UIImage.animatedImage(with: images.map { UIImage(cgImage: $0) }, duration: 4.0)
    }
}


