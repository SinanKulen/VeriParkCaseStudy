//
//  StockListDetailViewController.swift
//  VeriParkCaseStudy
//
//  Created by Sinan Kulen on 10.11.2021.
//

import UIKit
import Charts

class StockListDetailViewController: UIViewController {

    @IBOutlet weak var isUpDown: UIImageView!
    @IBOutlet weak var degisimLabel: UILabel!
    @IBOutlet weak var minimumLabel: UILabel!
    @IBOutlet weak var tabanLabel: UILabel!
    @IBOutlet weak var maximumLabel: UILabel!
    @IBOutlet weak var tavanLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    @IBOutlet weak var highestLabel: UILabel!
    @IBOutlet weak var gunlukYuksekLabel: UILabel!
    @IBOutlet weak var lowestLabel: UILabel!
    @IBOutlet weak var gunlukDususLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var satisLabel: UILabel!
    @IBOutlet weak var bidLabel: UILabel!
    @IBOutlet weak var alisLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var hacimLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var farkLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fiyatLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var sembolLabel: UILabel!
   
    @IBOutlet weak var lineChartView: LineChartView!
    var charts : LineChartView!
    var dataSet : LineChartDataSet!
    
    private var aesKey: String? {
        return UserDefaults.standard.string(forKey: "aesKey")
    }
    private var aesIV: String? {
        return UserDefaults.standard.string(forKey: "aesIV")
    }
    private var authorization: String? {
        return UserDefaults.standard.string(forKey: "authorization")
    }
    
    
    var isDown : Bool = false
    var isUp : Bool = false
    var bid : Double = 0.0
    var channge : Double = 0.0
    var count : Int = 0
    var difference : Double = 0.0
    var offer : Double = 0.0
    var highest : Double = 0.0
    var lowest : Double = 0.0
    var maximum : Double = 0.0
    var minimum : Double = 0.0
    var price : Double = 0.0
    var volume : Double = 0.0
    var symbol : String = ""
    var valuesArray : [Double] = []
    var daysArray : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailParse()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.symbolLabel.text = self.symbol
            self.bidLabel.text = String(self.bid)
            self.differenceLabel.text = String(self.difference)
            self.offerLabel.text = String(self.offer)
            self.priceLabel.text = String(self.price)
            self.lowestLabel.text = String(self.lowest)
            self.highestLabel.text = String(self.highest)
            self.minimumLabel.text = String(self.minimum)
            self.maximumLabel.text = String(self.maximum)
            self.countLabel.text = String(self.count)
            self.volumeLabel.text = String(self.volume)
            self.setChart()
            if (self.isUp == true) {
                self.isUpDown.image = UIImage(named: "up")
            } else {
                self.isUpDown.image = UIImage(named: "down")
            }
            
        }
        
    }
    func setChart( count: Int = 30) {
        let values = (daysArray).map { i -> ChartDataEntry in
            let value = Double(arc4random_uniform(UInt32(count)))
            return ChartDataEntry(x: Double(i), y: value)
        }
        let set = LineChartDataSet(entries: values, label: self.symbol)
        let data = LineChartData(dataSet: set)
        self.lineChartView.data = data
    }
    
    func detailParse() {
        let url = URL(string: "https://mobilechallenge.veripark.com/api/stocks/detail")!
        var request = URLRequest(url: url)
        let id = String(MainStock.selectedId)
        let params2 = ["id" : id.aesEncryption()]
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
                  self.bid = result["bid"] as! Double
                  self.channge = result["channge"] as! Double
                  self.isUp = result["isUp"] as! Bool
                  self.offer = result["offer"] as! Double
                  self.difference = result["difference"] as! Double
                  self.lowest = result["lowest"] as! Double
                  self.highest = result["highest"] as! Double
                  self.minimum = result["minimum"] as! Double
                  self.maximum = result["maximum"] as! Double
                  self.volume = result["volume"] as! Double
                  self.count = result["count"] as! Int
                  let sym = result["symbol"] as! String
                  self.symbol = sym.aesDecrypt()
                  let graphicData = result["graphicData"] as! [Dictionary<String,AnyObject>]
                  for i in graphicData{
                      self.daysArray.append(i["day"] as! Int)
                      self.valuesArray.append(i["value"] as! Double)
                  }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
}
