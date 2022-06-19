//
//  Capital.swift
//  CapitalCities
//
//  Created by Yi An Chen on 2022/4/16.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var url: URL?
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, url: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.url = URL(string: url)
    }
}
