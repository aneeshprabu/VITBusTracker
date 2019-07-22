//
//  MapViewController.swift
//  VITbusTracker
//
//  Created by Aneesh Prabu on 18/07/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate {
    
    //MARK: - Initialize variables here
    
    @IBOutlet var mapSwitch: UISwitch!
    @IBOutlet var satelliteLabel: UILabel!
    
    var zoomingIn = false
    var zoomingAnnotation:MKAnnotation?
    
    var dataDict = [String:CLLocationCoordinate2D]()
    //var data = [String:[String:CLLocationCoordinate2D]]()
    var allAnnotations = [MKAnnotation]()
    var selectedNumber: String = ""
    var locations = [CLLocationCoordinate2D]()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        addAnnotations(dataDict: dataDict, selectedNum: selectedNumber)
        

    }
    
    deinit {
        print("Annotations before deinit\(mapView.annotations.count)")
        mapView.removeAnnotations(mapView.annotations)
    }
    
    
    
    //MARK: - Switch on Map Function
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        if sender.isOn {
            mapView.mapType = .satellite
            satelliteLabel.text = "Satellite"
            satelliteLabel.textColor = .green
        } else {
            mapView.mapType = .standard
            satelliteLabel.text = "Default"
            satelliteLabel.textColor = .systemBlue
        }
    }
    
    
    
    
    //MARK: - Add Anotations to the map
    /**
     Function to add markers to the map using the dictionary member of this class
     - Parameters:
     - [String: CLLocationCoordinate2D]
     - selected Bus number
     
     - Important:
     This code has not gone through QA
     - Version:
     0.1
     */
    
    func addAnnotations(dataDict: [String:CLLocationCoordinate2D] , selectedNum: String) {

        for _key in dataDict {
            let annotations = MKPointAnnotation()
            
            if let location:CLLocationCoordinate2D = dataDict[_key.key] {
                annotations.title = _key.key
                annotations.coordinate = location
                mapView.addAnnotation(annotations)
                allAnnotations.append(annotations)
                locations.append(location)
            }
            
            
        }
        
        drawRoute()
        
    }
    
    //MARK: - Route Function
    /**
     Function to draw the route from an array of location points
     - parameters:
     
     - Returns:
     
     */
    
    func drawRoute() {
        zoomToRegion()
        
        let sortedKeys = Array(dataDict.keys).sorted()
        print(sortedKeys)
        

        var arrData = Array<(key: String, value: CLLocationCoordinate2D)>()
        for _key in sortedKeys {
            arrData.append((_key, dataDict[_key]!))
        }
        
        for index in 0..<arrData.count - 1 {
            let sourcePlaceMark = MKPlacemark(coordinate: arrData[index].value)
            let destinationPlaceMark = MKPlacemark(coordinate: arrData[index+1].value)
            print("\(sourcePlaceMark) --> \(destinationPlaceMark)\n")
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
            directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
            directionRequest.transportType = .automobile
            let directions = MKDirections(request: directionRequest)
            print(directions)
            
            directions.calculate { (response, error) in
                guard let directionResonse = response else {
                    if let error = error {
                        print("we have error getting directions==\(error.localizedDescription)")
                    }
                    return
                }
                
                //get route and assign to our route variable
                let route = directionResonse.routes[0]
                
                //add rout to our mapview
                self.mapView.addOverlay(route.polyline, level: .aboveLabels)
                
            }
        }
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
    
    func zoomToRegion() {
        
        mapView.region = MKCoordinateRegion(center: locations[0], span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
    }
    
    //MARK: - Mapkit delegate functions

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // get the particular pin that was tapped
        let pinToZoomOn = view.annotation

        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        // now move the map
        let region = MKCoordinateRegion(center: pinToZoomOn!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }

}
