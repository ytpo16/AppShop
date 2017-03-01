//
//  Product+CoreDataProperties.swift
//  
//
//  Created by Admin on 27/02/2017.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product");
    }

    @NSManaged public var amount: Int16
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var price: Double

}
