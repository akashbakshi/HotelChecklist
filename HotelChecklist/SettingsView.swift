//
//  SettingsView.swift
//  HotelChecklist
//
//  Created by Akash Bakshi on 2017-06-23.
//  Copyright © 2017 Akash Bakshi. All rights reserved.
//

import Foundation
import UIKit

class SettingsView : ViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var enterInfoView: UIView!
    @IBOutlet weak var config: UITableView!
    @IBOutlet weak var nameRoomText: UITextField!
    
    @IBOutlet weak var optionSegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        config.dataSource = self
        nameRoomText.attributedPlaceholder = NSAttributedString(string: nameRoomText.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
    
    @IBAction func onOptionChange(_ sender: UISegmentedControl) {
        
        config.reloadData()
    }
    
    @IBAction func onAddOption(_ sender: UIButton) {
        if(enterInfoView.isHidden == true){
            enterInfoView.isHidden = false
        }else{
            enterInfoView.isHidden = true
        }
        // hide and unhide the window when user hit's the plus symbol to add something
    }
    
    @IBAction func onSubmitName(_ sender: UIButton) {
        let defaults = UserDefaults.standard // access the user's default
        
        if(optionSegment.selectedSegmentIndex == 0){
            // if the user hit's submit and the tab is on 0
            inspectorData.append(nameRoomText.text!) // add the textfield's text to the array
            defaults.set((inspectorData.count-1), forKey: "inspectorCount") // update the count for the number of elements in the array
            defaults.synchronize()
            
            defaults.set(nameRoomText.text!, forKey: "inspector"+String(inspectorData.count-1)) // store the new value in the ipads storage with the special key being inspector2, 2 being the index of the value
            defaults.synchronize()
            config.reloadData() // reload the data so it shows the new added value
            
            nameRoomText.text?.removeAll()
            enterInfoView.isHidden = true
        }
        if(optionSegment.selectedSegmentIndex == 1){
            
            // same as above but for room data
            roomData.append(nameRoomText.text!)
            defaults.set((roomData.count-1), forKey: "roomCount")
            defaults.synchronize()
            defaults.set(nameRoomText.text!, forKey: "room"+String(roomData.count-1))
            defaults.synchronize()
            config.reloadData()
            nameRoomText.text?.removeAll()
            enterInfoView.isHidden = true
            
        }
        
        if(optionSegment.selectedSegmentIndex == 2){
            // same as above but for housekeeper
            housekeeper.append(nameRoomText.text!)
            defaults.set((housekeeper.count-1), forKey: "housekeeperCount")
            defaults.synchronize()
            
            defaults.set(nameRoomText.text!, forKey: "housekeeper"+String(housekeeper.count-1))
            defaults.synchronize()
            
            config.reloadData()
            nameRoomText.text?.removeAll()
            enterInfoView.isHidden = true
        }
    }
    @IBAction func onBackClick(_ sender: UIButton) {
        // if the user hits the back button go to the main page.
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let mainView = mainStory.instantiateViewController(withIdentifier: "start") as! ViewController
        self.present(mainView, animated: true, completion: nil)
    }
    
    @IBAction func onDelete(_ sender: UIButton) {
        // on delete function deletes values
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: config)
        let indexPath = config.indexPathForRow(at: buttonPosition)?.row
        
        
        let defaults = UserDefaults.standard
        if optionSegment.selectedSegmentIndex == 0{
            inspectorData.remove(at: (indexPath!+1))
            defaults.set((inspectorData.count-1), forKey: "inspectorCount") // update the count for the number of elements in the array
            defaults.synchronize()
            for i in 0...(inspectorData.count-1){
                defaults.set(inspectorData[i], forKey: "inspector"+String(i)) // store the new value in the ipads storage with the special key being inspector2, 2 being the index of the value
                defaults.synchronize()
            }
            
        }
        if optionSegment.selectedSegmentIndex == 1{
            
            roomData.remove(at: (indexPath!+1))
            defaults.set((roomData.count-1), forKey: "roomCount")
            defaults.synchronize()
            
            for i in 0...(roomData.count-1){
                defaults.set(roomData[i], forKey: "room"+String(i))
                defaults.synchronize()
            }
        }
        
        if optionSegment.selectedSegmentIndex == 2{
            housekeeper.remove(at: (indexPath!+1))
            defaults.set((housekeeper.count-1), forKey: "housekeeperCount")
            defaults.synchronize()
            
            for i in 0...(housekeeper.count-1){
                defaults.set(housekeeper[i], forKey: "housekeeper"+String(i))
                defaults.synchronize()
            }
        }
        config.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numCount: Int = 0
        if(optionSegment.selectedSegmentIndex == 0){
            numCount = inspectorData.count-1
        }
        if(optionSegment.selectedSegmentIndex == 1){
            numCount = roomData.count-1
        }
        if(optionSegment.selectedSegmentIndex == 2){
            numCount = housekeeper.count-1
        }
        return numCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if(optionSegment.selectedSegmentIndex == 0){
            cell.textLabel?.text = inspectorData[indexPath.row+1]
        }
        if(optionSegment.selectedSegmentIndex == 1){
            cell.textLabel?.text = roomData[indexPath.row+1]
        }
        if(optionSegment.selectedSegmentIndex == 2){
            cell.textLabel?.text = housekeeper[indexPath.row+1]
        }
        
        return cell
    }
}
