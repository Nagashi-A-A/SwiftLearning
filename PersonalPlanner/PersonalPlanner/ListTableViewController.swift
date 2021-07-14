//
//  ListTableViewController.swift
//  PersonalPlanner
//
//  Created by Anton Yaroshchuk on 10.07.2021.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {
    
    var switchStyleByPerson = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if switchStyleByPerson{
            return DataContainer.shared.personsList.count
        } else {
            return DataContainer.shared.checksList.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func switchListType(_ sender: UISegmentedControl) {
        switchStyleByPerson = !switchStyleByPerson
        tableView.reloadData()
    }
    
    @IBAction func addEntityObject(_ sender: UIBarButtonItem) {
        if switchStyleByPerson{
            createNewPerson()
        } else {
            createNewAction()
        }
    }
    
    func createNewPerson(){
        let ac = UIAlertController(title: "Добавить сотрудника", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        ac.textFields?[0].placeholder = "Ведите имя..."
        ac.textFields?[1].placeholder = "Введите email..."
        let addPersonAction = UIAlertAction(title: "Подтвердить", style: .default){
            [weak self, weak ac] _ in
            guard let nameText = ac?.textFields?[0].text else { return }
            guard let emailText = ac?.textFields?[1].text else { return }
            DataContainer.shared.addPerson(name: nameText, email: emailText)
            self?.tableView.reloadData()
        }
        ac.addAction(addPersonAction)
        
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(ac, animated: true)
    }
    
    
    func createNewAction(){
        let ac = UIAlertController(title: "Создать новое событие", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        ac.textFields?[0].placeholder = "Ведите название..."
        ac.textFields?[1].placeholder = "Введите период..."
        let addPersonAction = UIAlertAction(title: "Подтвердить", style: .default){
            [weak self, weak ac] _ in
            guard let nameText = ac?.textFields?[0].text else { return }
            guard let period = ac?.textFields?[1].text else { return }
            guard let periodNumber = Int(period) else { return }
            DataContainer.shared.addAction(name: nameText, period: Int64(periodNumber))
            self?.tableView.reloadData()
        }
        ac.addAction(addPersonAction)
        
        ac.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(ac, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell")
            cell?.layer.cornerRadius = 15
        
            if switchStyleByPerson{
                cell?.textLabel?.text = "Имя: \(DataContainer.shared.personsList[indexPath.row].fio)"
                cell?.detailTextLabel?.text = "Email: \(DataContainer.shared.personsList[indexPath.row].email)"
            } else {
                cell?.textLabel?.text = "Название: \(DataContainer.shared.checksList[indexPath.row].name)"
                cell?.detailTextLabel?.text = "Период: \(DataContainer.shared.checksList[indexPath.row].period)"
            }
            return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if switchStyleByPerson{
                let item = DataContainer.shared.personsList[indexPath.row]
                DataContainer.shared.viewContext.delete(item)
                DataContainer.shared.personsList.remove(at: indexPath.row)
            } else {
                let item = DataContainer.shared.checksList[indexPath.row]
                DataContainer.shared.viewContext.delete(item)
                DataContainer.shared.personsList.remove(at: indexPath.row)
            }
            DataContainer.shared.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editEntity(indexPath: indexPath.row)
    }
    
    func editEntity(indexPath: Int){
        let ac = UIAlertController(title: "Внести изменения", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        if switchStyleByPerson{
            ac.textFields![0].text = DataContainer.shared.personsList[indexPath].fio
            ac.textFields![1].text = DataContainer.shared.personsList[indexPath].email
        } else {
            ac.textFields![0].text = DataContainer.shared.checksList[indexPath].name
            ac.textFields![1].text = "\(DataContainer.shared.checksList[indexPath].period)"
        }
        
        let confirm = UIAlertAction(title: "Подтвердить", style: .default){
            [unowned self] _ in
            if switchStyleByPerson{
                guard let newName = ac.textFields![0].text else { return }
                guard let newEmail = ac.textFields![1].text else { return }
                DataContainer.shared.personsList[indexPath].fio = newName
                DataContainer.shared.personsList[indexPath].email = newEmail
                DataContainer.shared.saveContext()
            } else {
                guard let newName = ac.textFields![0].text else { return }
                let newPeriod = Int(ac.textFields![1].text ?? "0")
                DataContainer.shared.checksList[indexPath].name = newName
                DataContainer.shared.checksList[indexPath].period = Int64(newPeriod!)
                DataContainer.shared.saveContext()
            }
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        ac.addAction(cancel)
        ac.addAction(confirm)
        present(ac, animated: true)
    }
    
    deinit {
        print("list Controller was deleted.")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
}
