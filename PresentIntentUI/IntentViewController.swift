//
//  IntentViewController.swift
//  PresentIntentUI
//
//  Created by Prateek Sharma on 7/4/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import IntentsUI


class IntentViewController: UIViewController, INUIHostedViewControlling {
    
//    @IBOutlet weak var but: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
        
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        
        completion(true, parameters, self.desiredSize)
    }
    
    var desiredSize: CGSize {
        return CGSize(width: self.extensionContext!.hostedViewMaximumAllowedSize.width, height: 100)
    }
    
    @IBAction func act() {
        
    }
    
}
