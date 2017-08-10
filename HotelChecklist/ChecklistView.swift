//
//  ChecklistView.swift
//  HotelChecklist
//
//  Created by Akash Bakshi on 2017-06-14.
//  Copyright © 2017 Akash Bakshi. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ChecklistView : ViewController,MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource{
    /*!
     @method     messageComposeViewController:didFinishWithResult:
     @abstract   Delegate callback which is called upon user's completion of message composition.
     @discussion This delegate callback will be called when the user completes the message composition.
     How the user chose to complete this task will be given as one of the parameters to the
     callback.  Upon this call, the client should remove the view associated with the controller,
     typically by dismissing modally.
     @param      controller   The MFMessageComposeViewController instance which is returning the result.
     @param      result       MessageComposeResult indicating how the user chose to complete the composition process.
     */
    
    @IBOutlet weak var segmentTask: UISegmentedControl!
    
    @IBOutlet weak var housekeeperPicker: UIPickerView!
    var bedRoomTasks = ["Entrace Door","Closet Door","Closet","Coffee Maker","Light Fixtures","Armoire","Television","Ventilation","Sofa Chairs","Window","Desk","Coffee Table(s)","Garbage Pail","Headboard","Pictures","Bed","Night Table","Carpet","Walls","Odour & Temperature"] // List of all the tasks IF YOU MODIFY THIS YOU ALSO HAVE TO MODIFY BEDROOM VALUE AND BEDROOM SELECTED arrays below
    
    var bathroomTasks = ["Mirror","Vanity & Sink","Amenities","Garbage Pail","Towels","Hairdryer","Walls","Toilet Paper","Toilet","Floor","Tub","Tile","Bright Work","Shower Curtain & Liner","Vent"]// List of all the tasks IF YOU MODIFY THIS YOU ALSO HAVE TO MODIFY BATHROOM VALUE AND BATHROOM SELECTED arrays below
    
    
    @IBOutlet weak var checklist: UITableView!
    
    var bedroomValue : [Int:Int] = [0:3,1:3,2:4,3:4,4:4,5:4,6:2,7:2,8:1,9:2,10:4,11:1,12:2,13:1,14:1,15:4,16:4,17:3,18:2,19:2] // used to tally up the points easier this is a dictionary so basically you set the index first then seperate it by a : and add it's value. ex. if you wanted the last task in the list to be worth 6 points when you add up the housekeepers points you would have to make it the 20 index sinceat the time of writing theres 19. it would look like 20:6
    var bedroomSelected : [Int:Int] = [0:0,1:0,2:0,3:0,4:0,5:0,6:0,7:0,8:0,9:0,10:0,11:0,12:0,13:0,14:0,15:0,16:0,17:0,18:0,19:0] // used totrack which tasks are selected value 0 means unchecked and 1 means checked
    
    var bathroomValue : [Int:Int] = [0:3,1:4,2:4,3:2,4:4,5:3,6:2,7:2,8:4,9:3,10:4,11:4,12:2,13:2,14:1] //same as above but for bathroom^
    
    var bathroomSelected : [Int:Int] = [0:0,1:0,2:0,3:0,4:0,5:0,6:0,7:0,8:0,9:0,10:0,11:0,12:0,13:0,14:0]
    
    var totalBedroomScore : Int = 0 // used to store final score for bedroom
    var totalBathroomScore: Int = 0 // used to store final score for bathroom
    var selHousekeepr: Int = 0
    
    var email:MFMailComposeViewController!
    
    

    @IBAction func ChangedTask(_ sender: UISegmentedControl) {
        checklist.reloadData() // reloads the data everytime you switch tabs
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //housekeeping work for ui elements
        checklist.dataSource = self
        housekeeperPicker.delegate = self
        housekeeperPicker.dataSource = self
    }
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return housekeeper.count
    }
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     
        return housekeeper[row]
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         selHousekeepr = row
    }
    
    override func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            
            return NSAttributedString(string: housekeeper[row], attributes: [NSForegroundColorAttributeName:UIColor.init(red: 0.0/255.0, green: 245.0/255.0, blue: 255.0/255.0, alpha: 1.0)])
      
    }
    
    
    
    @IBAction func onCancel(_ sender: UIButton) {
        selInspector = 0
        selRoom = 0
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let mainView = mainStory.instantiateViewController(withIdentifier: "start") as! ViewController
        self.present(mainView, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("kaboom3")
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        print("kaboom")
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func submitEmail(_ sender: UIButton) {
        
        if selHousekeepr != 0{
        email = MFMailComposeViewController()
            email.delegate = self as? UINavigationControllerDelegate
        email.mailComposeDelegate = self
        email.setSubject("Inspection score")
        email.setMessageBody("Hi, the score for Housekeeper \(housekeeper[selHousekeepr]) cleaning room number \(roomData[selRoom]) is \(totalBedroomScore) points for the bedroom and \(totalBathroomScore) points for the bathroom. Inspected by, \n \(inspectorData[selInspector])", isHTML: false)
        email.setToRecipients(["gabriel.vidican@ottawamarriott.com"]) // the recipient email address
            
        if MFMailComposeViewController.canSendMail() {
            present(email, animated: true, completion: nil)
            
            print("kaboom")
        }
        }
    }
    
    
    //tableview functions
    @IBAction func pressedCheckbox(_ sender: UIButton) {
        // function called when the checkbox button is clicked
        if(sender.currentImage == #imageLiteral(resourceName: "checked")){
            // if the current checkbox is checked as in selected change the image of the button to unchecked
            sender.setImage(UIImage(named:"unchecked.png"), for: .normal)
            if(segmentTask.selectedSegmentIndex == 0){
                // if the index of the tab is 0 which means its on bedroom subtract the task's from the total
                let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: checklist)
                let indexPath = checklist.indexPathForRow(at: buttonPosition)?.row
                
                bedroomSelected[indexPath!] = 0
            }
            if(segmentTask.selectedSegmentIndex == 1){
                // if the index of the tab is 1 which means its on bathroom we need to take what the task is worth and subtract it from the total
                let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: checklist)
                let indexPath = checklist.indexPathForRow(at: buttonPosition)?.row
                totalBathroomScore -= bathroomValue[(indexPath)!]!
                bathroomSelected[indexPath!] = 0
            }
        }
        else{
            // else  if the current state of the checkbox is unselected
            if(segmentTask.selectedSegmentIndex == 0){
                // index is 0 so bedroom task and we need to get the index of the task find out how much it's worth and add it to total value and then set the image as selected.
                let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: checklist)
                let indexPath = checklist.indexPathForRow(at: buttonPosition)?.row
                totalBedroomScore += bedroomValue[(indexPath)!]!
                 bedroomSelected[indexPath!] = 1
            }
            if(segmentTask.selectedSegmentIndex == 1){
                // index is 1 so it's a bathroom task so we need to find out how much it's worth and then add it to the bathroom total
                let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: checklist)
                let indexPath = checklist.indexPathForRow(at: buttonPosition)?.row
                totalBathroomScore += bathroomValue[(indexPath)!]!
                bathroomSelected[indexPath!] = 1
            }
            sender.setImage(UIImage(named: "checked.png"), for: .normal)
        }
        print("bedroom total \(totalBedroomScore)")
        
        print("bathroom total \(totalBathroomScore)")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var tmpInt : Int = 0
        // house keeping work for the picker view basically just gets the count of the arrays so it knows how many cell rows it needs to create
        if(segmentTask.selectedSegmentIndex == 0){
            tmpInt = bedRoomTasks.count
        }
        if(segmentTask.selectedSegmentIndex == 1){
            
            tmpInt = bathroomTasks.count
        }
        return tmpInt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checklistCell", for: indexPath)
        let btn = cell.viewWithTag(3) as? UIButton
        
        if segmentTask.selectedSegmentIndex == 0{
            if bedroomSelected[indexPath.row] == 0{
            
                btn?.setImage(UIImage(named: "unchecked.png"), for: .normal)
            }
            else{
                btn?.setImage(UIImage(named: "checked.png"), for: .normal)
            }
        }
        if segmentTask.selectedSegmentIndex == 1{
            if bathroomSelected[indexPath.row] == 0{
                
                btn?.setImage(UIImage(named: "unchecked.png"), for: .normal)
            }
            else{
                btn?.setImage(UIImage(named: "checked.png"), for: .normal)
            }
        }
            // get the cell and then load the appropriate data in each cell of the picker view
        if(segmentTask.selectedSegmentIndex == 0){
            cell.textLabel?.text = bedRoomTasks[indexPath.row]
            
        }
        if(segmentTask.selectedSegmentIndex == 1){
            cell.textLabel?.text = bathroomTasks[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
}
