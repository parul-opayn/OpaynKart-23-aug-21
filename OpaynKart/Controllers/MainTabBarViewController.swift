//
//  MainTabBarViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 16/08/21.
//

import UIKit

class MainTabBarViewController: UITabBarController,UITabBarControllerDelegate{
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        if (viewController == tabBarController.viewControllers?[1] || viewController == tabBarController.viewControllers?[2] || viewController == tabBarController.viewControllers?[3])
            && (UserDefaults.standard.value(forKey: "userData") == nil)
        {
            self.showAlertWithAction(Title: "Opayn Kart", Message: "Please login to continue", ButtonTitle: "OK") {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return false
        } else {
            return true
        }
    }
    
   }


class CustomTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 0.0

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            if UIDevice.current.userInterfaceIdiom == .pad{
                sizeThatFits.height = 100
            }
            
           
        }
        return sizeThatFits
    }
}
