//
//  APICall.swift
//  CarbonFoot
//
//  Created by Aleksandra Korolczuk on 2017-11-29.
//  Copyright © 2017 Aleksandra Korolczuk. All rights reserved.
//

import Foundation


class APICall: NSObject, XMLParserDelegate {
   
    var brands: [Brand] = []
    private var currentElement = ""
    private var currentBrand = ""{
        didSet {
            currentBrand = currentBrand.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentValue = ""{
        didSet {
            currentValue = currentValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
   // private var url = "https://www.fueleconomy.gov/ws/rest/vehicle/menu/make?year=2012"
    private var parserCompletionHandler: (([Brand]) -> Void)?
    

    
    //not in main thread!!!
    func parseFeed(url: String, completionHandler: (([Brand]) -> Void)?) -> Void
    {
    self.parserCompletionHandler = completionHandler
    
    let request = URLRequest(url: URL(string: url)!)
    let urlSession = URLSession.shared
    let task = urlSession.dataTask(with: request) { (data, response, error) in
        //getting data, esle error.
        guard let data = data else {
            if let error = error {
                print(error.localizedDescription)
            }
            return
        }
        //parse XML!!!!!!
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse() // our parser is parsing data. that's it
    }
        task.resume()
    }
    
    // MARK: - XML Parser Delegate.
    
    //this method is called whenever it reaches ELEMENT NAME (tag - > "text")
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        // going through xml file, find element (tag):
        currentElement = elementName
        if currentElement == "menuItem" {
            currentBrand = ""
            currentValue = ""
        }
    }
    
    
    //this method is called whenever we find sth in menuItem
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
        case "text": currentBrand += string
        case "value": currentValue += string
        default: break
            
        }
    }

    
    // when parser reaches closing tag - finishing element!!!
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "menuItem" {
            let brand = Brand(brand: currentBrand, value: currentValue)
            self.brands.append(brand)
        }
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(brands)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
