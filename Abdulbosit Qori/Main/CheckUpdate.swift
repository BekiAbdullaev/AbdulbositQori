//
//  CheckUpdate.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/2/23.
//

import Foundation
import UIKit

enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

class LookupResult: Decodable {
    var results: [AppInfo]
}

class AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
}

class CheckUpdate: NSObject {

    static let shared = CheckUpdate()
    
    
    func showUpdate(withConfirmation: Bool) {
        DispatchQueue.global().async {
            self.checkVersion(force : !withConfirmation)
        }
    }
  

    private func checkVersion(force: Bool) {
        guard let currentVersion = self.getBundle(key: "CFBundleShortVersionString") else {
            return
        }
        
        _ = getAppInfo { (info, error) in
            guard let appStoreAppVersion = info?.version else { return }
            
            if let error = error {
                print("Error getting app store version: ", error)
            } else if appStoreAppVersion <= currentVersion {
                print("Already on the last app version: ", currentVersion)
            } else {
                print("Needs update: AppStore Version: \(appStoreAppVersion) > Current version: ", currentVersion)
                DispatchQueue.main.async {
                    guard let topController = self.getTopViewController() else { return }
                    guard let version = info?.version, let appURL = info?.trackViewUrl else { return }
                    topController.showAppUpdateAlert(Version: version, Force: force, AppURL: appURL)
                }
            }
        }
    }

    private func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
    
        guard let identifier = self.getBundle(key: "CFBundleIdentifier"),
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                DispatchQueue.main.async {
                    completion(nil, VersionError.invalidBundleInfo)
                }
                return nil
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
          
            
                do {
                    if let error = error { throw error }
                    guard let data = data else { throw VersionError.invalidResponse }
                    
                    let result = try JSONDecoder().decode(LookupResult.self, from: data)
                    guard let info = result.results.first else {
                        throw VersionError.invalidResponse
                    }

                    completion(info, nil)
                } catch {
                    completion(nil, error)
                }
            }
        
        task.resume()
        return task

    }

    func getBundle(key: String) -> String? {
        return Bundle.main.infoDictionary?[key] as? String
    }
    
    private func getTopViewController() -> UIViewController? {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first,
                  let rootVC = windowScene.windows.first?.rootViewController else {
                return nil
            }
            var topController = rootVC
            while let presentedVC = topController.presentedViewController {
                topController = presentedVC
            }
            return topController
        } else {
            return UIApplication.shared.keyWindow?.rootViewController
        }
    }
}

extension UIViewController {
    @objc fileprivate func showAppUpdateAlert( Version : String, Force: Bool, AppURL: String) {
        let alertTitle = "Yangi versiya!"
        let alertMessage = "Ilovada yangi versiya mavjud. Versiyani yangilashni xoxlaysizmi?"

        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        if !Force {
            let notNowButton = UIAlertAction(title: "Keyinroq", style: .default)
            alertController.addAction(notNowButton)
        }

        let updateButton = UIAlertAction(title: "Yangilash", style: .default) { (action:UIAlertAction) in
            guard let url = URL(string: AppURL) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
}

