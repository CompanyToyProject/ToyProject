//
//  ViewController.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/15.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clickGooglePlaces(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "GoogleMapView", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "GoogleMapView") as? GoogleMapViewController else {
            return
        }
        getNavigationController().pushViewController(vc, animated: true)
    }
}


