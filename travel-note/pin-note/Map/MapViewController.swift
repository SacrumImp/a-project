//
//  HomeViewController.swift
//  travel-note
//
//  Created by Алексей Савельев on 26.10.2020.
//

import UIKit
import FirebaseAuth
import GoogleMaps
import QuartzCore

class MapViewController: UIViewController, GMSMapViewDelegate{
    
    var viewModel: MapViewModelProtocol!{didSet{}}
    
    let labelVC: UILabel = {
        let lable = UILabel(frame:CGRect(x: 0, y: 50, width: 300, height: 100))
        lable.text = "MapVC" //STRINGS:
        lable.font = .systemFont(ofSize: 24, weight: .bold)
        lable.textAlignment = .center
        lable.layer.backgroundColor = UIColor.systemGreen.cgColor.copy(alpha: 0.3)
        lable.layer.cornerRadius = 10
        return lable
    }()
    
    let testSettingsButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 280, y: 50, width: 120, height: 35))
        button.setTitle("Настройки", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal) //красным чтоб заметно было
        button.layer.backgroundColor = UIColor.systemRed.cgColor.copy(alpha: 0.3)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // перед появлением определяем на какой странице будет открыт tab bar
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.selectedIndex = Common.Settings.StartingHomePage
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let mapView = getMapView()
        view.addSubview(mapView)
        
        view.addSubview(labelVC)
        labelVC.center.x = self.view.center.x
        
        view.addSubview(testSettingsButton)
        testSettingsButton.addTarget(self, action: #selector(openSettings(sender:)), for: .touchUpInside)
        
    }
    
    func getMapView() -> UIView{
        
        let location = viewModel.getLocation()
        
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        marker.title = "Ваше местоположение" //STRINGS:
        marker.map = mapView
        
        return mapView
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        // закоментированно, так как засоряет консоль
        //print("You get into 'didChange' section")
        UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.labelVC.transform = CGAffineTransform(translationX: 0, y: -90)
            self.testSettingsButton.transform = CGAffineTransform(translationX: 140, y: 0)
        })
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("You get into 'idleAt' section")
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            //self.lableVC.transform = self.lableVC.transform.translatedBy(x: 0, y: 50)
            self.labelVC.transform = CGAffineTransform(translationX: 0, y: 0)
            self.testSettingsButton.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    
    // MARK: Buttons
    @objc func openSettings(sender: UIButton) {
        let settingsView = SettingsView()
        let navVC = UINavigationController(rootViewController: settingsView)
        navVC.modalTransitionStyle = .crossDissolve
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
}