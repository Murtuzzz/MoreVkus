//
//  RoutePolylineStyles.swift
//  MapRouting
//

import YandexMapsMobile

extension YMKPolylineMapObject {
    func styleMainRoute() {
        zIndex = 10.0
        setStrokeColorWith(.systemBlue)
        strokeWidth = 1.0
        outlineColor = .black
        outlineWidth = 2.0
    }

    func styleAlternativeRoute() {
        zIndex = 5.0
        setStrokeColorWith(.clear)
        strokeWidth = 4.0
        outlineColor = .clear
        outlineWidth = 2.0
    }
}
