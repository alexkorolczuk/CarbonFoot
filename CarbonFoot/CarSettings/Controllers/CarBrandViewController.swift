//
//  CarBrandViewController.swift
//  CarbonFoot
//
//  Created by Aleksandra Korolczuk on 2017-11-30.
//  Copyright © 2017 Aleksandra Korolczuk. All rights reserved.
//

import UIKit

class CarBrandViewController: UIViewController {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var brandPicker: UIPickerView!
    
    
    var year = ""
    var brand = ""

    private var brands: [Brand]?
    
    var pickerDataBrands: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearLabel.text! = self.year
        let url = "https://www.fueleconomy.gov/ws/rest/vehicle/menu/make?year=" + self.year
        print(url)
        fetchData(url: url)
        brandPicker.delegate = self
        brandPicker.dataSource = self
        
    }
    
    
    func fetchData(url: String) {
        let apiCall = APICall()
        apiCall.parseFeed(url: url) { (brands) in
            self.brands = brands
            for brand in brands {
                self.pickerDataBrands.append(brand.brand)
            }
            OperationQueue.main.addOperation {
                self.brandPicker.reloadAllComponents()
            }
        }
    }
}

extension CarBrandViewController:UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataBrands.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataBrands[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let row = brandPicker.selectedRow(inComponent: 0)
        self.brand = String(pickerDataBrands[row])
        self.performSegue(withIdentifier: .details, sender: nil)
    }
    
}

// MARK: - Navigation

extension CarBrandViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "CarModelViewController"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
        let destination = segue.destination as! CarModelViewController
            destination.year = self.year
            destination.brand = self.brand
      
            }
        }
    }


    

