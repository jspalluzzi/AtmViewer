//
//  ViewController.swift
//  hackAnATM
//
//  Created by xavier on 1/4/17.
//  Copyright © 2017 John. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

/*
 If I had more time:
    I would of made the Pop Transition more clean, the views get squished. Looks funny.
    I would of use Core Text and Attribute the Text
    There are some issues with switching the opaqueness
    Worked out more of the constraint issues in Storyboard
 */

class ViewController: UIViewController {
    
    let atmManager = AtmManager()
    
    let popAnimation = PopAnimator()
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView:GMSMapView!
    var selectedMarker: GMSMarker?
    let zoomMin = Float(12.0)
    let zoomMax = Float(15.0)
    
    @IBOutlet weak var bottomView: UIView!
    var bottomViewCenterYUp: CGFloat!
    var bottomViewCenterYDown: CGFloat!
    @IBOutlet weak var addressLable: UILabel!
    @IBOutlet weak var typeLable: UILabel!
    @IBOutlet weak var nameLable: UILabel!
    
    
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up Location Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = CLLocationDistance.abs(6.0)    //Must move at least 6 meters for a location update
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestLocation()
        
        //Atm Manager Delegate
        atmManager.delegate = self
        
        //If transistion to the scene, make sure the bottom view is visable again
        popAnimation.dismissCompletion = {
            self.bottomView?.isHidden = false
        }
        
        self.setUpBottomView()
        
    }
    
    //If User location data is not avaliable
    override func viewWillAppear(_ animated: Bool) {
        //Load a location while we wait for user's location
        if mapView == nil{
            setUpMap(location: CLLocationCoordinate2D(latitude: 40.147864, longitude: -82.990959))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Should only have one method to set up the map, take in whether to use a location
    func setUpMap(location: CLLocationCoordinate2D){
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: zoomMin)
        mapView.camera = camera
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(zoomMin, maxZoom: zoomMax)
    }
    
    //MARK: - BOTTOM VIEW
    func setUpBottomView(){
        
        // Give the bottomView a slight corner radius
        self.bottomView.layer.cornerRadius = 20.0
        self.bottomView.layer.masksToBounds = true
        
        //Save the
        self.bottomViewCenterYUp = self.bottomView.center.y
        self.bottomViewCenterYDown = self.bottomViewCenterYUp + view.bounds.height
        
        self.animateBottomView()
    }
    
    //change the name of this function
    func animateBottomView(){
        if(self.selectedMarker != nil){
            UIView.animate(withDuration: 0.5, delay:0.0, usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.0,
                           animations: {
                            self.bottomView.center.y = self.bottomViewCenterYUp
                            self.mapView.padding = UIEdgeInsetsMake(0, 0, self.bottomView.frame.height, 0)
                            self.selectedMarker?.opacity = 0.5
            })
        }else{
            UIView.animate(withDuration: 0.5, delay:0.0, usingSpringWithDamping: 6.0,
                           initialSpringVelocity: 0.0,
                           animations: {
                            self.bottomView.center.y = self.bottomViewCenterYDown
                            self.mapView.padding = UIEdgeInsets.zero
            })
        }
    }
    
    @IBAction func didTapBottomView(_ sender: UITapGestureRecognizer) {
        
        //present details view controller
        let atmDetailVC = storyboard!.instantiateViewController(withIdentifier: "AtmDetailViewController") as! AtmDetailViewController
        atmDetailVC.transitioningDelegate = self
        atmDetailVC.atmInfo = self.selectedMarker?.userData as! AtmInformation
        present(atmDetailVC, animated: true, completion: nil)
        
    }
    
    //MARK: - HELPING FUNCTIONS
    //We save the Atm Information in the Map Markers
    func addMapMarkers(atmInfos: [AtmInformation]){
        
        for atm in atmInfos{
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            
            marker.position = CLLocationCoordinate2D(latitude: atm.lat, longitude: atm.lng)
            marker.title = atm.name
            marker.snippet = atm.type
            marker.userData = atm //Save Atm Information here
            marker.map = mapView
            if(atm.type.contains("atm") || atm.type.contains("In-Line")){
                marker.icon = UIImage(named: "atm_marker")
            }else{
                marker.icon = UIImage(named: "bank_marker")
            }
        }
    }
}

//MARK: - EXTENTIONS

extension ViewController: AtmManagerDelegate{
    
    func didRecieveNewAtmInfo(newAtmInfo: [AtmInformation]) {
        
        //remove all markers
        self.mapView.clear()
        
        //Should do this in the background
        self.addMapMarkers(atmInfos: newAtmInfo)
        
    }
    
}

extension ViewController: GMSMapViewDelegate{
    
    //Removes the selected marker
    //Old selected marker is now full opac
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if let oldMarker = self.selectedMarker{
            oldMarker.opacity = 1
        }
        
        self.selectedMarker = nil
        self.animateBottomView()
        
    }
    
    //Old selected marker is now full opac
    //Sets the Text for Bottom View
    //Sets the selected Marker
    //Calls animateBottomView()
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let oldMarker = self.selectedMarker{
            oldMarker.opacity = 1
        }
        
        let atmInformation = marker.userData as! AtmInformation
        
        self.nameLable.text = atmInformation.name
        self.typeLable.text = atmInformation.type
        self.addressLable.text = atmInformation.address
        
        self.selectedMarker = marker
        self.animateBottomView()
        
        return true
    }
    
    
    //Moving the map, makes API Call for new Bank Locations
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.atmManager.getATMLocations(coordinates: position.target)
    }
}

extension ViewController: CLLocationManagerDelegate{
    
    //Set the Map up when we have the user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.first {
            self.setUpMap(location: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status{
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .authorizedAlways:
            print("authorizedAlways")
        case .denied:
            self.setUpMap(location: CLLocationCoordinate2D(latitude: 40.147864, longitude: -82.990959))
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        popAnimation.originFrame = bottomView!.superview!.convert(bottomView!.frame, to: nil)
        
        popAnimation.presenting = true
        bottomView!.isHidden = true
        
        return popAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        popAnimation.presenting = false
        return popAnimation
    }
}

