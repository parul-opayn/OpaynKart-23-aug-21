//
//  AddressViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class AddressViewController: UIViewController {

    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var addAddressBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTableView.delegate = self
        addressTableView.dataSource = self
        self.navigationWithBack(navtTitle: "My Address")
        addAddressBtn.changeFontSize()
        addAddressBtn.changeButtonLayout()
    }
    
    
    @IBAction func tappedNewAddressBtnq(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAdressViewController") as! AddAdressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- TableView Delegates

extension AddressViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.addressTableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as! AddressTableViewCell
        return cell
    }
}

