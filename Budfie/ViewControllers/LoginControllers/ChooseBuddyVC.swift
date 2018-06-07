//
//  ChooseBuddyVC.swift
//  Budfie
//
//  Created by Aakash Srivastav on 28/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import UIKit

protocol BuddyDelegate: class {
    func didChangeBuddy(to buddy: ChooseBuddyVC.Buddy)
}

class ChooseBuddyVC: BaseVc {

    enum Buddy: String {
        case assistant
        case superhero
        case pet

        var name: String {
            return self.rawValue.uppercased()
        }
    }

    weak var delegate: BuddyDelegate?
    private var selectedBuddy: Buddy = .assistant {
        didSet {
            resetSelectedBuddy()
            changeSelectedBuddyText()
        }
    }

    @IBOutlet weak var navigationView: CurvedNavigationView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var status: UIView!

    @IBOutlet weak var assistantContainerView: UIView!
    @IBOutlet weak var superHeroContainerView: UIView!
    @IBOutlet weak var petContainerView: UIView!

    @IBOutlet weak var assistantImageView: UIImageView!
    @IBOutlet weak var superHeroImageView: UIImageView!
    @IBOutlet weak var petImageView: UIImageView!

    @IBOutlet weak var assistantLbl: UILabel!
    @IBOutlet weak var superHeroLbl: UILabel!
    @IBOutlet weak var petLbl: UILabel!

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        status.backgroundColor = AppColors.themeBlueColor
        navigationView.backgroundColor = UIColor.clear
        submitBtn.round()
        addTapGestures()
    }

    private func addTapGestures() {

        let assistantImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(assistantTapped))
        assistantImageView.addGestureRecognizer(assistantImageTapGesture)

        let assistantLblTapGesture = UITapGestureRecognizer(target: self, action: #selector(assistantTapped))
        assistantLbl.addGestureRecognizer(assistantLblTapGesture)

        let superHeroImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(superHeroTapped))
        superHeroImageView.addGestureRecognizer(superHeroImageTapGesture)

        let superHeroLblTapGesture = UITapGestureRecognizer(target: self, action: #selector(superHeroTapped))
        superHeroLbl.addGestureRecognizer(superHeroLblTapGesture)

        let petImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(petTapped))
        petImageView.addGestureRecognizer(petImageTapGesture)

        let petLblTapGesture = UITapGestureRecognizer(target: self, action: #selector(petTapped))
        petLbl.addGestureRecognizer(petLblTapGesture)

        let buddyValue = AppUserDefaults.value(forKey: .selectedBuddy).stringValue
        if let buddy = ChooseBuddyVC.Buddy(rawValue: buddyValue) {
            selectedBuddy = buddy
        } else {
            backBtn.isHidden = true
            selectedBuddy = .assistant
        }
    }

    @objc private func assistantTapped(_ gesture: UITapGestureRecognizer) {
        selectedBuddy = .assistant
    }

    @objc private func superHeroTapped(_ gesture: UITapGestureRecognizer) {
        selectedBuddy = .superhero
    }

    @objc private func petTapped(_ gesture: UITapGestureRecognizer) {
        selectedBuddy = .pet
    }

    private func resetSelectedBuddy() {
        assistantLbl.attributedText = nil
        superHeroLbl.attributedText = nil
        petLbl.attributedText = nil
        assistantLbl.text = Buddy.assistant.name
        superHeroLbl.text = Buddy.superhero.name
        petLbl.text = Buddy.pet.name
    }

    private func changeSelectedBuddyText() {

        let attributeString = NSMutableAttributedString(string: selectedBuddy.name)
        let range = NSMakeRange(0, attributeString.length)
        //attributeString.addAttribute(.underlineStyle, value: 1, range: range)
        attributeString.addAttribute(.foregroundColor, value: AppColors.themeBlueColor, range: range)

        switch selectedBuddy {
        case .assistant:
            assistantLbl.attributedText = attributeString
        case .superhero:
            superHeroLbl.attributedText = attributeString
        case .pet:
            petLbl.attributedText = attributeString
        }
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        pop()
    }

    @IBAction func submitBtnTapped(_ sender: UIButton) {
        delegate?.didChangeBuddy(to: selectedBuddy)
        let buddyValue = AppUserDefaults.value(forKey: .selectedBuddy).stringValue
        if buddyValue.isEmpty {
            AppUserDefaults.save(value: selectedBuddy.rawValue, forKey: .selectedBuddy)
            moveToHomeScreen()
        } else {
            pop()
        }
    }

    private func moveToHomeScreen() {
        let newHomeScreenScene = NewHomeScreenVC.instantiate(fromAppStoryboard: .Login)
        navigationController?.pushViewController(newHomeScreenScene, animated: true)
    }
}
