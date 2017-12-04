//
//  CarModelViewController.swift
//  CarbonFoot
//
//  Created by Aleksandra Korolczuk on 2017-11-30.
//  Copyright © 2017 Aleksandra Korolczuk. All rights reserved.
//

import UIKit

class CarModelViewController: UIViewController {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var modelPicker: UIPickerView!
    @IBOutlet weak var brandLabel: UILabel!
    
    var year = ""
    var brand = ""
    var model = ""
    
    private var brands: [Brand]?
    var pickerDataModels: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearLabel.text! = self.year
        brandLabel.text = self.brand
        self.brand = (brandLabel.text?.replacingOccurrences(of: " ", with: "+"))!

        let url = "https://www.fueleconomy.gov/ws/rest/vehicle/menu/model?year=" + self.year + "&make=" + self.brand
        print(url)
        fetchData(url: url)
        modelPicker.delegate = self
        modelPicker.dataSource = self

        
    }
    
    
    func fetchData(url: String) {
        let apiCall = APICall()
        apiCall.parseFeed(url: url) { (brands) in
            self.brands = brands
            for brand in brands {
                self.pickerDataModels.append(brand.brand)
            }
            OperationQueue.main.addOperation {
                self.modelPicker.reloadAllComponents()
            }
        }
    }
}


extension CarModelViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataModels.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataModels[row]

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let row = modelPicker.selectedRow(inComponent: 0)
        self.model = String(pickerDataModels[row])
        self.performSegue(withIdentifier: .details, sender: nil)
    }

}

// MARK: - Navigation

extension CarModelViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "CarOptionsViewController"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! CarOptionsViewController
            destination.year = self.year
            destination.brand = self.brand
            destination.model = self.model

        }
    }
}



