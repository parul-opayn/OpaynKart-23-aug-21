//
//  CartViewModel3.swift
//  OpaynKart
//
//  Created by OPAYN on 26/08/21.
//

import Foundation

class CartViewModel: BaseAPI {
    
    var cartList : CarListDataModel?
    
    func cartData(completion:@escaping(Bool,String)->()){
        
        let request = Request(url: (URLS.baseUrl, APISuffix.cartDetails), method: .get, parameters: nil, headers: true)
        super.hitApi(requests: request) { receivedData, message, responseCode in
            if responseCode == 1{
                if let data = receivedData as? [String:Any]{
                    if data["code"] as? Int ?? -91 == 200{
                        do{
                            let json = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                            self.cartList = try JSONDecoder().decode(CarListDataModel.self, from: json)
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
                    
                }
            }
            else{
                completion(false,message ?? "")
            }
        }
    }
    
    
    func deleteProductFromCart(productId:String,completion:@escaping(Bool,String)->()){
        
        let request = Request(url: (URLS.baseUrl, APISuffix.deleteCart(productId)), method: .delete, parameters: nil, headers: true)
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
    
    
    func productQuantity(id:String,quantity:Int,completion:@escaping(Bool,String)->()){
        
        let param = ["id":id,"quantity":quantity] as baseParameters
        let request = Request(url: (URLS.baseUrl, APISuffix.cartQuantity), method: .post, parameters: param, headers: true)
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
    
    
    func checkOut(products:[[String:Any]],addressId:String,tax:String,shipping:String,completion:@escaping(Bool,String)->()){
        let param = ["address_id":addressId,"tax":tax,"shipping":shipping,"products":products] as baseParameters
        let request = Request(url: (URLS.baseUrl, APISuffix.placeOrder), method: .post, parameters: param, headers: true)
        super.hitApiWithJSONParams(requests: request) { receivedData, message, responseCode in
            if responseCode == 1{
                if let data = receivedData as? [String:Any]{
                    if data["code"] as? Int ?? -91 == 200{
                        NotificationCenter.default.post(name: .updateCartValue, object: nil)
                        completion(true,message ?? "")
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
    
    
}
