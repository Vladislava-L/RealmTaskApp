//
//  TasksListTableViewController.swift
//  RealmTaskApp
//
//  Created by l.vladislava on 23/02/2021.
//

import UIKit
import RealmSwift

class TasksListTableViewController: UITableViewController {

    var tasksLists: Results<TasksList>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tasksLists = realm.objects(TasksList.self)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func editItemTapped(_ sender: Any) {
    }
    
    @IBAction func addNewItemTapped(_ sender: Any) {
        alertForAddUpdateList()
    }
    
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasksLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksListCell", for: indexPath)

        let taskList = tasksLists[indexPath.row]
        //cell.textLabel?.text = taskList.name

        cell.configure(with: taskList)
        cell.selectionStyle = .none
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITableViewCell{
    
    func configure(with tasksList: TasksList){
        let currentTasks = tasksList.tasks.filter("isComplete = false")
        let completedTasks = tasksList.tasks.filter("isComplete = true")
        
        textLabel?.text = tasksList.name
        
        if !currentTasks.isEmpty {
            detailTextLabel?.text = "\(currentTasks.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 20)
            detailTextLabel?.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }else if !completedTasks.isEmpty {
            detailTextLabel?.text = "✔︎"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 30)
            detailTextLabel?.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }else{
            detailTextLabel?.text = "0"
        }
    }
    
}

extension TasksListTableViewController{
    
    private func alertForAddUpdateList(_ listName: TasksList? = nil, completion: (() -> Void)? = nil) {
    
        var title = "New List"
        var doneButton = "Save"
        
        if listName != nil {
            
            title = "Edit List"
            doneButton = "Update"
        }
    
        let alert = UIAlertController(title: title, message: "Please insert new value.", preferredStyle: .alert)
    
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { (_) in
            
            guard let newList = alertTextField.text, !newList.isEmpty else {return}
            
            if let listName = listName{
                StorageManager.editList(listName, newListName: newList)
                if completion != nil {completion!()}
            }else{
                let taskList = TasksList()
                taskList.name = newList
                
                StorageManager.saveTasksList(taskList)
                self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count, section: 0)], with: .automatic)
            }//else
        }//saveAction
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { (textField)in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
        }
        
        if let listName = listName {
            alertTextField.text = listName.name
        }
        
        present(alert, animated: true)
    }
}
