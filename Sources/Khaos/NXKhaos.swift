//
//  Khaos.swift
//  NextLua
//
//  Created by Furkan Yıldırım on 5.04.2023.
//

import Foundation
import Alamofire
import UIKit

public class NXKhaos {
    public static let shared = NXKhaos()
    
    private let ModuleBundle: Bundle = Bundle(for: NXKhaos.self)
    
    var viewControllers: [String] = []
    var requests: [KhaosRequestModel] = []
    var isShakeActive: Bool = true
    var isScreenShotActive: Bool = true
    
    public var apiKey: String?
    
    public static func start(apikey: String, isShakeActive: Bool = true, isScreenShotActive: Bool = true) {
        UIViewController.swizzle()
        NXKhaos.shared.startLogging()
        NXKhaos.shared.apiKey = apikey
        NXKhaos.shared.isShakeActive = isShakeActive
        NXKhaos.shared.isScreenShotActive = isScreenShotActive
        NXKhaos.shared.checkKeys(apiKey: NXKhaos.shared.apiKey ?? "")
    }
    
    public static func showKhaos() {
        var screenshot: UIImage?
        if NXKhaos.shared.isScreenShotActive { screenshot = NXKhaos.shared.takeScreenshot() }
        NXKhaos.shared.presentKhaos(screenshot)
    }
    
    private func startLogging() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(requestDidFinish(notification:)),
            name: Alamofire.Request.didCompleteTaskNotification,
            object: nil
        )

        notificationCenter.addObserver(
            self,
            selector: #selector(requestDidFinish(notification:)),
            name: Alamofire.Request.didFinishNotification,
            object: nil
        )
    }
    
    private func stopLogging() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func requestDidFinish(notification: Notification) {
        DispatchQueue.main.async {
            if let dataRequest = notification.request as? DataRequest {
                var request = KhaosRequestModel()
                
                if let urlString = dataRequest.request?.url {
                    request.urlString = urlString.absoluteString
                }
                
                if let status = dataRequest.response?.statusCode {
                    request.status = status
                }
                
                if let type = dataRequest.request?.httpMethod {
                    request.type = type
                }
                
                if let requestHeader = dataRequest.request?.headers.dictionary {
                    request.requestHeader = requestHeader
                }
                
                if let responseHeader = dataRequest.response?.headers.dictionary {
                    request.responseHeader = responseHeader
                }
                
                if let requestBody = dataRequest.request?.httpBody?.dataToString() {
                    request.responseBody = requestBody
                }
                
                if let responseBody = dataRequest.data?.dataToString() {
                    request.responseBody = responseBody
                }
                
                self.requests.append(request)
            }
        }
    }
    
    private func checkKeys(apiKey: String) {
        KhaosAPI.shared.requestService(of: .checkKeys(parameters: KhaosCheckRequestModel(apiKey: apiKey, bundleId: Bundle.main.bundleId)), responseType: KhaosBaseResponse.self) { (response: KhaosBaseResponse?, error) in
            if let response = response {
                switch response.status {
                case .success:
                    print("SUCCESS START Khaos")
                case .failed:
                    print("FAILED START Khaos: \(response.message ?? "")")
                }
            } else {
                print("ERROR START Khaos: \(error ?? "")")
            }
        }
    }
    
    private func presentKhaos(_ screenshot: UIImage? = nil) {
        if let vc = UIStoryboard(name: "Khaos", bundle: NXKhaos.shared.ModuleBundle).instantiateInitialViewController() as? KhaosViewController {
            vc.currentPage = UIApplication.topViewController()?.description
            vc.screenshot = screenshot

            if let topController = UIApplication.topViewController() {
                topController.present(vc, animated: true)
            }
        }
    }
    
    fileprivate func takeScreenshot() -> UIImage? {
        var screenshotImage: UIImage?
        let layer = UIApplication.shared.windows[0].layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage
    }
}
