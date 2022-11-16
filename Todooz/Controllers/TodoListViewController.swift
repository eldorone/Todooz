//
//  ViewController.swift
//  Todooz
//
//  Created by Eldor Alikuvatov on 2022/11/11.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController, UINavigationBarDelegate {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath!)
        
        //loadItems()
        
        // navigationController?.navigationBar.backgroundColor = UIColor(named: "BrandGrayColor")
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        cell.tintColor = UIColor(named: "BrandGreenColor")
        
        return cell
    }
    
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done =  !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todooz Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the uset clicks the Add Item button on our UIAlert
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false 
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Creat new item"
                textField = alertTextField
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    //MARK: - Model Manupulation Methods
    
    func saveItems() {
       
        do {
           try context.save()
        } catch {
            print("Error encoding item array \(error)")
        }
        
        self.tableView.reloadData()
    }
    
//    func loadItems() {
//       // if let data = try? Data(contentsOf: dataFilePath!) {
//            //let decoder = PropertyListDecoder()
//
//            do {
//               try context.save()
//            } catch {
//                print("Error decoding item array \(error)")
//            }
//
//        //}
//    }
}

