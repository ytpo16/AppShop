//
//  Product+CoreDataProperties.swift
//  
//
//  Created by Admin on 24/02/2017.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product");
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var amount: Int32

}
