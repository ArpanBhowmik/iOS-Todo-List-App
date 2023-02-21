//
//  CategoryViewController.swift
//  Todo List App
//
//  Created by m-arpan-b on 13/2/23.
//

import CoreData
import UIKit

class CategoryViewController: UITableViewController {
    private var categories = [Category]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")

        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        navigationItem.backButtonTitle = "Back"
        navigationItem.searchController = nil
    }
    
    private func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error in saving \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    private func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
           categories = try context.fetch(request)
        } catch {
            print("error in fetching \(error.localizedDescription)")
        }
    }
}

// MARK: - Table view data source and Delegate

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TodoListViewController()
        vc.category = categories[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Actions

extension CategoryViewController {
    @objc private func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        var alertTextField = UITextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            if let name = alertTextField.text {
                let category = Category(context: self.context)
                category.name = name
                self.categories.append(category)
                self.saveCategories()
            }
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Add a new category"
            alertTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}
