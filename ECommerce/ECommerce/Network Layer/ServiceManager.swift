//
//  ServiceManager.swift
//  EditableProfile
//
//  Created by Apple on 30/05/19.
//  Copyright © 2019 PraveenKumar. All rights reserved.
//

import UIKit
import Foundation

typealias SuccessCallBack = (_ response : AnyObject) -> Void
typealias FailuerCallBack = (_ responseError : AnyObject) -> Void
typealias ApiAuthTokenFailuerCallBack = (_ responseError : AnyObject) -> Void // Used only for Auth token errors

enum apiMethodType: String {
    case Post = "POST"
    case Get = "GET"
    case Put = "PUT"
    case Delete = "DELETE"
}

final class ServiceManager: NSObject {
    
    private(set) lazy var responseData : NSMutableData = {
        return NSMutableData()
    }()
    
    static let sharedInstance: ServiceManager = {
        return ServiceManager()
    }()
    
    private override init() {
        super.init()
    }
    
    func isConnectedToNetwork( sender: AnyObject? = nil)-> Bool
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isNetworkReachable{
            return true
        }
        else{
            let rootVc = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController
            if let root = rootVc, nil != sender{
                Alerts.sharedInstance.showAlertWithSingleButton("Alert", message: "Please check your network connection!", sender: root)
            }
            return false
        }
    }
    
    
    @inline(never)
    internal func callAPI( method : apiMethodType , url : URL, dictData : Dictionary<String,AnyObject> = [:], sender: AnyObject,successCallBack : @escaping SuccessCallBack, failureCallBack : @escaping FailuerCallBack ,authTokenFailure:@escaping ApiAuthTokenFailuerCallBack)-> URLSessionTask?{
        debugPrint(dictData)
        if  self.isConnectedToNetwork(sender: sender) {
            
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
            request.allHTTPHeaderFields = ServiceURLMapper.getHTTPHeaderFields()
            
            request.httpMethod = method.rawValue
            if dictData.count > 0{
                do{
                    let postData:Data = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                    request.httpBody = postData
                }
                catch let error as NSError{
                    failureCallBack(error.localizedDescription as AnyObject)
                    return nil
                }
            }
            let configutaion:URLSessionConfiguration =  URLSessionConfiguration.default
            configutaion.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            configutaion.urlCache = nil
            let session : URLSession = URLSession(configuration: configutaion, delegate: self, delegateQueue: nil)
            return self.createRequest(session: session, request: request, successCallBack: successCallBack, failureCallBack: failureCallBack,authTokenFailure: authTokenFailure)
            
        }
        else{
            failureCallBack([:] as AnyObject)
        }
        return nil
    }
    
    @inline(never)
    private func createRequest(session : URLSession,request : NSMutableURLRequest, successCallBack : @escaping SuccessCallBack, failureCallBack : @escaping FailuerCallBack,authTokenFailure:@escaping ApiAuthTokenFailuerCallBack)-> URLSessionTask{
        
        let sessionTask : URLSessionTask = session.dataTask(with: request as URLRequest, completionHandler:
        {(data, response, error) in
            //debugPrint(response as AnyObject)
            self.validateResponse(httpStatus: response as? HTTPURLResponse, data: data, error: error as NSError?, success: successCallBack, failure: failureCallBack,authFailure: authTokenFailure)
        })
        sessionTask.resume()
        return sessionTask
        
    }
    
    @inline(never)
    private func validateResponse (httpStatus : HTTPURLResponse?, data: Data?, error : NSError? ,success : SuccessCallBack , failure : FailuerCallBack,authFailure:@escaping ApiAuthTokenFailuerCallBack ){
        
        if  nil  != error
        {
            failure( ["json_error":error!.localizedDescription,"statusCode": error!.code] as AnyObject)
            return
        }
        switch httpStatus!.statusCode {
            
        case 204 :
            failure(["json_error":"error","statusCode": httpStatus!.statusCode] as AnyObject)
            
        case 422,401,403,302, 500:
            let tempDict:[String:AnyObject] = self.parseJsonData(data: data! as Data)
            if let val = tempDict["json error"] {
                failure(["json_error":val,"statusCode": httpStatus!.statusCode] as AnyObject)
                return
            }
            if let sucessVal = tempDict["success"]{
                if false == sucessVal as! Bool{
                    if let errorInfo = tempDict["error_info"]{
                        failure(["error_info":errorInfo,"statusCode": httpStatus!.statusCode] as AnyObject)
                        return
                    }
                    if let tempStr = tempDict["message"]{
                        failure(["json_error":tempStr,"statusCode": httpStatus!.statusCode] as AnyObject)
                        return
                    }
                }
            }
            if let message = tempDict["message"]{
                failure(["json_error":message,"statusCode": httpStatus!.statusCode] as AnyObject)
                return
            }
            if let message = tempDict["Message"]{
                failure(["json_error":message,"statusCode": httpStatus!.statusCode] as AnyObject)
                return
            }
            failure(["json_error":"error","statusCode": httpStatus!.statusCode] as AnyObject)
            return
        case 200:
            if String.init(data: data!, encoding: .utf8) == nil {
                success(data as AnyObject)
            }else{
                let tempDict:[String:AnyObject] = self.parseJsonData(data: data! as Data)
                if let val = tempDict["json error"] {
                    failure(["json_error":val,"statusCode": httpStatus!.statusCode] as AnyObject)
                    return
                }
                success(tempDict as AnyObject)
            }
        default:
            failure(["json_error":"An error occured. Please try again later","statusCode": httpStatus!.statusCode] as AnyObject)
        }
        
    }
    
    @inline(__always)
    func parseJsonData(data:Data) -> [String:AnyObject] {
        do {
            let responseDictionary = try JSONSerialization.jsonObject(with: data , options: JSONSerialization.ReadingOptions())
            if responseDictionary is Array<Any> {
                let tempArray:[AnyObject] = responseDictionary as! Array
                let tempDict:[String:AnyObject] = ["responseKey" : tempArray as AnyObject]
                return tempDict
            }
            else if responseDictionary is Dictionary<String, Any> {
                let tempDict:[String:AnyObject] = responseDictionary as! Dictionary
                return tempDict
            }
            else {
                return [:]
            }
        }
        catch let error as NSError {
            return ["json_error":(error.localizedDescription as AnyObject)]
        }
    }
}

//MARK:- URLSession Delegates
extension ServiceManager:URLSessionDataDelegate, URLSessionDelegate, URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        _ = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        responseData.append(data as Data)
    }
    
    private func urlSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveResponse response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
        
        completionHandler(.allow)
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if  nil == error {
            debugPrint("No Error. Successful response")
        } else {
            debugPrint(error?.localizedDescription ?? " ")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential,URLCredential.init(trust: challenge.protectionSpace.serverTrust!))
        
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential,URLCredential.init(trust: challenge.protectionSpace.serverTrust!))
    }
    
}

