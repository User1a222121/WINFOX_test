//
//  PlacesMapViewController.swift
//  WINFOX_test
//
//  Created by Сергей Карпов on 09.06.2022.
//

import UIKit
import MapKit

class PlacesMapViewController: UIViewController {
    
    //MARK: propirties
    let locationManager = CLLocationManager()
    var places: [PlacesModelData] = []
    
    //MARK: outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        checkLocation()
        getPlaces()
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocation()
    }
    
    //MARK: private func
    private func setupUI() {
        
        mapView.delegate = self
    }
    
    private func checkLocation() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkAuthorization()
        } else {
            self.popupAlert(title: "Служба геолокации отключена", message: "Вы хотите включить ее?",
                            actionTitles: ["Позже","Включить"],
                            actionStyle: [.cancel, .default],
                            actions:[{ action1 in
                // todo tap later
                },{ action2 in
                    guard let urlSettingLocation = URL(string: "App-Prefs:root=LOCATION_SERVICES") else {return}
                    UIApplication.shared.open(urlSettingLocation, options: [:], completionHandler: nil )
                    }],
                            vc: self)
        }
    }
    
    private func checkAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            NetworkServices.shared.sendCoords(latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude) { success in
                guard success else { return }
                print("Coordinate send to server success")
            }
            break
        case .denied:
            self.popupAlert(title: "Вы запретили использование локации.", message: "Вы хотите изменить это?",
                            actionTitles: ["Позже","Включить"],
                            actionStyle: [.cancel, .default],
                            actions:[{ action1 in
                // todo tap later
                },{ action2 in
                    guard let urlSettingLocation = URL(string: "App-Prefs:root=LOCATION_SERVICES") else {return}
                    UIApplication.shared.open(urlSettingLocation, options: [:], completionHandler: nil )
                    }],
                            vc: self)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    private func getPlaces() {
        NetworkServices.shared.getPlace { (result) in
            switch result {
            case .success(let data):
                self.places = data
                self.putPointAnnotations()
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                let alertVC = UIAlertController(
                            title: "Ошибка",
                            message: "Ошибка подключения к серверу. Попробуйте позже.",
                            preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    private func putPointAnnotations() {
        
        if !places.isEmpty {
            for place in places
            {
                let annotation = MKPointAnnotation()
                annotation.title = place.name
                annotation.accessibilityElementsHidden = true
                annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitide, longitude: place.longitude)
                mapView.addAnnotation(annotation)
            }
        }
    }
}


//MARK: extensions
extension PlacesMapViewController:  CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
            mapView.setRegion(region, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}

extension PlacesMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let place = places.filter{ $0.name == view.annotation?.title}
        if !place.isEmpty {
            
            NetworkServices.shared.getMenu(id: place.first?.id ?? "") { (result) in
                switch result {
                case .success(let data):
                    let vc = MenuPlaceViewController()
                    vc.menu = data
                    self.setupAlertController(with: place.first?.name ?? "", with: vc)
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    let alertVC = UIAlertController(
                                title: "Ошибка",
                                message: "Ошибка подключения к серверу",
                                preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertVC.addAction(action)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
}
