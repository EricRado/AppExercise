//
//  DownloadingDataView.swift
//  AxxessCodingChallenge
//
//  Created by Eric Rado on 1/12/19.
//

import UIKit
import SVProgressHUD


class DownloadInProgressView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        showLoadingIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoadingIndicator() {
        SVProgressHUD.show(withStatus: "Retrieving data")
    }
    
    func hideLoadingIndicator() {
        SVProgressHUD.dismiss()
    }
}
