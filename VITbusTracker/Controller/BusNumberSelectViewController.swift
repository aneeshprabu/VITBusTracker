//
//  BusNumberSelectViewController.swift
//  VITbusTracker
//
//  Created by Aneesh Prabu on 18/07/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import MapKit

class BusNumberSelectViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {
    
    //MARK: - Initialize variables
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var busNumberPickerView: UIPickerView!
    @IBOutlet weak var selectBtn: UIButton!
    
    private var data = [String:Any]()
    private var busNumbers = [String]()
    private var pickedBusNumber:String = "1"
    var dataDict = [String:CLLocationCoordinate2D]()
    
    var fullData: CollectionReference? = nil

    
    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        busNumberPickerView.delegate = self
        busNumberPickerView.dataSource = self
        
        busNumberPickerView.reloadAllComponents()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if data.isEmpty {
            textLabel.text = "Establishing connection..."
            selectBtn.isHidden = true
            SVProgressHUD.show()
            loadPickerData()
        }
        
        
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
        
        pickedBusNumber = busNumbers[row]
        
    }
    
    func loadPickerData() {
        
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: "Fetching ...")
        }
        
        
        
        fullData = db.collection("bus")
        
        db.collection("bus").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
               
            } else {
                for document in querySnapshot!.documents {
                    
                    self.busNumbers.append(document.documentID)
                    self.data[document.documentID] = document.data()
//                    print("\(document.documentID) => \(document.data())")
                }
            }
            
            self.busNumberPickerView.reloadAllComponents()
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                self.textLabel.text = "Select bus number"
                self.selectBtn.isHidden = false
            }
            
        }
        
    }
    
    //MARK: - Button Functions
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        
        navigationItem.title = pickedBusNumber
        print(pickedBusNumber as Any)
        
        }
    
    //MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMapView" {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.selectedNumber = pickedBusNumber
            destinationVC.data = self.data
            //print(self.dataDict)
        }
    }
}
    
    

