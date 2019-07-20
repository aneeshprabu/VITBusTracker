//
//  BusNumberSelectViewController.swift
//  VITbusTracker
//
//  Created by Aneesh Prabu on 18/07/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SVProgressHUD
import MapKit

class BusNumberSelectViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {
    
    //MARK: - Initialize variables
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var busNumberPickerView: UIPickerView!
    @IBOutlet weak var selectBtn: UIButton!
    
    private var data = [String:[String:CLLocationCoordinate2D]]()
    private var busNumbers = ["Select bus number"]
    private var pickedBusNumber:String = "0"
    private var test = [String:[String:Any]]()
    

    
    //MARK: - View did load
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        selectBtn.isEnabled = false
        busNumberPickerView.delegate = self
        busNumberPickerView.dataSource = self
        busNumberPickerView.selectedRow(inComponent: 0)
        busNumberPickerView.reloadAllComponents()
        
    }
 
    
    override func viewWillAppear(_ animated: Bool) {


            textLabel.text = "Establishing connection..."
            selectBtn.isHidden = true
            loadPickerData()
    }
    
    //MARK: - Picker delegate functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return busNumbers.count
        }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return busNumbers[row]
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
       
        if row != 0 {
            selectBtn.isEnabled = true
            pickedBusNumber = busNumbers[row]
            selectBtn.isHidden = false
        }
        else {
            selectBtn.isEnabled = false
            selectBtn.isHidden = true
        }
        
    }
    
    //MARK: - Loading the Picker Data
    
    func loadPickerData() {
        
        busNumberPickerView.selectedRow(inComponent: 0)
        busNumberPickerView.reloadAllComponents()
        
        db.collection("bus").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
               
            } else {
                for document in querySnapshot!.documents {
                    
                    self.busNumbers.append(document.documentID)
                    
                    let points = document.data()
                    self.test[document.documentID] = points
                }
                
                for _data in self.test {
                    //print("\(_data.key) => \(_data.value)")
                    var temp = [String:CLLocationCoordinate2D]()
                    for _val in _data.value {
                        let coords = _val.value as! GeoPoint
                        let fullCoord = CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude)
                        temp[_val.key] = fullCoord
                    }
                    self.data[_data.key] = temp
                }
            }
            
            self.busNumberPickerView.reloadAllComponents()
            
            DispatchQueue.main.async {
                
                self.textLabel.text = "Select bus number"
                
            }
            
        }
        
    }
    
    //MARK: - Button Functions
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {

    }
    
    //MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMapView" {
            let destinationVC = segue.destination as! MapViewController
            busNumbers = ["Select bus number"]
            destinationVC.selectedNumber = pickedBusNumber
            
            for _data in data{
                if _data.key == pickedBusNumber {
                    destinationVC.dataDict = _data.value
                }
            }
            
        }
    }
}
    
    

