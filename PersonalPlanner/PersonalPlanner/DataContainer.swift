//
//  DataContainer.swift
//  PersonalPlanner
//
//  Created by Anton Yaroshchuk on 12.07.2021.
//

import Foundation
import CoreData


class DataContainer: NSPersistentContainer {
    var personsList = [Person]()
    var checksList = [Action]()
    var boundsList = [PersonAction]()
    
    static let shared: DataContainer = {
        let container = DataContainer(name: "PersonalPlanner")
        container.loadPersistentStores {(desc, error) in
            if let error = error {
                fatalError("Big problems: \(error)")
            }
            print("Successfully loaded persistent container store at: \(desc.url?.description ?? "nil")")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyStoreTrumpMergePolicyType)
        return container
    }()
    
    func loadSavedData(){
        let requestPersons = Person.createFetchRequest()
        let requestActions = Action.createFetchRequest()
        let requestPersonActions = PersonAction.createFetchRequest()
        let sortPersons = NSSortDescriptor(key: "fio", ascending: true)
        let sortActions = NSSortDescriptor(key: "name", ascending: true)
        requestPersons.sortDescriptors = [sortPersons]
        requestActions.sortDescriptors = [sortActions]
        
        
        do {
            personsList = try DataContainer.shared.viewContext.fetch(requestPersons)
            checksList = try DataContainer.shared.viewContext.fetch(requestActions)
            boundsList = try DataContainer.shared.viewContext.fetch(requestPersonActions)
        } catch {
            print("Fetch failed.")
        }
    }
    
    func saveContext(){
        if DataContainer.shared.viewContext.hasChanges {
            do {
                try DataContainer.shared.viewContext.save()
                DataContainer.shared.loadSavedData()
            } catch {
                print("An error occured while saving: \(error)")
            }
        }
    }
    
    func addPerson(name: String, email: String){
        let person = Person(context: DataContainer.shared.viewContext)
        person.fio = name
        person.email = email
        person.id = UUID()
        DataContainer.shared.addChecksForNewPerson(person)
        DataContainer.shared.saveContext()
    }
    
    func addAction(name: String, period: Int64){
        let action = Action(context: DataContainer.shared.viewContext)
        action.id = UUID()
        action.name = name
        action.period = period
        DataContainer.shared.addChecksForNewAction(action)
        DataContainer.shared.saveContext()
    }
    
  func addChecksForNewPerson(_ person: Person){
        if checksList.isEmpty { return }
        for action in checksList{
            let personCheck = PersonAction(context: DataContainer.shared.viewContext)
            personCheck.actionID = action.id
            personCheck.personID = person.id
            personCheck.date = Date()
        }
    }
    
    func addChecksForNewAction(_ action: Action){
        if personsList.isEmpty { return }
        for person in personsList{
            let personCheck = PersonAction(context: DataContainer.shared.viewContext)
            personCheck.actionID = action.id
            personCheck.personID = person.id
            personCheck.date = Date()
        }
    }
    
    func checkForAlerts() -> Int{
        var count = 0
        for person in personsList{
            for check in checksList{
                for bound in boundsList{
                    if bound.personID == person.id && bound.actionID == check.id{
                        let daysLeft = calcTimeReminder(from: Date(), to: Date(timeInterval: calcTimeInterval(check.period), since: bound.date))
                        if daysLeft < 30{
                            count += 1
                        }
                    }
                }
            }
        }
        return count
    }
    
    func calcTimeInterval(_ period: Int64) -> Double{
        return Double(period * 2592000)
    }
    
    func calcTimeReminder(from: Date, to: Date) -> Int{
        return Int(from.distance(to: to) / 86400)
    }
}
