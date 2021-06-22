//
//  Location+CoreDataClass.swift
//  MyLocations
//
//  Created by Sabir Myrzaev on 21.06.2021.
//
//

import Foundation
import CoreData
import MapKit

@objc(Location)
public class Location: NSManagedObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(longitude, latitude)
    }
    
    public var title: String? {
        
        if locationDescription.isEmpty {
            return "No Description"
        } else {
            return locationDescription
        }
    }
    
    public var subtitle: String? {
        return category
    }
    
    var hasPhoto: Bool {
        return photoID != nil
    }
    // Это свойство вычисляет полный URL-адрес файла JPEG для фотографии
    var photoURL: URL {
        assert(photoID != nil, "ID фотографии не установлен")
        let filename = "Photo - \(photoID!.intValue).jpg"
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    // возвращает UIImageобъект, загружая файл изображения
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoURL.path)
    }

    class func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PhotoID") + 1
        userDefaults.set(currentID, forKey: "PhotoID")
        return currentID
    }

    func removePhotoFile() {
        if hasPhoto {
            do {
                try FileManager.default.removeItem(at: photoURL)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

