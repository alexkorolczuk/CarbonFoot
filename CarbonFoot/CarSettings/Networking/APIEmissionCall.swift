//
//  APIEmissionCall.swift
//  CarbonFoot
//
//  Created by Aleksandra Korolczuk on 2017-11-30.
//  Copyright © 2017 Aleksandra Korolczuk. All rights reserved.
//

import Foundation


class APIEmissionCall: NSObject, XMLParserDelegate {
    
    var emissions: [Emission] = []
    private var currentElement = ""
    private var currentEmission = ""{
        didSet {
            currentEmission = currentEmission.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
  
    
    private var parserCompletionHandler: (([Emission]) -> Void)?
    
    
    
    //not in main thread!!!
    func parseFeed(url: String, completionHandler: (([Emission]) -> Void)?) -> Void
    {
        self.parserCompletionHandler = completionHandler
        //completionHandler!(emissions)
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
//            self.parserCompletionHandler(data)
        }
        task.resume()
    }
    
    // MARK: - XML Parser Delegate.
    
    //this method is called whenever it reaches ELEMENT NAME (tag - > "text")
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        // going through xml file, find element (tag):
        currentElement = elementName
        if currentElement == "vehicle" {
            currentEmission = ""
        }
    }
    
    
    //this method is called whenever we find sth in menuItem
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if currentElement == "co2TailpipeGpm" {
            currentEmission += string
            print("Parser. This is current emission: \(currentEmission)")
        }
    }
    
    
    
    // when parser reaches closing tag - finishing element!!!
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "vehicle" {
            let emission = Emission(emission: currentEmission)
            self.emissions.append(emission)
              print(" Parser. This is self.emissions array: \(self.emissions)")
        }
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        print("calling handler")
        parserCompletionHandler?(emissions)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
