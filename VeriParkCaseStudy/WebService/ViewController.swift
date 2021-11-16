//
//  ViewController.swift
//  VeriParkCaseStudy
//
//  Created by Sinan Kulen on 5.11.2021.
//

import UIKit
import CryptoSwift
import RNCryptor

class ViewController: UIViewController {

    var stockIdArray: [Int] = []
    var stockIsDownArray : [Bool] = []
    var stockIsUpArray : [Bool] = []
    var stockBidArray : [Double] = []
    var stockDifferenceArray : [Double] = []
    var stockOfferArray : [Double] = []
    var stockPriceArray : [Double] = []
    var stockVolumeArray : [Double] = []
    var stockSymbolArray : [String] = []
    var stockSymbolCrpArray : [String] = []
    
    private var aesKey: String? {
        return UserDefaults.standard.string(forKey: "aesKey")
    }
    private var aesIV: String? {
        return UserDefaults.standard.string(forKey: "aesIV")
    }
    private var authorization: String? {
        return UserDefaults.standard.string(forKey: "authorization")
    }
    var periodName = MainStock.periodName ?? "all"
    
    override func viewDidLoad() {
    super.viewDidLoad()
    }
        
    func authParse() -> Bool {
          
        let params = [
                "deviceID" : "8753A0BB-03D5-43A6-A3FF-8D67C74506F9",
                "systemVersion" : "15.0",
                "platformName" : "iOS",
                "deviceModel" : "iPhone 13 Pro Max",
                "manifacturer" : "Apple" ]
        
            let url = URL(string: "https://mobilechallenge.veripark.com/api/handshake/start")!
            var request =  URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("/api/handshake/start", forHTTPHeaderField: "POST")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

            let task = URLSession.shared.dataTask(with: request) { [self] data, _, error in
            
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(AuthModel.self, from: data)
                    authKeys(jsons: json)
                    
                    } catch {
                    print(error)
                    }
            }
            task.resume()
        if (authorization == nil) {
            return false
            }else {
            return true
            }
        }
 
    func stockParse() -> Bool {
        let url = URL(string: "https://mobilechallenge.veripark.com/api/stocks/list")!
        var request = URLRequest(url: url)
        let params2 = ["period" : periodName.aesEncryption()]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params2, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("api/handshake/start", forHTTPHeaderField: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authorization, forHTTPHeaderField: "X-VP-Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
              if let result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject] {
                    let resultStocks = result["stocks"] as! [Dictionary<String,AnyObject>]
                    for stock in resultStocks {
                        let symbolArray = stock
                        self.stockIdArray.append(symbolArray["id"] as! Int)
                        self.stockIsDownArray.append(symbolArray["isDown"] as! Bool)
                        self.stockIsUpArray.append(symbolArray["isUp"] as! Bool)
                        self.stockBidArray.append(symbolArray["bid"] as! Double)
                        self.stockDifferenceArray.append(symbolArray["difference"] as! Double)
                        self.stockOfferArray.append(symbolArray["offer"] as! Double)
                        self.stockPriceArray.append(symbolArray["price"] as! Double)
                        self.stockVolumeArray.append(symbolArray["volume"] as! Double)
                        self.stockSymbolArray.append(symbolArray["symbol"] as! String)
                        print(self.stockVolumeArray)
                    }
                  for stock in self.stockSymbolArray {
                      let stockDecrypt = stock.aesDecrypt()
                      self.stockSymbolCrpArray.append(stockDecrypt)
                  }
                  MainStock.stockSymbolArray = self.stockSymbolCrpArray
                  MainStock.stockIdArray = self.stockIdArray
                  MainStock.stockPriceArray = self.stockPriceArray
                  MainStock.stockIsDownArray = self.stockIsDownArray
                  MainStock.stockIsUpArray = self.stockIsUpArray
                  MainStock.stockOfferArray = self.stockOfferArray
                  MainStock.stockVolumeArray = self.stockVolumeArray
                  MainStock.stockDifferenceArray = self.stockDifferenceArray
              }
            } catch {
                print(error.localizedDescription)
            }
        })
        task.resume()
        if (MainStock.stockOfferArray == nil) {
                return false
            }else {
                return true
            }
      
    }
    
    func authKeys(jsons : AuthModel) {
        UserDefaults.standard.set(jsons.authorization, forKey: "authorization")
        UserDefaults.standard.set(jsons.aesKey, forKey: "aesKey")
        UserDefaults.standard.set(jsons.aesIV, forKey: "aesIV")
    }
    
}




