//
//  Person+CoreDataProperties.swift
//  PersonalPlanner
//
//  Created by Anton Yaroshchuk on 08.07.2021.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var fio: String
    @NSManaged public var email: String
    @NSManaged public var id: UUID
    @NSManaged public var personToAction: NSSet
    
}

// MARK: Generated accessors for personToAction
extension Person {

    @objc(addPersonToActionObject:)
    @NSManaged public func addToPersonToAction(_ value: PersonAction)

    @objc(removePersonToActionObject:)
    @NSManaged public func removeFromPersonToAction(_ value: PersonAction)

    @objc(addPersonToAction:)
    @NSManaged public func addToPersonToAction(_ values: NSSet)

    @objc(removePersonToAction:)
    @NSManaged public func removeFromPersonToAction(_ values: NSSet)

}

extension Person : Identifiable {

}
