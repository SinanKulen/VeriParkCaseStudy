//
//  StockListTableViewCell.swift
//  VeriParkCaseStudy
//
//  Created by Sinan Kulen on 9.11.2021.
//

import UIKit

class StockListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var upDownImage: UIImageView!
    @IBOutlet weak var stockSymbol: UILabel!
    @IBOutlet weak var stockOffer: UILabel!
    @IBOutlet weak var stockBid: UILabel!
    @IBOutlet weak var stockVolume: UILabel!
    @IBOutlet weak var stockDifference: UILabel!
    @IBOutlet weak var stockPrice: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
