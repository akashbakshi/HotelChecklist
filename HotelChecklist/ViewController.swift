//
//  ViewController.swift
//  HotelChecklist
//
//  Created by Akash Bakshi on 2017-06-11.
//  Copyright © 2017 Akash Bakshi. All rights reserved.
//

import UIKit
import MessageUI

var housekeeper = ["Please Select a House keeper"] // Array that will store the names of all the housekeeper
var inspectorData = ["Inspector name"]; // Array that will store the names of all the inspector
var roomData = ["Room number"]; //Array that will store the room numbers

var initLaunch:Bool = true //boolean to determine if it is the first time user laumches to load data

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var inspectorPicker: UIPickerView!
       @IBOutlet weak var roomPicker: UIPickerView!
    
    var selRoom: Int = 0 // variable used to track index of which room is selected in the main page so we can do validation.
    var selInspector : Int = 0 // variable used to track index of which inspector is selected in the main page so we can do validation.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(initLaunch){
            // if this is the first time the app loaded after being closed
            loadData() // load data to store the room number, inspector names and housekeeper names
            initLaunch = false
        }
        
        if(inspectorPicker != nil){
            // code to set up the picker view to select inspector
        inspectorPicker.dataSource = self
        inspectorPicker.delegate = self
        inspectorPicker.tintColor = UIColor.blue
        }
        
        
        if(roomPicker != nil){
            //code to set up the picker view to select inspector
        roomPicker.dataSource = self
        roomPicker.delegate = self
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    func keyExists(keyVal: String)->Bool{
        return UserDefaults.standard.object(forKey: keyVal) != nil
    }
    
    func loadData(){
        let defaults = UserDefaults.standard // Access the user directory
        
        //if there are names in the inspector
        if keyExists(keyVal: "inspectorCount") == true{
            let inspectorCount = Int(defaults.string(forKey: "inspectorCount")!) // get the number of names from the user's dir
            //print("insp count \(inspectorCount!)")
            
            for i in 1...inspectorCount!{
                // for loop to run through all the names index starts at 1 because the 0 element is the "please select etc..." greeting
                
                print("inspector"+String(i))
                if let data = defaults.object(forKey: "inspector"+String(i)) as? String{ // if there's any data
                    inspectorData.append(data) // pull the data and add it to the array
                }
            }
        }
        
        // view top code example same thing but for room number
        if keyExists(keyVal: "roomCount") == true{
            let roomCount = Int(defaults.string(forKey: "roomCount")!)
            for i in 1...roomCount!{
                if let data = defaults.object(forKey: "room"+String(i)) as? String{
                    roomData.append(data)
                }
            }
        }
        
        //view top code example same thing but for housekeeper
        if keyExists(keyVal: "housekeeperCount") == true{
            let housekeeperCount = Int(defaults.string(forKey: "housekeeperCount")!)
            for i in 1...housekeeperCount!{
                if let data = defaults.object(forKey: "housekeeper"+String(i)) as? String{
                    housekeeper.append(data)
                }
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       var count: Int = -1;
        if(inspectorPicker != nil && roomPicker != nil){
            if(pickerView == inspectorPicker){
                count = inspectorData.count;
            }
            if(pickerView == roomPicker)
            {
                count = roomData.count
            }
        }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var data :String = ""
        if(pickerView == inspectorPicker){
            data = inspectorData[row]
        }
        if(pickerView == roomPicker){
            data = roomData[row]
        }
        return data
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == inspectorPicker{
            selInspector = row
        }
        if pickerView == roomPicker{
            selRoom = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var data = ""
        if(pickerView == inspectorPicker){
            data = inspectorData[row]
        }
        if(pickerView == roomPicker){
            data = roomData[row]
        }
        return NSAttributedString(string: data, attributes: [NSForegroundColorAttributeName:UIColor.init(red: 0.0/255.0, green: 245.0/255.0, blue: 255.0/255.0, alpha: 1.0)])
    }
    
    @IBAction func btnSettings(_ sender: Any) {
        // if the user hits the settings button go to the settings view controller
        let story = UIStoryboard(name: "Main", bundle: nil)
        let checklist = story.instantiateViewController(withIdentifier: "settings") as! SettingsView
        
        self.present(checklist, animated: true, completion: nil)

    }
    @IBAction func btnStart(_ sender: UIButton) {
       // if the user hits the start button go to the checklist
        let story = UIStoryboard(name: "Main", bundle: nil)
        let checklist = story.instantiateViewController(withIdentifier: "checklist") as! ChecklistView
        
        self.present(checklist, animated: true, completion: nil)
    }
    
   
}

