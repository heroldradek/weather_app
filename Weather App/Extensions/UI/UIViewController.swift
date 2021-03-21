//
//  UIViewController.swift
//  Weather App
//
//  Created by Radek Herold on 21.03.2021.
//

import UIKit

extension UIViewController {
    public func modal(controller: UIViewController, animated: Bool) {
        present(controller, animated: animated, completion: nil)
    }
    
    public func push(controller: UIViewController, animated: Bool) {
        navigationController?.pushViewController(controller, animated: animated)
    }
}
