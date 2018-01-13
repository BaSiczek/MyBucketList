//
//  ViewController.swift
//  MyBucketList
//
//  Created by Barbara Siczek on 13.01.2018.
//  Copyright © 2018 Barbara Siczek. All rights reserved.
//

import UIKit

class BucketListViewController: UITableViewController {

    var placesArray = ["Apo Island", "Salem Express", "Jericoacoara"]
    let defaults = UserDefaults.standard
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let places = defaults.array(forKey: "BucketListArray") as? [String]{
            placesArray = places
        }
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritePlacesCell", for: indexPath)
        cell.textLabel?.text = placesArray[indexPath.row]
        return cell
    }

    //MARK Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)

    }
    //MARK - Add new Action
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Place to Bucket List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Place", style: .default) {
            (action) in
            //what will hapen after user clicks the Add Place button on our UIAlert
            self.placesArray.append(textField.text!)
            
            self.defaults.set(self.placesArray, forKey: "BucketListArray")
            
            self.tableView.reloadData()

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Favourite Place"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}

