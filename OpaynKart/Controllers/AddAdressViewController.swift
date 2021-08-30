//
//  AddAdressViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit
import CoreLocation
import DropDown

class AddAdressViewController: UIViewController,UIGestureRecognizerDelegate{
    
    //MARK:- IBOutelets
    
    @IBOutlet weak var useLocaionBtn: SetButton!
    @IBOutlet weak var addBtn: SetButton!
    @IBOutlet weak var pincodeTxtFld: UITextField!
    @IBOutlet weak var stateTxtFld: UITextField!
    @IBOutlet weak var houseNumberTxtFld: UITextField!
    @IBOutlet weak var areaColonyTxtFld: UITextField!
    @IBOutlet weak var fullNameTxtFld: UITextField!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var officeImage: UIImageView!
    
    //MARK:- Variables
    
    var locationManager = CLLocationManager()
    var currentLat = 0.0
    var currentLong = 0.0
    var viewModel = AddAddressViewModel()
    var type = 1
    var dropdown = DropDown()
    var forIndex = -1
    var addressFor:displayAddressFor = .addAddress
   
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationWithBack(navtTitle: "Add Address")
        useLocaionBtn.changeFontSize()
        useLocaionBtn.changeFontSize()
        useLocaionBtn.changeButtonLayout()
        addBtn.changeFontSize()
        addBtn.changeFontSize()
        addBtn.changeButtonLayout()
        addActionsToImage()
        //askUserPermission()
        areaColonyTxtFld.delegate = self
        if addressFor == .editAddress{
            displayDataForEdit()
        }
    }
    
    //MARK:- Custom Methods
    
    func addActionsToImage(){
        homeImage.isUserInteractionEnabled = true
        officeImage.isUserInteractionEnabled = true
        let homeTap = UITapGestureRecognizer()
        homeTap.delegate = self
        homeTap.addTarget(self, action: #selector(didTapHome))
        homeImage.addGestureRecognizer(homeTap)
        
        let officeTap = UITapGestureRecognizer()
        officeTap.delegate = self
        officeTap.addTarget(self, action: #selector(didTapOffice))
        officeImage.addGestureRecognizer(officeTap)
    }
    
    func askUserPermission(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            if #available(iOS 14.0, *) {
                
                switch locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    print("No access.Ask user to enale location")
                    self.showAlertWithActionOkandCancel(Title: "Opayn Kart", Message: "Please go to Settings and turn on the permissions", OkButtonTitle: "Ok", CancelButtonTitle: "Cancel") {
                        if let _ = Bundle.main.bundleIdentifier,
                           let url = URL(string: "\(UIApplication.openSettingsURLString)") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                @unknown default:
                    break
                }
                
            }
            else {
                if CLLocationManager.locationServicesEnabled() {
                    
                    switch CLLocationManager.authorizationStatus() {
                    case .notDetermined, .restricted, .denied:
                        print("No access")
                        if let bundleId = Bundle.main.bundleIdentifier,
                           let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    case .authorizedAlways, .authorizedWhenInUse:
                        print("Access")
                        locationManager.delegate = self
                        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                        locationManager.startUpdatingLocation()
                    @unknown default:
                        break
                    }
                }
                else {
                    print("Location services are not enabled")
                }
            }
        }
        else{
            self.showAlertWithActionOkandCancel(Title: "Opayn Kart", Message: "Please go to Settings and turn on the Location services", OkButtonTitle: "Ok", CancelButtonTitle: "Cancel") {
                if let bundleId = Bundle.main.bundleIdentifier,
                   let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func locateWithCoordinates(){
        self.getAddress(lat: currentLat, long: currentLong, completion: {
            [weak self]  reverseGeocode in
            guard let self = self else{return}
            self.pincodeTxtFld.text = reverseGeocode?.zip ?? ""
            self.stateTxtFld.text = reverseGeocode?.state ?? ""
            //self.cityTxtFld.text = reverseGeocode?.locatlity ?? ""
            self.houseNumberTxtFld.text = reverseGeocode?.subLocality ?? ""
            self.toggleUserInterations()
        })
    }
    
    func toggleUserInterations(){
        if self.pincodeTxtFld.text ?? "" == ""{
            self.pincodeTxtFld.isUserInteractionEnabled = true
        }
        else if self.stateTxtFld.text ?? "" == ""{
            self.stateTxtFld.isUserInteractionEnabled = true
        }
        else if self.houseNumberTxtFld.text ?? "" == ""{
            self.houseNumberTxtFld.isUserInteractionEnabled = true
        }
        else if self.areaColonyTxtFld.text ?? "" == ""{
            self.areaColonyTxtFld.isUserInteractionEnabled = true
        }
        
    }
    
    
    func displayDataForEdit(){
        let model = viewModel.addressModel[forIndex]
        self.fullNameTxtFld.text = model.fullName ?? ""
        self.phoneNumberTxtFld.text = model.phoneNumber ?? ""
        self.areaColonyTxtFld.text = model.area ?? ""
        self.pincodeTxtFld.text = model.pincode ?? ""
        self.stateTxtFld.text = model.state ?? ""
        self.houseNumberTxtFld.text = model.houseNo ?? ""
        
        if model.type ?? "" == "1"{
            officeImage.image = #imageLiteral(resourceName: "emptyCircle")
            homeImage.image = #imageLiteral(resourceName: "filledCircle")
        }
        else{
            homeImage.image = #imageLiteral(resourceName: "emptyCircle")
            officeImage.image = #imageLiteral(resourceName: "filledCircle")
        }
        self.addBtn.setTitle("Update Address", for: .normal)
    }
    
    //MARK:- Objc Methods
    
    @objc func didTapHome(){
        officeImage.image = #imageLiteral(resourceName: "emptyCircle")
        homeImage.image = #imageLiteral(resourceName: "filledCircle")
        self.type = 1
    }
    
    @objc func didTapOffice(){
        homeImage.image = #imageLiteral(resourceName: "emptyCircle")
        officeImage.image = #imageLiteral(resourceName: "filledCircle")
        self.type = 2
    }
    
    //MARK:- IBActions
    
    @IBAction func tappedCurrentLocationBtn(_ sender: UIButton) {
       
    }
    
    @IBAction func addAddressBtn(_ sender: UIButton) {
        let validation = viewModel.validation(full_name: fullNameTxtFld.text ?? "", phone_number: phoneNumberTxtFld.text ?? "", pincode: pincodeTxtFld.text ?? "", state: stateTxtFld.text ?? "", house_no: houseNumberTxtFld.text ?? "", area: areaColonyTxtFld.text ?? "")
        
        if validation.0{
            if self.addressFor == .editAddress{
                self.addAddress(id: viewModel.addressModel[forIndex].id)
            }
            else{
                self.addAddress(id: nil)
            }
        }
        else{
            self.showToast(message: validation.1)
        }
    }
    
    @IBAction func areaColonyValueChanged(_ sender: UITextField) {
        viewModel.placesAPI(text: sender.text?.replacingOccurrences(of: " ", with: "") ?? "") {[weak self] isSuccess, message in
            guard let self = self else{return}
            if isSuccess{
                let dataSource = self.viewModel.placesData.map({$0.placesDataModelDescription ?? ""})
                self.dropdown.dataSource = dataSource
                self.dropdown.anchorView = sender
                self.dropdown.bottomOffset = CGPoint(x: 0, y: sender.frame.height + 8)
                self.dropdown.width = sender.frame.width
                self.dropdown.show()
                self.dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                  print("Selected item: \(item) at index: \(index)")
                    self.areaColonyTxtFld.text = self.viewModel.placesData[index].structuredFormatting?.mainText ?? item
                    self.reverseThePlaceId(placeId:self.viewModel.placesData[index].placeID ?? "")
                }
            }
            else{
                self.dropdown.dataSource = []
            }
        }
    }
    
}

//MARK:- CLLocationManager Delegates

extension AddAdressViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.currentLat = locValue.latitude
        self.currentLong = locValue.longitude
        
    }
}


