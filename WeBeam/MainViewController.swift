//
//  MainViewController.swift
//  WeBeam
//
//  Created by Shuangshuang Zhao on 2015-09-08.
//  Copyright (c) 2015 Shuangshuang Zhao. All rights reserved.
//

import UIKit
import MapKit
import Parse
class MainViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var Container: UIView!
    var locationManager: CLLocationManager!
    var tableViewController: TableViewController {
        return (self.childViewControllers.last as? TableViewController)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    // get the coordinate for coresponding map point
    func getCoordinateFromMapRectanglePoint(x: Double, y: Double) -> CLLocationCoordinate2D {
        var myMapPoint = MKMapPointMake(x, y)
        return MKCoordinateForMapPoint(myMapPoint)
    }
    
    // get the visible region North East Coordinate
    func getNECoordinate(myMapRect: MKMapRect) -> CLLocationCoordinate2D {
        return self.getCoordinateFromMapRectanglePoint(MKMapRectGetMaxX(myMapRect), y: myMapRect.origin.y)
    }
    
    // get the visible region South West Coordinate
    func getSWCoordinate(myMapRect: MKMapRect) -> CLLocationCoordinate2D {
        return self.getCoordinateFromMapRectanglePoint(myMapRect.origin.x, y: MKMapRectGetMaxY(myMapRect))
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EmbedTableSegue" {
            
        }
    }
    
    var annotation = MKPointAnnotation()
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        // uncomment it if you want to zoom into current location
        
        // set the current location and region on map
        let currentLocation = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        self.mapView.setRegion(region, animated: false)
        
        self.mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()

    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        
        //clear the table
        tableViewController.weBeamUsers.removeAll(keepCapacity: false)
        tableViewController.tableView.reloadData()
        
        
        // this is the visible region in the device
        var mapRect = mapView.visibleMapRect
        var regionNECoordinate = self.getNECoordinate(mapRect)
        var regionSWCoordiante = self.getSWCoordinate(mapRect)
        
        let query = PFQuery(className: "_User")
        var swLocation = CLLocation(latitude: regionSWCoordiante.latitude, longitude: regionSWCoordiante.longitude)
        var swPFGeoPoint = PFGeoPoint(location: swLocation)
        var neLocation = CLLocation(latitude: regionNECoordinate.latitude, longitude: regionNECoordinate.longitude)
        var nePFGeoPoint = PFGeoPoint(location: neLocation)
        query.whereKey("location", withinGeoBoxFromSouthwest: swPFGeoPoint, toNortheast: nePFGeoPoint)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if error == nil {
                    self.tableViewController.weBeamUsers.removeAll(keepCapacity: false)
                    var weBeamUsers = [WeBeamUser]()
                    
                    for user in objects! {
                        let weBeamUser = user as! WeBeamUser
                        weBeamUsers.append(weBeamUser)
                    }
                    self.tableViewController.weBeamUsers.insert(weBeamUsers, atIndex: 0)
                    self.tableViewController.tableView.reloadData()
                    println("Successfully retrieved: \(objects)")
                } else {
                    // put default data to table view
                    println("Error: \(error) \(error!.userInfo!)")
                }
            }
        }
        
    }
    

}
