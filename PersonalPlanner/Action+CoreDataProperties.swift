//
//  Action+CoreDataProperties.swift
//  PersonalPlanner
//
//  Created by Anton Yaroshchuk on 08.07.2021.
//
//

import Foundation
import CoreData


extension Action {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Action> {
        return NSFetchRequest<Action>(entityName: "Action")
    }

    @NSManaged public var name: String
    @NSManaged public var id: UUID
    @NSManaged public var period: Int64
    @NSManaged public var actionToPerson: NSSet

}

// MARK: Generated accessors for actionToPerson
extension Action {

    @objc(addActionToPersonObject:)
    @NSManaged public func addToActionToPerson(_ value: PersonAction)

    @objc(removeActionToPersonObject:)
    @NSManaged public func removeFromActionToPerson(_ value: PersonAction)

    @objc(addActionToPerson:)
    @NSManaged public func addToActionToPerson(_ values: NSSet)

    @objc(removeActionToPerson:)
    @NSManaged public func removeFromActionToPerson(_ values: NSSet)

}

extension Action : Identifiable {

}
