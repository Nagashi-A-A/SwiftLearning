//
//  AppDelegate.swift
//  PersonalPlanner
//
//  Created by Anton Yaroshchuk on 08.07.2021.
//

import UIKit
import CoreData
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataContainer.shared.loadSavedData()
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.ammolite.planer.checkforupdate", using: nil) {(task) in
            self.checkForAlerts(task: task as! BGAppRefreshTask)
            print("Task was added from didFinish")
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        DataContainer.shared.loadSavedData()
        let amount = DataContainer.shared.checkForAlerts()
        print("Check was started! Yay!")
        UIApplication.shared.applicationIconBadgeNumber = amount
        print("Background catched app")
        scheduleAppCheck()
    }
    
    func scheduleAppCheck(){
        let request = BGAppRefreshTaskRequest(identifier: "com.ammolite.planer.checkforupdate")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 86000)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Request was added!")
        } catch {
            print("Could not schedule app check: \(error)")
        }
    }
    
    func checkForAlerts(task: BGAppRefreshTask){
        scheduleAppCheck()
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        let operation = {
            DataContainer.shared.loadSavedData()
            let amount = DataContainer.shared.checkForAlerts()
            print("Check was started! Yay!")
            if amount > 0 {
                UIApplication.shared.applicationIconBadgeNumber = amount
            }
        }
        
        queue.addOperation(operation)
        print("Queue was updated with task")
        
    }
    

    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PersonalPlanner")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

