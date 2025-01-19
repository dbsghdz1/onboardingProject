//
//  Users+CoreDataProperties.swift
//  
//
//  Created by 김윤홍 on 1/18/25.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }
    
    @NSManaged public var nickName: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?

}
