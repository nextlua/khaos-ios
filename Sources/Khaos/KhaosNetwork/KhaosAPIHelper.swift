//
//  KhaosAPIHelper.swift
//  NextLua
//
//  Created by Furkan Yıldırım on 5.04.2023.
//

import Foundation
import Alamofire

class KhaosAPI {
    static let shared = KhaosAPI()
    private init() { }
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func requestService<T: Codable>(of requestType: ResponseDataEndpoint, responseType: T.Type, fromUnAuth: Bool = false, shouldHandleError: Bool = true, completion: @escaping(T?, String?) -> Void) {
        request(request: requestType).validate(statusCode: 200..<600).responseDecodable { (response: DataResponse<T, AFError>) in
            self.handle(response: response, requestType: requestType, responseType: responseType, encodableParams: [""], fromUnAuth: fromUnAuth, shouldHandleError: shouldHandleError, completion: completion)
        }
    }
    
    func uploadRequest<T: Codable>(of requestType: ResponseDataEndpoint, responseType: T.Type, data: MultipartFormData?, fromUnAuth: Bool = false, shouldHandleError: Bool = true, completion: @escaping(T?, String?) -> Void) {
        AF.upload(multipartFormData: data ?? MultipartFormData(),
                  to: requestType.apiURL + requestType.path + requestType.endpoint,
                  method: requestType.method,
                  headers: requestType.headers).validate(statusCode: 200..<600).responseDecodable { (response: DataResponse<T, AFError>) in
            self.handle(response: response, requestType: requestType, responseType: responseType, isUploadRequest: true, encodableParams: [""], fromUnAuth: fromUnAuth, multipartData: data, shouldHandleError: shouldHandleError, completion: completion)
        }
    }
}

extension KhaosAPI {
    
    fileprivate func handle<T: Codable, K: Codable>(response: DataResponse<T, AFError>, requestType: ResponseDataEndpoint, responseType: T.Type, isEncoderRequest: Bool = false, isUploadRequest: Bool = false, encodableParams: K? = nil, fromUnAuth: Bool = false, multipartData: MultipartFormData? = nil, shouldHandleError: Bool, completion: @escaping(T?, String?) -> Void) {
        if let res = response.value {
                completion(res, nil)
        } else {
            handleErrorCase(message: response.error != nil ? "\(response.error!)" : "there_is_a_error", shouldHandleError: shouldHandleError, completion: completion)
        }
    }
    
    
    fileprivate func handleErrorCase<T: Codable>(message: String, shouldHandleError: Bool, completion: @escaping(T?, String?) -> Void) {
            completion(nil, message)
    }
}

extension KhaosAPI {
    fileprivate func request(request schema: ResponseDataEndpoint) -> DataRequest {
        return AF.request(schema.apiURL + schema.path + schema.endpoint,
                          method: schema.method,
                          parameters: schema.parameters,
                          encoding: schema.encoding,
                          headers: schema.headers)
    }
    
    fileprivate func requestEncoder<T: Codable>(request schema: ResponseDataEndpoint, params: T) -> DataRequest {
        return AF.request(schema.apiURL + schema.path + schema.endpoint,
                          method: schema.method,
                          parameters: params,
                          encoder: JSONParameterEncoder.default,
                          headers: schema.headers)
    }
    
    enum ResponseDataEndpoint {
        case addBug(parameters: KhaosModel)
        case checkKeys(parameters: KhaosCheckRequestModel)
        case uploadImage
        
        var apiURL: String {
            return KhaosAPIConstants.BaseURL
        }
        
        var path: String {
            switch self {
            default:
                return ""
            }
        }
        
        var encoding: ParameterEncoding {
            switch self {
                
            case .checkKeys, .addBug, .uploadImage:
                return JSONEncoding.default
            //case .uploadImage:
            //    return URLEncoding.default
            //case .vehicleauctionlistview:
            //    return ArrayEncoding()
            }
        }
        
        var endpoint: String {
            switch self {
            case .addBug:
                return "/Bugs/AddBug"
            case .uploadImage:
                return "/Bugs/ImageUpload"
            case .checkKeys:
                return "/Check"
            }
        }
        
        var headers: HTTPHeaders {
            var header: HTTPHeaders = HTTPHeaders()
            
            switch self {
            case .uploadImage:
                header.add(HTTPHeader(name: "Content-Type", value: "multipart/form-data"))
            case .addBug:
                header.add(HTTPHeader(name: "apikey", value: "\(Khaos.shared.apiKey ?? "")"))
            default:
                header.add(HTTPHeader(name: "Content-Type", value: "application/json"))
            }
            return header
        }

        var method: HTTPMethod {
            switch self {
            case .addBug, .uploadImage, .checkKeys:
                return .post
            }
        }
        
        var parameters: Parameters {
            switch self {
            case .addBug(let parameters):
                let params: Parameters = [
                    "bugTitle": parameters.bugTitle ?? "",
                    "bugDescription": parameters.bugDescription ?? "",
                    "systemName": parameters.systemName ?? "",
                    "systemVersion": parameters.systemVersion ?? "",
                    "deviceName": parameters.deviceName ?? "",
                    "deviceModel": parameters.deviceModel ?? "",
                    "deviceId": parameters.deviceId ?? "",
                    "deviceLanguage": parameters.deviceLanguage ?? "",
                    "buildVersion": parameters.buildVersion ?? "",
                    "appVersion": parameters.appVersion ?? "",
                    "appVersionBuild": parameters.appVersionBuild ?? "",
                    "appName": parameters.appName ?? "",
                    "bundleId": parameters.enviorment ?? "",
                    "appNameId": parameters.appNameId ?? "",
                    "appLanguage": parameters.appLanguage ?? "",
                    "connectionType": parameters.connectionType ?? "",
                    "ip": parameters.ip ?? "",
                    "baseApiUrl": parameters.baseApiUrl ?? "",
                    "currentPage": parameters.currentPage ?? "",
                    "screenShotUrl": parameters.screenShotURL ?? "",
                    "lastApiRequests": parameters.lastApiRequests?.toDictionary() ?? [],
                    "lastVisitedPages": parameters.lastVisitedPages ?? []]
                
                return params
            case .checkKeys(let parameters):
                let parameters: Parameters = [
                    "apiKey": parameters.apiKey,
                    "bundleId": parameters.bundleId
                ]
                return parameters
            default:
                let parameters: Parameters = [:]
                return parameters
            }
        }
    }
}
