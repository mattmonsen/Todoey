//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Matt Monsen on 10/22/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let persistenceController = PersistenceController.shared
    
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()

        readData()
    }


    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        saveData()
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.persistenceController.container.viewContext)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.saveData()

            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveData() {
        do {
            try persistenceController.container.viewContext.save()
        } catch {
            print("Error saving category, \(error)")
        }
    }
    
    func readData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try persistenceController.container.viewContext.fetch(request)
        } catch {
            print("error fetching categories: \(error)")
        }
        tableView.reloadData()
    }
}
