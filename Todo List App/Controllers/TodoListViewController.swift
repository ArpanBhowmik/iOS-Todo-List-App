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
    
    var category: Category? {
        didSet { loadItems() }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoItemCell")
        
        setupNavigationBar()
        configureSearchController()
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
    
    private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [addtionalPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("error in fetching \(error.localizedDescription)")
        }
    }
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
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
//
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

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
                newItem.parentCategory = self.category
                self.itemArray.append(newItem)
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

// MARK: - UISearchResultsUpdating

extension TodoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: text.isEmpty ? nil : NSPredicate(format: "title CONTAINS[cd] %@", text))
    }
}
