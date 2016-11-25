//
//  Person+CoreDataProperties.swift
//  SaveContacts
//
//  Created by Active Mac05 on 25/11/16.
//  Copyright © 2016 techactive. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var address: String?
    @NSManaged var birthDate: String?
    @NSManaged var emailAddress: String?
    @NSManaged var firstName: String?
    @NSManaged var image: NSData?
    @NSManaged var lastName: String?
    @NSManaged var phoneNumber: String?

}
