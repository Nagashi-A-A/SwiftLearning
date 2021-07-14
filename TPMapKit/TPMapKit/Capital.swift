//
//  Capital.swift
//  Project16
//
//  Created by Anton Yaroshchuk on 28.06.2021.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var info: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.info = info
        self.coordinate = coordinate
    }

}
