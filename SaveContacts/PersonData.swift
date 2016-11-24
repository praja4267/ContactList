//
//  PersonData.swift
//  SaveContacts
//
//  Created by Active Mac05 on 24/11/16.
//  Copyright © 2016 techactive. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class PersonDataMO: NSManagedObject {
    
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var phone: String?
    @NSManaged var birthDate: NSDate?
    @NSManaged var emailAddress: String?
    @NSManaged var image: NSData?
    @NSManaged var address: String?
    
}
