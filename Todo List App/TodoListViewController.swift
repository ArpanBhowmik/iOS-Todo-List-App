//
//  TodoListViewController.swift
//  Todo List App
//
//  Created by Arpan Bhowmik on 16/1/23.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        var alertTextField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { _ in
            if let item = alertTextField.text {
                self.itemArray.append(item)
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Create New Item"
            alertTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}

