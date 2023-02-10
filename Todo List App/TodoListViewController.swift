//
//  TodoListViewController.swift
//  Todo List App
//
//  Created by Arpan Bhowmik on 16/1/23.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoItemCell")
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Todoey"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemCyan
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }
}

// MARK: - UITableView Delegate and DataSource

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Actions

extension TodoListViewController {
    @objc private func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        var alertTextField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { _ in
            if let item = alertTextField.text {
                self.itemArray.append(item)
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
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
