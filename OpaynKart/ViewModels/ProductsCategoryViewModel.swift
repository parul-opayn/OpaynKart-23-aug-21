//
//  ProductsCategoryViewModel.swift
//  OpaynKart
//
//  Created by OPAYN on 23/08/21.
//

import Foundation

class ProductsCategoryViewModel: BaseAPI {
    
    //MARK:- Variables
    
    var home : Home?
    var categoriesModel = Categories()
    var productsModel = ProductsDataModel()
    
    //MARK:-API Integrations
    
    func homeAPI(completion:@escaping(Bool,String)->()){
        
        let request = Request(url: (URLS.baseUrl, APISuffix.home), method: .get, parameters: nil, headers: true)
        super.hitApi(requests: request) { receivedData, message, responseCode in
            if responseCode == 1{
                if let data = receivedData as? [String:Any]{
                    if data["code"] as? Int ?? -91 == 200{
                        if let homeData = data["data"] as? [String:Any]{
                            do{
                                let json = try JSONSerialization.data(withJSONObject: homeData, options: .prettyPrinted)
                                self.home = try JSONDecoder().decode(Home.self, from: json)
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
    
    func categoriesAPI(completion:@escaping(Bool,String)->()){
        
        let request = Request(url: (URLS.baseUrl, APISuffix.categories), method: .get, parameters: nil, headers: true)
        super.hitApi(requests: request) { receivedData, message, responseCode in
            if responseCode == 1{
                if let data = receivedData as? [String:Any]{
                    if data["code"] as? Int ?? -91 == 200{
                        if let sliderData = data["data"] as? [[String:Any]]{
                            do{
                                let json = try JSONSerialization.data(withJSONObject: sliderData, options: .prettyPrinted)
                                self.categoriesModel = try JSONDecoder().decode(Categories.self, from: json)
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
    
    func productsAPI(type:String,completion:@escaping(Bool,String)->()){
        
        let param = ["type":type] as baseParameters
        let request = Request(url: (URLS.baseUrl, APISuffix.products), method: .get, parameters: param, headers: true)
        super.hitApi(requests: request) { receivedData, message, responseCode in
            if responseCode == 1{
                if let data = receivedData as? [String:Any]{
                    if data["code"] as? Int ?? -91 == 200{
                        if let homeData = data["data"] as? [[String:Any]]{
                            do{
                                let json = try JSONSerialization.data(withJSONObject: homeData, options: .prettyPrinted)
                                self.productsModel = try JSONDecoder().decode(ProductsDataModel.self, from: json)
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
        
        let param = ["user_id":user_id,"product_id":product_id,"status":status] as baseParameters
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

    func categoryWiseProducts(categoryId:String,completion:@escaping(Bool,String)->()){
        
        let request = Request(url: (URLS.baseUrl, APISuffix.categoryWiseProducts(categoryId)), method: .get, parameters: nil, headers: true)
        super.hitApi(requests: request) { receivedData, message, responseCode in
            if responseCode == 1{
                if let data = receivedData as? [String:Any]{
                    if data["code"] as? Int ?? -91 == 200{
                        self.productsModel = []
                        if let homeData = (data["data"] as? [String:Any])?["products"] as? [[String:Any]]{
                            do{
                                let json = try JSONSerialization.data(withJSONObject: homeData, options: .prettyPrinted)
                                self.productsModel = try JSONDecoder().decode(ProductsDataModel.self, from: json)
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
    
}
