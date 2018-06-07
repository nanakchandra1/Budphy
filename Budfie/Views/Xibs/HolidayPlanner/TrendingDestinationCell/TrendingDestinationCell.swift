//
//  TrendingDestinationCell.swift
//  Budfie
//
//  Created by Aakash Srivastav on 10/04/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

protocol TrendingDestinationLocationDelegate: class {
    func getLocation(isNational: Bool, placeName: String)
}

class TrendingDestinationCell: UITableViewCell {

    //MARK: Properties
    //================
    var isNational: Bool = Bool()
    weak var delegate: TrendingDestinationLocationDelegate?
    let nationalPlaces = ["Kumarakom (Kerala)",
                          "Darjeeling",
                          "Gangtok (Sikkim)",
                          "Manali",
                          "Ooty"]
    let interNationalPlaces = ["Malacca, Malaysia",
                               "Singapore",
                               "Kathmandu, Nepal",
                               "Krabi, Thailand",
                               "Colombo, Sri Lanka"]
    let nationalImages = [#imageLiteral(resourceName: "Kumarakom"),
                          #imageLiteral(resourceName: "Darjeeling"),
                          #imageLiteral(resourceName: "Gangtok"),
                          #imageLiteral(resourceName: "manali"),
                          #imageLiteral(resourceName: "Ooty")]
    let interNationalImages = [#imageLiteral(resourceName: "Malacca"),
                               #imageLiteral(resourceName: "Singapore"),
                               #imageLiteral(resourceName: "Kathmandu"),
                               #imageLiteral(resourceName: "Krabi"),
                               #imageLiteral(resourceName: "Colombo")]

    //MARK: @IBOutlet
    //===============
    @IBOutlet weak var destinationCollectionView: UICollectionView!
    @IBOutlet weak var trendingHeaderLabel: UILabel!

    //MARK: cell life cycle
    //=====================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    //MARK: initial setup
    //===================
    func initialSetUp() {

        let destinationDescriptionCell = UINib(nibName: "DestinationDescriptionCell", bundle: nil)
        destinationCollectionView.register(destinationDescriptionCell, forCellWithReuseIdentifier: "DestinationDescriptionCell")

        self.destinationCollectionView.delegate = self
        self.destinationCollectionView.dataSource = self
    }

    //MARK: Populate cell method
    //==========================
    func populateView() {

    }
}