//MARK:- UITextField Delegates

extension AddAdressViewController:UITextFieldDelegate{

    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == self.areaColonyTxtFld{

        }
    }

}

//MARK:- API Calls

extension AddAdressViewController{
    
    func addAddress(id:String?){
        Indicator.shared.showProgressView(self.view)
        viewModel.addNewAddress(full_name: fullNameTxtFld.text ?? "", phone_number: phoneNumberTxtFld.text ?? "", pincode: pincodeTxtFld.text ?? "", state: stateTxtFld.text ?? "", house_no: houseNumberTxtFld.text ?? "", area: areaColonyTxtFld.text ?? "", type: "\(self.type)",lat: "\(self.currentLat)",long: "\(self.currentLong)",id: id) {[weak self]isSuccess, message in
            Indicator.shared.hideProgressView()
            guard let self = self else{return}
            if isSuccess{
                self.showToast(message: "Address added successfully")
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.showToast(message: message)
            }
        }
    }
    
    
    func reverseThePlaceId(placeId:String){
        viewModel.convertPlaceIdToCoordinates(placeId: placeId) {[weak self] isSuccess in
            guard let self = self else{return}
            if isSuccess{
                self.currentLat = self.viewModel.reversePlaceIdModel?.geometry?.location?.lat ?? 0.0
                self.currentLong = self.viewModel.reversePlaceIdModel?.geometry?.location?.lng ?? 0.0
                self.locateWithCoordinates()
            }
            else{
                print("Unable to get coordinates")
                self.showToast(message: "The location is invalid.")
                self.areaColonyTxtFld.text = ""
            }
        }
    }
    
}
