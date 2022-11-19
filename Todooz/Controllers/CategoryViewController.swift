//
//  CategoryViewController.swift
//  Todooz
//
//  Created by Eldor Alikuvatov on 2022/11/18.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        categoryCell.textLabel?.text = category.name
        
        return categoryCell
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
       
        do {
           try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }

    func loadCategories(fetch request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todooz Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //What will happen once the user clicks the Add Category button on our UIAlert
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
    
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new category"
            textField = alertTextField
        }
            
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        context.delete(categoryArray[indexPath.row])
        categoryArray.remove(at: indexPath.row)
        
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        //itemArray[indexPath.row].done =  !itemArray[indexPath.row].done
        
        saveCategories()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
