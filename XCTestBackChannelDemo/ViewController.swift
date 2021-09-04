//
//  ViewController.swift
//  XCTestBackChannelDemo
//
//  Created by John Scott on 9/3/21.
//

import UIKit
import XCTestBackChannel

class ViewController: UIViewController {
    @IBAction func tappedButton(_ sender: UIButton) {
        XCTestBackChannel.shared.sendMessage("Hello")
    }
}
