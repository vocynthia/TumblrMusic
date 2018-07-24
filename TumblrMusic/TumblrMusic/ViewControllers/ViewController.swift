//
//  ViewController.swift
//  TumblrMusic
//
//  Created by Macbook on 7/24/18.
//  Copyright © 2018 makeschool. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //IBOUTLETS
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//IBACTIONS
    @IBAction func usernameTextFieldUsed(_ sender: Any) {
    
    }
    
    @IBAction func tagTextFieldUsed(_ sender: Any) {
        
    }

    @IBAction func enterButtonPressed(_ sender: UIButton) {
      print("lmao")
    }
}

