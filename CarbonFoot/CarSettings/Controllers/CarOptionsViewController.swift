//
//  CarOptionsViewController.swift
//  CarbonFoot
//
//  Created by Aleksandra Korolczuk on 2017-11-30.
//  Copyright © 2017 Aleksandra Korolczuk. All rights reserved.
//

import UIKit

class CarOptionsViewController: UIViewController {

    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var optionsPicker: UIPickerView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    var year = ""
    var brand = ""
    var model = ""
    var option = ""

    private var brands: [Brand]?
    var pickerDataOptions: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        yearLabel.text! = self.year
        brandLabel.text = self.brand
        modelLabel.text = self.model
        self.model = (modelLabel.text?.replacingOccurrences(of: " ", with: "+"))!
    
        print(model)
        let url = "https://www.fueleconomy.gov/ws/rest/vehicle/menu/options?year=" + self.year + "&make=" + self.brand + "&model=" + self.model
        print(url)
        fetchData(url: url)
        optionsPicker.delegate = self
        optionsPicker.dataSource = self
       
    }


    func fetchData(url: String) {
        let apiCall = APICall()
        apiCall.parseFeed(url: url) { (brands) in
            self.brands = brands
            for brand in brands {
                self.pickerDataOptions.append(brand.brand)
            }
            OperationQueue.main.addOperation {
                self.optionsPicker.reloadAllComponents()
            }
        }
    }
}


extension CarOptionsViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataOptions.count

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataOptions[row]

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let row = optionsPicker.selectedRow(inComponent: 0)
        self.option = String(pickerDataOptions[row])
         self.performSegue(withIdentifier: .details, sender: nil)
    }

}
//
//// MARK: - Navigation
//
extension CarOptionsViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "CarCompletedViewController"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! CarCompletedViewController
            destination.year = self.year
            destination.brand = self.brand
            destination.model = self.model
            destination.option = self.option


        }
    }
}

//
