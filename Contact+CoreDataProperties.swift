//
//  Contact+CoreDataProperties.swift
//  pokeContact
//
//  Created by 내꺼다 on 7/18/24.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profileImageData: Data?

}

extension Contact : Identifiable {

}
