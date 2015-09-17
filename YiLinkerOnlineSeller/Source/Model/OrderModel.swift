//
//  OrderModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/8/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class OrderModel: NSObject {
   
    var order_id: String = ""
    var buyer_id: String = ""
    var date_added: String = ""
    var invoice_number: String = ""
    var payment_type: String = ""
    var payment_method_id: String = ""
    var order_status: String = ""
    var order_status_id: String = ""
    var total_price: String = ""
    var total_unit_price: String = ""
    var total_item_price: String = ""
    var total_handling_fee: String = ""
    var total_quantity: String = ""
    var product_names: String = ""
    var product_count: String = ""
    
    init(order_id: String, buyer_id: String, date_added: String, invoice_number: String, payment_type: String, payment_method_id: String, order_status: String, order_status_id: String, total_price: String, total_unit_price: String, total_item_price: String, total_handling_fee: String, total_quantity: String, product_names: String, product_count: String) {
        self.order_id = order_id
        self.buyer_id = buyer_id
        self.date_added = date_added
        self.invoice_number = invoice_number
        self.payment_type = payment_type
        self.payment_method_id = payment_method_id
        self.order_status = order_status
        self.order_status_id = order_status_id
        self.total_price = total_price
        self.total_unit_price = total_unit_price
        self.total_item_price = total_item_price
        self.total_handling_fee = total_handling_fee
        self.total_quantity = total_quantity
        self.product_names = product_names
        self.product_count = product_count
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> OrderModel {
        
        var order_id: String = ""
        var buyer_id: String = ""
        var date_added: String = ""
        var invoice_number: String = ""
        var payment_type: String = ""
        var payment_method_id: String = ""
        var order_status: String = ""
        var order_status_id: String = ""
        var total_price: String = ""
        var total_unit_price: String = ""
        var total_item_price: String = ""
        var total_handling_fee: String = ""
        var total_quantity: String = ""
        var product_names: String = ""
        let product_count: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["order_id"] != nil {
                if let tempVar = dictionary["order_id"] as? String {
                    order_id = tempVar
                }
            }
            
            if dictionary["buyer_id"] != nil {
                if let tempVar = dictionary["buyer_id"] as? String {
                    buyer_id = tempVar
                }
            }
            
            if dictionary["date_added"] != nil {
                if let tempVar = dictionary["date_added"] as? String {
                    date_added = tempVar
                }
            }
            
            if dictionary["invoice_number"] != nil {
                if let tempVar = dictionary["invoice_number"] as? String {
                    invoice_number = tempVar
                }
            }
            
            if dictionary["payment_type"] != nil {
                if let tempVar = dictionary["payment_type"] as? String {
                    payment_type = tempVar
                }
            }
            
            if dictionary["payment_method_id"] != nil {
                if let tempVar = dictionary["payment_method_id"] as? String {
                    payment_method_id = tempVar
                }
            }
            
            if dictionary["order_status"] != nil {
                if let tempVar = dictionary["order_status"] as? String {
                    order_status = tempVar
                }
            }
            
            if dictionary["order_status_id"] != nil {
                if let tempVar = dictionary["order_status_id"] as? String {
                    order_status_id = tempVar
                }
            }
            
            if dictionary["total_price"] != nil {
                if let tempVar = dictionary["total_price"] as? String {
                    total_price = tempVar
                }
            }
            
            if dictionary["total_unit_price"] != nil {
                if let tempVar = dictionary["total_unit_price"] as? String {
                    total_unit_price = tempVar
                }
            }
            
            if dictionary["total_item_price"] != nil {
                if let tempVar = dictionary["total_item_price"] as? String {
                    total_item_price = tempVar
                }
            }
            
            if dictionary["total_handling_fee"] != nil {
                if let tempVar = dictionary["total_handling_fee"] as? String {
                    total_handling_fee = tempVar
                }
            }
            
            if dictionary["total_quantity"] != nil {
                if let tempVar = dictionary["total_quantity"] as? String {
                    total_quantity = tempVar
                }
            }
            
            if dictionary["product_names"] != nil {
                if let tempVar = dictionary["product_names"] as? String {
                    product_names = tempVar
                }
            }
            
            if dictionary["product_count"] != nil {
                if let tempVar = dictionary["product_count"] as? String {
                    invoice_number = tempVar
                }
            }
        }
        
        return OrderModel(order_id: order_id, buyer_id: buyer_id, date_added: date_added, invoice_number: invoice_number, payment_type: payment_type, payment_method_id: payment_method_id, order_status: order_status, order_status_id: order_status_id, total_price: total_price, total_unit_price: total_unit_price, total_item_price: total_item_price, total_handling_fee: total_handling_fee, total_quantity: total_quantity, product_names: product_names, product_count: product_count)
    }
    
}
