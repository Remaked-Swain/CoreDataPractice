//
//  ConsoleLogHelper.swift
//  CoreData_Starter
//
//  Created by Swain Yun on 12/26/23.
//

import Foundation

protocol LoggerProtocol {
    func log(_ with: Any)
}

final class ConsoleLogger: LoggerProtocol {
    static let `default` = ConsoleLogger()
    
    private init() {} // singleton
    
    func log(_ with: Any) {
         print(with)
    }
}
