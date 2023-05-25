//
//  KhaosViewController.swift
//  NextLua
//
//  Created by Furkan Yıldırım on 5.04.2023.
//

import UIKit
import Alamofire
import SystemConfiguration
import CoreTelephony
import Foundation

class KhaosViewController: UIViewController {

    @IBOutlet var bugTitleTextField: UITextField!
    @IBOutlet var bugDescriptionTextField: UITextField!
    @IBOutlet var bugDescriptionTextView: UITextView!
    @IBOutlet var screenShotSwitch: UISwitch!
    @IBOutlet var screenShowImageView: UIImageView!
    
    var device = KhaosDeviceInfo.shared
    
    var currentPage: String?
    var screenshot: UIImage?
    var lastVisitedPages: [String]?
    var lastRequests: [KhaosRequestModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastVisitedPages = NXKhaos.shared.viewControllers.suffix(4).dropLast()
        lastRequests = NXKhaos.shared.requests.suffix(3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bugDescriptionTextView.setCornerRadius(8)
    }
    
    func request(urlString: String) {
        let khaosModel = KhaosModel(systemName: device.systemName,
                          systemVersion: device.iOSVersion,
                          deviceName: device.deviceModel,
                          deviceModel: device.devicetype,
                          deviceId: device.deviceUUID,
                          deviceLanguage: device.lang,
                          buildVersion: device.buildVersion,
                          appVersion: device.appVersion,
                          appVersionBuild: device.appVersionLong,
                          appName: device.appName,
                          appId: device.appID,
                          appNameId: device.appNameID,
                          enviorment: device.enviroment,
                          appLanguage: device.appLanguage,
                          connectionType: getConnectionType(),
                          ip: getIPAddress() ?? "",
                          baseApiUrl: "",
                          lastApiRequests: lastRequests,
                          currentPage: currentPage,
                          lastVisitedPages: lastVisitedPages,
                          screenShotURL: urlString,
                          bugTitle: bugTitleTextField.text,
                          bugDescription: bugDescriptionTextView.text)
        
        KhaosAPI.shared.requestService(of: .addBug(parameters: khaosModel), responseType: KhaosBaseResponse.self) { (response: KhaosBaseResponse?, error) in
            if let response = response {
                switch response.status {
                case .success:
                    self.showSuccessAlert(title: "SUCCESS",
                                          message: "Bug uploaded",
                                          primaryButtonTitle: "Close", secondaryButtonTitle: "",
                                          primaryButtonAction: {
                        self.dismiss(animated: true)
                    })
                case .failed:
                    self.showFailedAlert(title: "FAILED UPLOAD BUG",
                                         message: response.message ?? "")
                }
            } else {
                self.showFailedAlert(title: "ERROR UPLOAD BUG",
                                     message: error ?? "")
            }
        }
    }
    
    func getIPAddress() -> String? {
        var address : String?
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }
    
    func getConnectionType() -> String {
        guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com") else {
            return "NO INTERNET"
        }

        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)

        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)

        if isReachable {
            if isWWAN {
                let networkInfo = CTTelephonyNetworkInfo()
                let carrierType = networkInfo.serviceCurrentRadioAccessTechnology

                guard let carrierTypeName = carrierType?.first?.value else {
                    return "UNKNOWN"
                }

                switch carrierTypeName {
                case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
                    return "2G"
                case CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA, CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyeHRPD:
                    return "3G"
                case CTRadioAccessTechnologyLTE:
                    return "4G"
                default:
                    return "5G"
                }
            } else {
                return "WIFI"
            }
        } else {
            return "NO INTERNET"
        }
    }
    
    func uploadScreenshot() {
        guard let image = screenshot else { return }
        let imgData = image.jpegData(compressionQuality: 1.0)!
        
        let data: MultipartFormData = MultipartFormData()
        data.append(imgData, withName: "File", fileName: "screenshot.jpg", mimeType: "image/jpg")
        
        KhaosAPI.shared.uploadRequest(of: .uploadImage, responseType: KhaosUploadImageResponse.self, data: data) { (response: KhaosUploadImageResponse?, error) in
            if let response = response {
                switch response.status {
                case .success:
                    self.showSuccessAlert(title: "SUCCESS",
                                          message: "Image uploaded",
                                          primaryButtonTitle: "Send Bug",
                                          secondaryButtonTitle: "Cancel",
                                          primaryButtonAction: {
                        self.request(urlString: response.data ?? "")
                    })
                case .failed:
                    self.showFailedAlert(title: "FAILED UPLOAD IMAGE",
                                         message: response.message ?? "")
                }
            } else {
                self.showFailedAlert(title: "ERROR UPLOAD IMAGE",
                                     message: error ?? "")
            }
        }
    }
    
    func showSuccessAlert(title: String,
                   message: String,
                   primaryButtonTitle: String,
                   secondaryButtonTitle: String?,
                   primaryButtonAction: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: primaryButtonTitle, style: .default, handler: { action in
            if let buttonAction = primaryButtonAction {
                buttonAction()
            }
        }))
        
        if secondaryButtonTitle != "" {
            alert.addAction(UIAlertAction(title: secondaryButtonTitle, style: .destructive, handler: { action in
                alert.dismiss(animated: true)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showFailedAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
            alert.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func switchAction(_ sender: Any) {
        screenShowImageView.isHidden = !screenShotSwitch.isOn
    }
    
    @IBAction func submitBug(_ sender: Any) {
        uploadScreenshot()
    }
}
