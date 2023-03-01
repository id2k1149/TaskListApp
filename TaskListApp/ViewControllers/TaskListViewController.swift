//
//  TaskListViewController.swift
//  TaskListApp
//
//  Created by Max Franz Immelmann on 2/27/23.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    private var viewContext = StorageManager
        .shared
        .persistentContainer
        .viewContext
    
    private let cellID = "task"
    private var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .white
        setupNavigationBar()
        fetchData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            navigationItem.leftBarButtonItem?.title = "Done"
        } else {
            navigationItem.leftBarButtonItem?.title = "Delete"
        }
    }
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.title = "Delete"
    }
    
    @objc private func addNewTask() {
        showAlert(withTitle: "New Task",
                  andMessage: "What do you want to do?",
                  forRowAt: 0)
    }
    
    private func fetchData() {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try viewContext.fetch(fetchRequest)
            setupNavigationBar()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func showAlert(withTitle title: String,
                           andMessage message: String,
                           forRowAt row: Int) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        if message != "" {
            alert.addTextField { textField in
                textField.placeholder = "New Task"
            }
            
            let saveAction = UIAlertAction(title: "Save",
                                           style: .default) { [unowned self] _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
                save(task)
            }
            alert.addAction(saveAction)
        } else {
            let taskToEdit = taskList[row]
            alert.addTextField { textField in
                textField.text = taskToEdit.title
            }
            
            let updateAction = UIAlertAction(title: "Update",
                                           style: .default) { [unowned self] _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
                update(task, forRowAt: row)
            }
            alert.addAction(updateAction)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(_ taskName: String) {
        let task = Task(context: viewContext)
        task.title = taskName
        taskList.append(task)
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func update(_ taskName: String, forRowAt row: Int) {
        let taskToEdit = taskList[row]
        // Update the task name with new input
        taskToEdit.title = taskName
        
        // Update the row in the table view
        let cellIndex = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [cellIndex], with: .automatic)
        
        // Save the changes to Core Data
        StorageManager.shared.saveContext()
    }
}

extension TaskListViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    // Delete the task (commit)
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        // Check if the editing style is delete
        if editingStyle == .delete {
            
            // Delete the task from CoreData
            let taskToDelete = taskList[indexPath.row]
            StorageManager.shared.deleteTask(taskToDelete)
            
            // Remove the task from the array
            taskList.remove(at: indexPath.row)
            
            // Delete the task from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    // Override the tableView(_:didSelectRowAt:) method to handle editing
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect the row that was tapped
        tableView.deselectRow(at: indexPath, animated: true)
        
        showAlert(withTitle: "Update Task",
                  andMessage: "",
                  forRowAt: indexPath.row)
        
    }
}
