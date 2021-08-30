//
//  WishlistViewmodel.swift
//  OpaynKart
//
//  Created by OPAYN on 26/08/21.
//

import Foundation

class WishlistViewmodel: BaseAPI {
    
    //MARK:- Variables
    
    var wishlistModel = WishlistModel()
    
    //MARK:- API Calls
    
    func wishlist(userId:String,completion:@escaping(Bool,String)->()){
        
        let param = ["user_id":userId] as baseParameters
        let request = Request(url: (URLS.baseUrl, APISuffix.wishlist), method: .get, parameters: param, headers: true)
        super.hitApi(requests: request) { receivedData, message, responseCode in
            if responseCode == 1{
                if let data = receivedData as? [String:Any]{
                    if data["code"] as? Int ?? -91 == 200{
                        if let homeData = data["data"] as? [[String:Any]]{
                            do{
                                let json = try JSONSerialization.data(withJSONObject: homeData, options: .prettyPrinted)
                                self.wishlistModel = try JSONDecoder().decode(WishlistModel.self, from: json)
                                completion(true,message ?? "")
                            }
                            catch{
                                print(error)
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
                    
                }
            }
            else{
                completion(false,message ?? "")
            }
        }
    }
    
    
    func wishlistItem(user_id:String,product_id:String,status:String,completion:@escaping(Bool,String)->()){
        
        let param = ["user_id":user_id,"product_id":product_id] as baseParameters
        let request = Request(url: (URLS.baseUrl, APISuffix.wishlist), method: .post, parameters: param, headers: true)
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
