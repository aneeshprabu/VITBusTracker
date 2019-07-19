//
//  MapViewController.swift
//  VITbusTracker
//
//  Created by Aneesh Prabu on 18/07/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreGPX
import TrackKit
import SwiftyJSON
import SVProgressHUD


class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Initialize variables here
    var annotationsDictionary = [String:Any]()
    var dataDict = [String:CLLocationCoordinate2D]()
    var data = [String:Any]()
    var selectedNumber: String = ""
    var isFinishedLoading: Bool = false {
        didSet {
            if isFinishedLoading == true {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(data)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    
    //MARK: - Add Anotations to the map
    /**
     Function to add markers to the map using the dictionary property of this class
     - Returns:
     
     - Important:
     This code has not gone through QA
     - Version:
     0.1
     */
    
    func addAnnotations(dict: Dictionary<String, CLLocationCoordinate2D>) -> Dictionary<String, Any>{
        
        for(key,value) in dataDict {
            annotationsDictionary["title"] = key
            annotationsDictionary["latitude"] = value.latitude
            annotationsDictionary["longitude"] = value.longitude
        }
        return annotationsDictionary

    }
    
    
    //MARK: - Trackkit Functions
    /**
     Function to parse through GPX file
     - parameters:
        -   path: Path of the URL (String). Can not be empty.
     - Returns:
        Contains the Data after parsing the GPX file (File)
     */
    
    func gpxParse(path: String) -> TrackParser {
        
        let content: String = path
        let data = content.data(using: .utf8)
    
        let file = try! TrackParser(data: data, type: .gpx)
        return file
    }
    

    
    
    //MARK: - Initial zoom point function
    /**
     Function to Zoom in the map to a specific location
     - parameters:
        - latitude: The Latitude of the location (CLLocationDegrees). Can not be empty.
        - longitude: The Longitude of the location (CLLocationDegrees). Can not be empty
     - Important:
     This code has not gone through QA
     - Version:
     0.1
     */
    
    func zoomToRegion(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000.0, longitudinalMeters: 7000.0)
        
        mapView.setRegion(region, animated: true)
        
    }

}
