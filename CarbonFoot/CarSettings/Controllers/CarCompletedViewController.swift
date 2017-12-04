//
//  CarCompletedViewController.swift
//  CarbonFoot
//
//  Created by Aleksandra Korolczuk on 2017-11-30.
//  Copyright © 2017 Aleksandra Korolczuk. All rights reserved.
//

import UIKit
import CoreData

class CarCompletedViewController: UIViewController {
    
    @IBOutlet weak var yearLabel: UILabel!
    

    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    
    
    @IBOutlet var carCompletedView: UIView!
    
    var year = ""
    var brand = ""
    var model = ""
    var option = ""
    var id = ""
    var emission = ""
    var car: Car!


    
    
    // add text to labels
    
    private var brands: [Brand]?
    private var emissions: [Emission]?
    var dataDict = [String: String]()
    var emissionData: [String] = []


    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearLabel.text! = self.year
        brandLabel.text = self.brand
        modelLabel.text = self.model
        optionsLabel.text = self.option
     
        self.model = (modelLabel.text?.replacingOccurrences(of: " ", with: "+"))!
        print(model)
        let url = "https://www.fueleconomy.gov/ws/rest/vehicle/menu/options?year=" + self.year + "&make=" + self.brand + "&model=" + self.model
        print(url)
        fetchData(url: url)
    }
    
    
    func fetchData(url: String) {
        let apiCall = APICall()
        apiCall.parseFeed(url: url) { (brands) in
            self.brands = brands
            for brand in brands {
                self.dataDict.updateValue(brand.value, forKey: brand.brand)
            }
            OperationQueue.main.addOperation {
                print(self.dataDict)
                self.getId()
                let url_emission = "https://www.fueleconomy.gov/ws/rest/vehicle/" + self.id
                print(url_emission)
                self.fetchEmissiondata(url: url_emission)
                print("after Fetch Emission data")
                self.carCompletedView.setNeedsDisplay()
            }
        }
    }
    
    func getId() {
        for key in self.dataDict.keys {
            if  dataDict[option] != nil {
                self.id = dataDict[option]!
            }
        }
    }
    
    func fetchEmissiondata(url: String) {
        print("in fetch emission data")
        let apiCallEmission = APIEmissionCall()
        apiCallEmission.parseFeed(url: url) { (emissions) in
            self.emissions = emissions
            self.emission = emissions[0].emission
            print("parsing: \(self.emission)")
            self.saveCar()
            
        }
        
        OperationQueue.main.addOperation {
            print("Main queue: \(self.emission)")
            self.carCompletedView.setNeedsDisplay()
        }
    
}
    
    func saveCar (){
        let newCar = Car(context: CoreDataStack.context)
        newCar.year = self.year
        newCar.brand = self.brand
        newCar.model = self.model
        newCar.option = self.option
        newCar.emission = self.emission
        print(newCar.model)
        print(newCar.emission)
        CoreDataStack.saveContext()
        car = newCar

    }

    @IBAction func submitData(_ sender: UIButton) {
        self.performSegue(withIdentifier: .details, sender: nil)

    }
}


extension CarCompletedViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "NewRunViewController"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! NewRunViewController
            destination.car = car
        }
    }
}


