//
//  PersonAction+CoreDataProperties.swift
//  PersonalPlanner
//
//  Created by Anton Yaroshchuk on 08.07.2021.
//
//

import Foundation
import CoreData


extension PersonAction {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PersonAction> {
        return NSFetchRequest<PersonAction>(entityName: "PersonAction")
    }

    @NSManaged public var personID: UUID
    @NSManaged public var actionID: UUID
    @NSManaged public var date: Date
    @NSManaged public var personChain: Person
    @NSManaged public var actionChain: Action

}

extension PersonAction : Identifiable {

}
