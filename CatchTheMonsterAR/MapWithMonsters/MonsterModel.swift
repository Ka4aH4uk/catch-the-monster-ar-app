//
//  MonsterModel.swift
//  CatchTheMonsterAR
//

import UIKit
import CoreLocation

struct CodableCoordinate: Codable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    init(coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct Monster: Identifiable, Encodable, Decodable {
    let id = UUID()
    var name: String
    let image: UIImage
    let level: Int
    let coordinate: CodableCoordinate
    var distanceToUser: CLLocationDistance = 0
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, level, coordinate, distanceToUser, description
    }
    
    init(name: String, image: UIImage, level: Int, coordinate: CLLocationCoordinate2D, description: String) {
        self.name = name
        self.image = image
        self.level = level
        self.coordinate = CodableCoordinate(coordinate: coordinate)
        self.description = description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        
        if let imageData = try? container.decode(Data.self, forKey: .image),
           let decodedImage = UIImage(data: imageData) {
            image = decodedImage
        } else {
            image = UIImage()
        }
        
        level = try container.decode(Int.self, forKey: .level)
        coordinate = try container.decode(CodableCoordinate.self, forKey: .coordinate)
        distanceToUser = try container.decode(CLLocationDistance.self, forKey: .distanceToUser)
        description = try container.decode(String.self, forKey: .description)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        
        if let imageData = image.pngData() {
            try container.encode(imageData, forKey: .image)
        }
        
        try container.encode(level, forKey: .level)
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(distanceToUser, forKey: .distanceToUser)
        try container.encode(description, forKey: .description)
    }
}

