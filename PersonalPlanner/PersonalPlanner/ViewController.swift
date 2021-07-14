//
//  ViewController.swift
//  PersonalPlanner
//
//  Created by Anton Yaroshchuk on 08.07.2021.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var activeCheck: Action!
    var activePerson: Person!
    var sortStyleByPerson = false
    var dateChangePerson: Person!
    var dateChangeAction: Action!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: NSNotification.Name(rawValue: "reload"), object: nil)
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]){(granted, error) in
            if granted{
                print("Access granted.")
            } else {
                print("Access denied.")
            }
        }
        
        if DataContainer.shared.checksList.isEmpty && !sortStyleByPerson{
            title = "Список событий пуст"
        }
        
        if DataContainer.shared.personsList.isEmpty && sortStyleByPerson{
            title = "Список сотрудников пуст"
        }
        
        
        // Navigation buttons:
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Меню", style:.plain, target: self, action: #selector(openMenu))
        
        
        if !sortStyleByPerson && !DataContainer.shared.checksList.isEmpty{
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "События", style: .plain, target: self, action: #selector(showActions))
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        cell.layer.cornerRadius = 15
        
        var bgStyle: Int = 0
            if !DataContainer.shared.checksList.isEmpty && !sortStyleByPerson{
                if !DataContainer.shared.personsList.isEmpty{
                    let cellData = CellStruct(person: DataContainer.shared.personsList[indexPath.row], action: activeCheck, checks: DataContainer.shared.boundsList)
                    cell.name.text = DataContainer.shared.personsList[indexPath.row].fio
                    cell.dateOfCheck.text = "Дата проверки: \(cellData.checkDate)"
                    cell.endTime.text = "Дата окончания: \(cellData.endDate)"
                    cell.timeLeft.text = "Дней до окончания срока: \(cellData.alert)"
                    bgStyle = cellData.alert
                }
            }
            if !DataContainer.shared.personsList.isEmpty && sortStyleByPerson{
                if !DataContainer.shared.checksList.isEmpty{
                    self.title = activePerson?.fio ?? "Выберите сотрудника из списка"
                    let cellData = CellStruct(person: activePerson!, action: DataContainer.shared.checksList[indexPath.row], checks: DataContainer.shared.boundsList)
                    cell.name.text = DataContainer.shared.checksList[indexPath.row].name
                    cell.dateOfCheck.text = "Дата проверки: \(cellData.checkDate)"
                    cell.endTime.text = "Дата окончания: \(cellData.endDate)"
                    cell.timeLeft.text = "Дней до окончания срока: \(cellData.alert)"
                    bgStyle = cellData.alert
                }
            }
        
        
        switch bgStyle {
            case 0...30:
                cell.backgroundColor = .red
            case 31...60:
                cell.backgroundColor = .yellow
            default:
                cell.backgroundColor = .green
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !DataContainer.shared.checksList.isEmpty{
            if sortStyleByPerson{
                return DataContainer.shared.checksList.count
            } else {
                return DataContainer.shared.personsList.count
            }
        } else {
            return 0
        }
    }
    
    @objc func openMenu(){
        let ac = UIAlertController(title: "Меню", message: nil, preferredStyle: .actionSheet)
        let changeData = UIAlertAction(title: "Редактирование", style: .default, handler: goToLists)
        let sortByPerson = UIAlertAction(title: "Сортировка по сотрудникам", style: .default, handler: sortByPerson)
        let sortByAction = UIAlertAction(title: "Сортировка по событиям", style: .default, handler: sortByAction)
        ac.addAction(changeData)
        ac.addAction(sortByPerson)
        ac.addAction(sortByAction)
        
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
        present(ac, animated: true)
    }
    
    
    func sortByAction(action: UIAlertAction){
        sortStyleByPerson = false
        if !DataContainer.shared.checksList.isEmpty{
            activeCheck = DataContainer.shared.checksList[0]
            self.title = activeCheck.name
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "События", style: .plain, target: self, action: #selector(showActions))
        } else {
            self.title = "Список событий пуст"
            navigationItem.rightBarButtonItem = nil
        }
        tableView.reloadData()
    }
    
    func sortByPerson(action: UIAlertAction){
        sortStyleByPerson = true
        if !DataContainer.shared.personsList.isEmpty{
            activePerson = DataContainer.shared.personsList[0]
            self.title = activePerson.fio
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сотрудники", style: .plain, target: self, action: #selector(showPersons))
        } else {
            self.title = "Список сотрудников пуст"
            navigationItem.rightBarButtonItem = nil
        }
        tableView.reloadData()
        // add functionality to choose person
    }
    
    @objc func showActions(){
        let ac = UIAlertController(title: "Список событий", message: nil, preferredStyle: .actionSheet)
        for action in DataContainer.shared.checksList{
            let newAction = UIAlertAction(title: action.name, style: .default){
                [unowned self] _ in
                activeCheck = action
                self.title = activeCheck.name
                tableView.reloadData()
            }
            ac.addAction(newAction)
        }
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    @objc func showPersons(){
        let ac = UIAlertController(title: "Список сотрудников", message: nil, preferredStyle: .actionSheet)
        for person in DataContainer.shared.personsList{
            let newAction = UIAlertAction(title: person.fio, style: .default){
                [unowned self] _ in
                activePerson = person
                self.title = activePerson.fio
                tableView.reloadData()
            }
            ac.addAction(newAction)
        }
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    @IBAction func getDateFromDatePicker(segue: UIStoryboardSegue){
        let source = segue.source as! DatePickerController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            if sortStyleByPerson{
                dateChangePerson = activePerson
                dateChangeAction = DataContainer.shared.checksList[indexPath.row]
            } else {
                dateChangePerson = DataContainer.shared.personsList[indexPath.row]
                dateChangeAction = activeCheck
            }
            
            for item in DataContainer.shared.boundsList{
                if item.personID == dateChangePerson.id && item.actionID == dateChangeAction.id{
                    item.date = source.dateToSend!
                    DataContainer.shared.saveContext()
                    break
                }
            }
            tableView.reloadData()
        }
    }
    
    func goToLists(_ action: UIAlertAction){
        if let vc = storyboard?.instantiateViewController(identifier: "Lists") as? ListTableViewController{
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func reloadView(notification: NSNotification){
        //load data here
        self.title = "Выберите способ сортировки"
        navigationItem.rightBarButtonItem = nil
        self.tableView.reloadData()
    }
}

