//
//  CellStruct.swift
//  PersonalPlanner
//
//  Created by Anton Yaroshchuk on 08.07.2021.
//

import Foundation

struct CellStruct {
    var checkDate: String = ""
    var endDate: String = ""
    var alert: Int = 0
    
    init(person: Person, action: Action, checks: [PersonAction]){
        for check in checks{
            if person.id == check.personID && action.id == check.actionID{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                
                checkDate = dateFormatter.string(from: check.date)
                endDate = dateFormatter.string(from: Date(timeInterval: calcTimeInterval(action.period), since: check.date))
                alert = calcTimeReminder(from: Date(), to: Date(timeInterval: calcTimeInterval(action.period), since: check.date))
                if alert < 0 {
                    alert = 0
                }
            }
        }
    }
    
    func calcTimeInterval(_ period: Int64) -> Double{
        return Double(period * 2592000)
    }
    
    func calcTimeReminder(from: Date, to: Date) -> Int{
        return Int(from.distance(to: to) / 86400)
        
    }
}
