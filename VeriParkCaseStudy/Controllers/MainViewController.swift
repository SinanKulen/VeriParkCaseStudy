//
//  MainViewController.swift
//  VeriParkCaseStudy
//
//  Created by Sinan Kulen on 10.11.2021.
//

import UIKit

class MainViewController: UIViewController {

    var timer = Timer()
    var counter = 0
    @IBOutlet weak var stockButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    let viewController  = ViewController()
    var auth : Bool!
    var parse : Bool!
    override func viewDidLoad() {
        counter = 5
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerfunction), userInfo: nil, repeats: true)
        super.viewDidLoad()
        stockButton.setTitle("IMKB Hisse Senetleri/Endeksler", for: .normal)
        self.auth = viewController.authParse()
        self.parse = viewController.stockParse()
    }
    
    @IBAction func stockButtonClicked(_ sender: Any) {
        if (self.auth) {
            if (self.parse){
                print("Success")
            } else { showAlert(title: "Error", message: "İnternetinizi kontrol ettikten sonra tekrar butona basınız.")}
        } else { showAlert(title: "Error", message: "İnternetinizi kontrol ettikten sonra tekrar butona basınız.")}
    }
    func showAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert,animated:true,completion:nil)
    }
   
    
    @objc func timerfunction(){
        stockButton.isHidden = true
        counter -= 1
        if counter == 0 {
            timer.invalidate()
            stockButton.isHidden = false
        }
    }
}
