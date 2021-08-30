//
//  AddAddressViewModel.swift
//  OpaynKart
//
//  Created by OPAYN on 27/08/21.
//

import Foundation

class AddAddressViewModel: BaseAPI {
    
    //MARK:- Variables
    
    var placesData = PlacesDataModel()
    var reversePlaceIdModel : PlacesCoordinatesModel?
    var addressModel = AddressListModel()
    
    //MARK:- API Calls
    
    func addNewAddress(full_name:String,phone_number:String,pincode:String,state:String,house_no:String,area:String,type:String,lat:String,long:String,id:String?,completion:@escaping(Bool,String)->()){
        
        var param = ["full_name":full_name,"phone_number":phone_number,"pincode":pincode,"state":state,"house_no":house_no,"area":area,"type":type,"lat":lat,"lng":long] as baseParameters
        
        if let addressId = id{
            param["id"] = addressId as AnyObject
        }
        
        let request = Request(url: (URLS.baseUrl, APISuffix.addAddress), method: .post, parameters: param, headers: true)
        
        super.hitApi(requests: request) { receivedData, message, responseCode in
            
            if responseCode == 1{
                if let data = receivedData as? [String:Any]{
                    if data["code"] as? Int ?? -91 == 200{
                        completion(true,message ?? "")
                    }
                    else{
                        completion(false,message ?? "")
                    }
                }
                else{
                    completion(false,message ?? "")
                }
            }
            else{
                completion(false,message ?? "")
            }
        }
    }
    
    func validation(full_name:String,phone_number:String,pincode:String,state:String,house_no:String,area:String)->(Bool,String){
        if (full_name.replacingOccurrences(of: " ", with: "") == "") && (phone_number.replacingOccurrences(of: " ", with: "") == "") && (pincode.replacingOccurrences(of: " ", with: "") == "") && (state.replacingOccurrences(of: " ", with: "") == "") && (house_no.replacingOccurrences(of: " ", with: "") == "") && (area.replacingOccurrences(of: " ", with: "") == ""){
            return(false,"Please fill all the required fields.")
        }
        else if (full_name.replacingOccurrences(of: " ", with: "") == ""){
            return(false,"Please enter full name.")
        }
        else if (phone_number.replacingOccurrences(of: " ", with: "") == ""){
            return(false,"Please enter phone number.")
        }
        else if (pincode.replacingOccurrences(of: " ", with: "") == ""){
            return(false,"Please enter pincode.")
        }
        else if state.replacingOccurrences(of: " ", with: "") == ""{
            return(false,"Please enter your state.")
        }
        else if (house_no.replacingOccurrences(of: " ", with: "") == ""){
            return(false,"Please enter house number")
        }
        else if (area.replacingOccurrences(of: " ", with: "") == ""){
            return(false,"Please enter area.")
        }
        else{
            return(true,"You can proceed" )
        }
    }
    
    func placesAPI(text:String,completion:@escaping(Bool,String)->()){
        
        let request = Request(url: (URLS.googlePlaces, APISuffix.searchText(text)), method: .get, parameters: nil, headers: true)
        super.hitApi(requests: request) { receivedData, message, responseCode in
            if responseCode == 1{
                if let data = receivedData as? [String:Any]{
                    print(data)
                    
                    if String(describing: (receivedData as! [String:AnyObject])["status"]!) == "OK"{
                        let predictions = data["predictions"] as! [[String : AnyObject]]
                        
                        if predictions.count > 0{
                            do{
                                let json = try JSONSerialization.data(withJSONObject: predictions, options: .prettyPrinted)
                                self.placesData = try JSONDecoder().decode(PlacesDataModel.self, from: json)
                                completion(true,message ?? "")
                            }
                            catch{
                                completion(false,message ?? "")
                            }
                        }
                        else{
                            self.placesData = []
                            completion(false,message ?? "")
                        }
                    }
                    else{
                        self.placesData = []
                        completion(true,message ?? "")
                    }
                }
                else{
                    self.placesData = []
                    completion(false,message ?? "")
                }
            }
            else{
                self.placesData = []
                completion(false,message ?? "")
            }
        }
    }
    
    
    func convertPlaceIdToCoordinates(placeId:String,completion:@escaping(Bool)->()){
        let request = Request(url: (URLS.reversePlaceId(placeId), APISuffix.forCoordinates), method: .get, parameters: nil, headers: true)
        
        super.hitApi(requests: request) { receivedData, message, responseCode in
            
            if responseCode == 1{
                if let data = receivedData as? [String:Any]{
                        if String(describing: (receivedData as! [String:AnyObject])["status"]!) == "OK"{
                            let predictions = data["result"] as! [String : AnyObject]
                            
                            do{
                                let json = try JSONSerialization.data(withJSONObject: predictions, options: .prettyPrinted)
                                self.reversePlaceIdModel = try JSONDecoder().decode(PlacesCoordinatesModel.self, from: json)
                                completion(true)
                            }
                            catch{
                                completion(false)
                            }
                        }
                }
                else{
                    completion(false)
                }
            }
            else{
                completion(false)
            }
        }
    }
    
    
    
    func userAddressList(completion:@escaping(Bool,String)->()){
        let request = Request(url: (URLS.baseUrl, APISuffix.userAddressList), method: .get, parameters: nil, headers: true)
        
        super.hitApi(requests: request) { receivedData, message, responseCode in
            
            if responseCode == 1{
                
                if let data = receivedData as? [String:Any]{
                    if data["code"] as? Int ?? -91 == 200{
                        if let addresses = data["data"] as? [[String:Any]]{
                            do{
                                let json = try JSONSerialization.data(withJSONObject: addresses, options: .prettyPrinted)
                                self.addressModel = try JSONDecoder().decode(AddressListModel.self, from: json)
                                
                                completion(true,message ?? "")
                            }
                            catch{
                                completion(false,message ?? "")
                            }
                        }
                        else{
                            completion(false,message ?? "")
                        }
                        
                    }
                    else{
                        completion(false,message ?? "")
                    }
                }
                else{
                    completion(false,message ?? "")
                }
            }
            else{
                completion(false,message ?? "")
            }
        }
    }
    
    
    func deleteaAddress(addressId:String,completion:@escaping(Bool,String)->()){
        let request = Request(url: (URLS.baseUrl, APISuffix.deleteAddress(addressId)), method: .delete, parameters: nil, headers: true)
        
        super.hitApi(requests: request) { receivedData, message, responseCode in
            
            if responseCode == 1{
                if let data = receivedData as? [String:Any]{
                    if data["code"] as? Int ?? -91 == 200{
                        completion(true,message ?? "")
                    }
                    else{
                        completion(false,message ?? "")
                    }
                }
                else{
                    completion(false,message ?? "")
                }
            }
            else{
                completion(false,message ?? "")
            }
        }
    }
    
    
}
