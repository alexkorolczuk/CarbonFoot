//
//  CarSettingsViewController.swift
//  CarbonFoot
//
//  Created by Aleksandra Korolczuk on 2017-11-29.
//  Copyright © 2017 Aleksandra Korolczuk. All rights reserved.
//

import UIKit
import CoreData


class CarSettingsViewController: UIViewController {
    
    @IBOutlet weak var pickerYear: UIPickerView!
    
    var year = ""
    private var brands: [Brand]?
    var pickerDataYears: [String] = []
    var pickerDataBrands: [String] = []
    var pickerDataModels: [String] = []
    let navigationBar : UINavigationBar = UINavigationBar()



    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "https://www.fueleconomy.gov/ws/rest/vehicle/menu/year"
        fetchData(url: url)
        pickerYear.delegate = self
        pickerYear.dataSource = self
        self.navigationController?.navigationBar.barTintColor = .white
       
    }
    
    
    func fetchData(url: String) {
        let apiCall = APICall()
        apiCall.parseFeed(url: url) { (brands) in
            self.brands = brands
            for brand in brands {
                self.pickerDataYears.append(brand.brand)
            }
            OperationQueue.main.addOperation {
                self.pickerYear.reloadAllComponents()
            }
        }
    }
}

extension CarSettingsViewController:UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerDataYears.count

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerDataYears[row]
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let row = pickerYear.selectedRow(inComponent: 0)
            self.year = String(pickerDataYears[row])
            self.performSegue(withIdentifier: .details, sender: nil)
        }
    
}

// MARK: - Navigation

extension CarSettingsViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "CarBrandViewController"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! CarBrandViewController
            destination.year = self.year
//            if let navigationController = segue.destination as? UINavigationController {
//                let childViewController = navigationController.topViewController as? CarBrandViewController
//                childViewController?.year = car.year!
        }
    }
}



