//
//  AtmDetailViewController.swift
//  hackAnATM
//
//  Created by xavier on 1/5/17.
//  Copyright © 2017 John. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMaps

class AtmDetailViewController: UIViewController, UIViewControllerTransitioningDelegate, GMSMapViewDelegate {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var panoView: UIView!
    
    @IBOutlet weak var nameBankView: UIView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var bank: UILabel!
    
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var phone: UITextView!
    
    @IBOutlet weak var servicesTextView: UITextView!
    @IBOutlet weak var lobbyHrsTableView: UITextView!
    
    var atmInfo: AtmInformation!
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleButtons()
        
        self.fillText()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - VIEW SET UP
    func styleButtons(){
        
        //back button styling
        self.backBtn.backgroundColor = UIColor.white
        self.backBtn.layer.cornerRadius = 5
        self.backBtn.layer.borderWidth = 1
        self.backBtn.layer.borderColor = UIColor.black.cgColor
        
        //share button styling
        self.shareBtn.backgroundColor = UIColor.white
        self.shareBtn.layer.cornerRadius = 5
        self.shareBtn.layer.borderWidth = 1
        self.shareBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    func fillText(){
        
        if let info = self.atmInfo{
            
            self.Name.text = info.name
            self.bank.text =  "Bank: " + info.bank
            
            self.address.text = info.address + "\n\(info.city), \(info.state) \(info.zip)"
            
            self.phone.text = "Phone: " + cleanPhoneNumberString(phoneString: info.phone)
            
            self.servicesTextView.text = serviceText(info.services)
            self.lobbyHrsTableView.text = hoursText(info.lobbyHrs)
        }
    }
    
    //MARK: - CLEAN TEXT
    /*
     Combines each non-empty item in the JSON Array with a Weekday Title
     If no non-empty items then function returns "No Hours Listed"
     */
    func serviceText(_ jsonArray: [JSON])-> String{
        
        var string = ""
        
        for lines in jsonArray{
            if let line = lines.string{
                if(!line.isEmpty){
                    string +=  "\n" + line
                }
            }
        }
        
        if(string.isEmpty){
            return "Services: \n No Services Listed"
        }else{
            return "Services: \(string)"
        }
    }
    
    /*
     Combines each non-empty item in the JSON Array with a Weekday Title
     If no non-empty items then function returns "No Hours Listed"
    */
    func hoursText(_ jsonArray: [JSON])-> String{
        
        var weekdayNames = ["Mon: ","Tues: ","Wed: ","Thurs: ","Fri: ","Sat&Sun: "]
        var string = ""
        var index = 0
        
        for lines in jsonArray{
            if let line = lines.string{
                if(!line.isEmpty && index < weekdayNames.count){
                    
                    string +=  "\n" + weekdayNames[index] + line
                    
                    index += 1
                }
            }
        }
        
        if(string.isEmpty){
            return "Hours: \n No Hours Listed"
        }else{
            return "Hours: \(string)"
        }
    }
    
    //Hack way of formmatting the phone String
    func cleanPhoneNumberString(phoneString: String)-> String{
        
        if(phoneString.isEmpty){
            return "No Number Listed"
        }
        
        var temp = phoneString
        if(phoneString.characters.count > 9){
            
            //Assumming if "(" exisits in phoneString, then we have "()" around area code
            if(!phoneString.contains(")")){ //Bad assumtion
                
                //Wow Swift 3, good job making inserting characters so easy
                temp.insert("(", at: temp.index(temp.startIndex, offsetBy: +0))
                temp.insert(")", at: temp.index(temp.startIndex, offsetBy: +4))
            }
            
            //Assume that if phoneString has "-" seperators, then we are formatted
            if(!phoneString.contains("-")){ //Bad assumtion
                temp.insert("-", at: temp.index(temp.startIndex, offsetBy: +5))
                temp.insert("-", at: temp.index(temp.startIndex, offsetBy: +9))
            }
        }
        
        return temp
    
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func didPressBack(_ sender: UIButton) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    //from www.codingexplorer.com
    @IBAction func shareBtnClicked(_ sender: UIButton) {
        
        if let info = self.atmInfo{
            let textToShare = "Check out the \(info.name) \(info.bank) bank."
            let addressToShare = "It's at " + info.address + "\(info.city), \(info.state) \(info.zip)"
            
            let objectsToShare = [textToShare, addressToShare] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)

        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "panoSegue"){
            
            let panoView = segue.destination as! PanoViewController
            panoView.location = CLLocationCoordinate2D(latitude: atmInfo.lat, longitude: atmInfo.lng)
        }
    }
    
}


//Pano Google Street View Image
class PanoViewController: UIViewController{
    
    var location: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let mylocation = self.location{

            let panoramaNear = CLLocationCoordinate2D(latitude: mylocation.latitude, longitude: mylocation.longitude)
            let panoView = GMSPanoramaView.panorama(withFrame: .zero, nearCoordinate: panoramaNear)
            
            self.view = panoView
        }
        
    }
    
}
