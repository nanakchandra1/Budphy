//
//  GifPreviewVC.swift
//  Budfie
//
//  Created by appinventiv on 20/03/18.
//  Copyright © 2018 Budfie. All rights reserved.
//

import FLAnimatedImage

class GifPreviewVC: BaseVc {
    
    var gifName = String()
    var gifURL = String()
    
    @IBOutlet weak var gifTitleLabel   : UILabel!
    @IBOutlet weak var gifImageView    : FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gifImageView.roundCornerWith(radius: 5)
        gifImageView.dropShadow(width: 5, shadow: AppColors.calenderShadow)
        gifImageView.clipsToBounds = true
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension GifPreviewVC {
    
    private func initialSetup() {
        
        if !gifURL.isEmpty {
            gifImageView.setImage(withSDWeb: gifURL,
                                  placeholderImage: AppImages.myprofilePlaceholder)

        }
        if !gifName.isEmpty {
            gifTitleLabel.text = gifName
        }
    }
    
}
