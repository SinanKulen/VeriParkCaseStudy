//
//  StockListViewController.swift
//  VeriParkCaseStudy
//
//  Created by Sinan Kulen on 9.11.2021.
//

import UIKit
import CryptoSwift
import SideMenu

class StockListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MenuControllerDelegate, UISearchBarDelegate {

   
    private var sideMenu : SideMenuNavigationController?
    
    @IBOutlet var viewController: UIView!
    @IBOutlet weak var degisimLabel: UILabel!
    @IBOutlet weak var satisLabel: UILabel!
    @IBOutlet weak var alisLabel: UILabel!
    @IBOutlet weak var hacimLabel: UILabel!
    @IBOutlet weak var farkLabel: UILabel!
    @IBOutlet weak var fiyatLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let vc = ViewController()
    let refreshControl = UIRefreshControl()
    var isSearch = false
    var stockSymbolArray : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        sideMenu?.leftSide = true
        let menu = MenuController(with: ["Hisse ve Endeksler","Yükselenler","Düşenler","Hacme Göre - 30","Hacme Göre - 50","Hacme Göre - 100"])
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        title = "IMKB Hisse ve Endeksler"
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearch = true
        let filterString = MainStock.stockSymbolArray.filter({ (str: String) -> Bool in
            let stringMatch = str.lowercased().range(of: searchText.lowercased())
            return stringMatch != nil ? true : false
        })
        stockSymbolArray = filterString
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (MainStock.stockVolumeArray == nil) {
            showAlert(title: "Error", message: "İnternetinizi kontrol ettikten sonra tekrar butona basınız.")
            return
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearch == true) {
            return stockSymbolArray.count
        } else {
        return MainStock.stockVolumeArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StockListTableViewCell
        if (isSearch == true) {
            cell.stockSymbol.text = stockSymbolArray[indexPath.row]
        } else {
            cell.stockSymbol.text = MainStock.stockSymbolArray[indexPath.row]
            cell.stockOffer.text = String(MainStock.stockOfferArray[indexPath.row])
            cell.stockVolume.text = String(MainStock.stockVolumeArray[indexPath.row])
            cell.stockPrice.text = String(MainStock.stockPriceArray[indexPath.row])
            cell.stockDifference.text = String(MainStock.stockDifferenceArray[indexPath.row])
            cell.stockBid.text = String(MainStock.stockIdArray[indexPath.row])
            if (MainStock.stockIsDownArray[indexPath.row] == false) {
                cell.upDownImage.image = UIImage(named: "up")
            }else {
                cell.upDownImage.image = UIImage(named: "down")
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MainStock.selectedId = MainStock.stockIdArray[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func didTapMenu() {
        present(sideMenu!, animated: true)
    }
    
    func didSelectMenuItem(named: String) {
        sideMenu?.dismiss(animated: true, completion: {
            if named == "Hacme Göre - 100" {
                MainStock.periodName = "volume100"
                if (self.vc.stockParse()) {
                    print("success")
                    self.tableView.reloadData()
                }
            }
            if named == "Hacme Göre - 50" {
                MainStock.periodName = "volume50"
                if (self.vc.stockParse()) {
                    print("success")
                    self.tableView.reloadData()
                }
            }
            if named == "Hacme Göre - 30" {
                MainStock.periodName = "volume30"
                if (self.vc.stockParse()) {
                    print("success")
                    self.tableView.reloadData()
                }
            }
            if named == "Hisse ve Endeksler" {
                MainStock.periodName = "all"
                if (self.vc.stockParse()) {
                    print("success")
                    self.tableView.reloadData()
                }
            }
            if named == "Yükselenler" {
                MainStock.periodName = "increasing"
                if (self.vc.stockParse()) {
                    print("success")
                    self.tableView.reloadData()
                }
            }
            if named == "Düşenler" {
                MainStock.periodName = "decreasing"
                if (self.vc.stockParse()) {
                    print("success")
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func showAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert,animated:true,completion:nil)
    }

}
