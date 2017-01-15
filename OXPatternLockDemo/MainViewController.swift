//
//  ViewController.swift
//  OXPatternLockDemo
//
//  Created by Dmitriy Azarov on 11/01/2017.
//  Copyright © 2017 Oxozle. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    fileprivate var savedTrackPath: [Int] = []
    fileprivate var timer: Timer?
    
    @IBOutlet var patternLock: OXPatternLock!
    @IBOutlet var labelStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patternLock.delegate = self
    }

    @IBAction func recordPatternClick(_ sender: Any) {
        savedTrackPath.removeAll()
        showStatus(message: "Ready to set new pattern")
    }
    
    fileprivate func showStatus(message: String) {
        labelStatus.text = message
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
            self.labelStatus.text = ""
        })
    }
}

extension MainViewController: OXPatternLockDelegate {
    func didPatternInput(patterLock: OXPatternLock, track: [Int]) {
        timer?.invalidate()
        if savedTrackPath.isEmpty {
            savedTrackPath = track
            showStatus(message: "Pattern saved")
        } else {
            if savedTrackPath == track {
                showStatus(message: "Correct")
            } else {
                showStatus(message: "Error")
            }
        }
    }
}

