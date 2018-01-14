//
//  ViewController.swift
//  MyBucketList
//
//  Created by Barbara Siczek on 13.01.2018.
//  Copyright © 2018 Barbara Siczek. All rights reserved.
//

import UIKit

class BucketListViewController: UITableViewController {

    var placesArray = [Place]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Places.plist")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(dataFilePath)
        
        loadPlaces()
        
        
    }

    // MARK:  Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritePlacesCell", for: indexPath)
        let place = placesArray[indexPath.row]
        
        cell.textLabel?.text = place.title
        
        cell.accessoryType =  place.visited ? .checkmark : .none
        
        return cell
    }

    // MARK: Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        placesArray[indexPath.row].visited = !placesArray[indexPath.row].visited
        tableView.reloadData()
        
        savePlaces()
                   
        tableView.deselectRow(at: indexPath, animated: true)

    }
    //MARK: - Add new Favourite Place
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Place to Bucket List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Place", style: .default) {(action) in
            
            let newPlace = Place()
            newPlace.title = textField.text!
            self.placesArray.append(newPlace)
            
            self.savePlaces()
            


        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Favourite Place"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    // MARK: Model manipulation methods
    
    func savePlaces(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(placesArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding Places Array, \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    func loadPlaces(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                placesArray = try decoder.decode([Place].self, from: data)
            } catch {
            print("Error decoding Places Array, \(error)")
            }
        }
        
    }
    

}

