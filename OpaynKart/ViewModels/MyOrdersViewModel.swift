//
//  MyOrdersViewModel.swift
//  OpaynKart
//
//  Created by OPAYN on 30/08/21.
//

import Foundation

class MyOrdersViewModel: BaseAPI {
    
    //MARK:- Variables
    
    var myorders = MyOrderDataModel()
    
    //MARK:- API Calls
    
    func myOrders(completion:@escaping(Bool,String)->()){
       
        let request = Request(url: (URLS.baseUrl, APISuffix.myOrders), method: .get, parameters: nil, headers: true)
        
        super.hitApi(requests: request) { receivedData, message, responseCode in
            
            if responseCode == 1{
                if let data = receivedData as? [String:Any]{
                    if data["code"] as? Int ?? -91 == 200{
                        if let productsData = data["data"] as? [[String:Any]]{
                            do{
                                let json = try JSONSerialization.data(withJSONObject: productsData, options: .prettyPrinted)
                                self.myorders = try JSONDecoder().decode(MyOrderDataModel.self, from: json)
                                completion(true,message ?? "")
                            }
                            catch{
                                
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
}
