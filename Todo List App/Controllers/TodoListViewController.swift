//
//  TodoListViewController.swift
//  Todo List App
//
//  Created by Arpan Bhowmik on 16/1/23.
//

import CoreData
import UIKit

class TodoListViewController: UITableViewController {
    var itemArray: [Item] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoItemCell")
        
        setupNavigationBar()
        loadItems()
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
    
    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("error in saving \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    private func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("error in fetching \(error.localizedDescription)")
        }
    }
}

// MARK: - UITableView Delegate and DataSource

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].isChecked ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isChecked.toggle()
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Actions

extension TodoListViewController {
    @objc private func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        var alertTextField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { _ in
            if let title = alertTextField.text {
                let newItem = Item(context: self.context)
                newItem.title = title
                newItem.isChecked = false
                self.saveItems()
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
