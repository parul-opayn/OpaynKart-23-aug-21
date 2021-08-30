//
//  ApisSuffix.swift
//  GoFitNUp
//
//  Created by Sourabh Mittal on 16/01/20.
//  Copyright © 2020 promatics. All rights reserved.
//

import Foundation

enum APISuffix {
    
    case signUp
    case login
    case updateUser
    case sliders
    case categories
    case profile
    case home
    case generalContent
    case faq
    case forgotPassword
    case resetPassword
    case changePassword
    case enquiry
    case products
    case productDetails(String)
    case wishlist
    case addToCart
    case cartDetails
    case deleteCart(String)
    case cartQuantity
    case categoryWiseProducts(String)
    case addAddress
    case searchText(String)
    case forCoordinates
    case userAddressList
    case deleteAddress(String)
    case placeOrder
    case myOrders
    case filters
    
    func getDescription() -> String {
        
        switch self {
            
        case .signUp :
            return "user/create"
            
        case .login :
            return "user/login"
            
        case .updateUser:
            return "api/v1/user/update"
            
        case .sliders:
            return "sliders"
            
        case .categories:
            return "categories"
            
        case .profile:
            return "api/v1/user/profile?id"
            
        case .home:
            return "home"
            
        case .generalContent:
            return "general-content"
            
        case .faq:
            return "faqs"
            
        case .forgotPassword:
            return "forgot-password"
            
        case .resetPassword:
            return "password-reset"
            
        case .changePassword:
            return "api/v1/user/change-password"
            
        case .enquiry:
            return "api/v1/enquiry"
            
        case .products:
            return "products"
            
        case .productDetails(let id):
            if UserDefaults.standard.value(forKey: "token") != nil{
                return "api/v1/product-detail/\(id)"
            }
            else{
                return "product-detail/\(id)"
            }
            
            
        case .wishlist:
            return "api/v1/wishlist"
            
        case .addToCart:
            return "api/v1/add-cart"
            
        case .cartDetails:
            return "api/v1/cart-listing"
            
            
        case .deleteCart(let value):
            return "api/v1/cart-item/\(value)"
            
        case .cartQuantity:
            return "api/v1/cart-quantity"
            
        case .categoryWiseProducts(let productId):
            return "category/\(productId)"
            
        case .addAddress:
            return "api/v1/user/address"
            
        case .searchText(let text):
            return "AIzaSyA31rDpXXvW9AJyv31PNnBkNTNxnrM-nXo&input=\(text)"
            
        case .forCoordinates:
            return "&key=AIzaSyA31rDpXXvW9AJyv31PNnBkNTNxnrM-nXo"
            
        case .userAddressList:
            return "api/v1/user/address-list"
            
        case .deleteAddress(let id):
            return "api/v1/user/delete-address/\(id)"
            
        case .placeOrder:
            return "api/v1/place-order"
            
        case .myOrders:
            return "api/v1/orders"
            
        case .filters:
            return "filters"
        }
       
    }
}


enum URLS {
    case baseUrl
    case googlePlaces
    case reversePlaceId(String)
    
    
    func getDescription() -> String {
        
        switch self {
            
        case .baseUrl :
            return "http://1d4a-180-188-237-46.ngrok.io/"
            
        case .googlePlaces:
            return "https://maps.googleapis.com/maps/api/place/autocomplete/json?key="
            
        case .reversePlaceId(let placeId):
            return "https://maps.googleapis.com/maps/api/place/details/json?input=bar&placeid=\(placeId)"
        }
    }
}


//"
