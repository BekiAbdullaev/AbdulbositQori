//
//  AppDelegate.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/2/23.
//

import UIKit
import Firebase
import UserNotifications
import BackgroundTasks
import MyLibrary

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var applicationCoordinator: ApplicationCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.startWithApplication()
        FirebaseApp.configure()
        self.requestNotificationPermission()
        self.setupNotificationCategories()
        self.registerBackgroundTasks()
        
        // Network mavjudligini tekshirish va mos ravishda harakat qilish
        checkNetworkAndSetupNotifications()
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func startWithApplication() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let appCordinator = ApplicationCoordinator(window: window)
        self.window = window
        self.applicationCoordinator = appCordinator
        appCordinator.start()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupNotificationCategories() {
        PrayerNotificationManager.shared.setupNotificationCategories()
    }
    
    private func setupInitialPrayerNotifications() {
        let dataManager = DataManager.shared
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        
        let todayString = dateFormatter.string(from: Date())
        let todayInfos = dataManager.fetchNamazDayInfo(day: todayString)
        
        if let todayInfo = todayInfos.first {
            PrayerNotificationManager.shared.schedulePrayerNotifications(prayerInfo: todayInfo, for: Date())
        } else {
            fetchPrayerDataWithRetry()
        }
        
        var missingDates: [String] = []
        var availableDates: [String] = []
        
        for i in 1...7 {
            let futureDate = Calendar.current.date(byAdding: .day, value: i, to: Date()) ?? Date()
            let futureDateString = dateFormatter.string(from: futureDate)
            let futureInfos = dataManager.fetchNamazDayInfo(day: futureDateString)
            
            if let futureInfo = futureInfos.first {
                PrayerNotificationManager.shared.schedulePrayerNotifications(prayerInfo: futureInfo, for: futureDate)
                availableDates.append(futureDateString)
            } else {
                print("Missing prayer data for \(futureDateString)")
                missingDates.append(futureDateString)
            }
        }
        
        // Natijalarni log qilish
        if !availableDates.isEmpty {
            print("Prayer data available for \(availableDates.count) days: \(availableDates.joined(separator: ", "))")
        }
        
        if !missingDates.isEmpty {
            print("Prayer data missing for \(missingDates.count) days: \(missingDates.joined(separator: ", "))")
            print("These dates will need to be fetched from network")
        } else {
            print("All prayer data is available locally!")
        }
    }
    
    private func registerBackgroundTasks() {
        // Register modern background tasks for iOS 13+
        if #available(iOS 13.0, *) {
            BackgroundTaskManager.shared.setupPrayerTimeManagement()
        } else {
            // Use legacy background task handling for iOS 12
            LegacyBackgroundTaskManager.shared.registerForBackgroundRefresh()
            LegacyBackgroundTaskManager.shared.setupDayChangeNotification()
        }
    }
    
    private func checkNetworkAndSetupNotifications() {
        // Test the actual server connectivity instead of just Google
        print("🔍 Checking network and server connectivity...")
        
        // Avval local ma'lumotlar mavjudligini tekshirish
        checkLocalPrayerData()
        
        testServerConnectivity()
        
        // Always setup notifications with existing local data
        // This ensures the app works even if server is down
        setupInitialPrayerNotifications()
    }
    
    private func checkLocalPrayerData() {
        let dataManager = DataManager.shared
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        // Umumiy ma'lumotlar sonini tekshirish
        let allPrayerData = dataManager.fetchAllNamazInfoCD()
        print("📊 Total prayer records in database: \(allPrayerData.count)")
        
        if allPrayerData.isEmpty {
            print("🗄️ Database is empty - no prayer data available")
            return
        }
        
        // Bugun va keyingi 7 kun uchun mavjud ma'lumotlarni tekshirish
        print("📅 Checking data availability for next 8 days:")
        
        for i in 0...7 {
            let checkDate = Calendar.current.date(byAdding: .day, value: i, to: Date()) ?? Date()
            let checkDateString = dateFormatter.string(from: checkDate)
            let dayInfos = dataManager.fetchNamazDayInfo(day: checkDateString)
            
            let dayLabel = i == 0 ? "Today" : "+\(i) day"
            let status = dayInfos.isEmpty ? "❌ Missing" : "✅ Available"
            
            if let firstInfo = dayInfos.first {
                print("   \(dayLabel) (\(checkDateString)): \(status)")
                print("     Bomdod: \(firstInfo.bomdodTime ?? "N/A"), Peshin: \(firstInfo.peshinTime ?? "N/A")")
            } else {
                print("   \(dayLabel) (\(checkDateString)): \(status)")
            }
        }
        
        // Eski ma'lumotlarni tekshirish
        let calendar = Calendar.current
        let today = Date()
        var oldRecordsCount = 0
        
        for record in allPrayerData {
            if let dayString = record.day,
               let recordDate = dateFormatter.date(from: dayString) {
                if recordDate < calendar.startOfDay(for: today) {
                    oldRecordsCount += 1
                }
            }
        }
        
        if oldRecordsCount > 0 {
            print("🗑️ Found \(oldRecordsCount) old prayer records (before today)")
        }
    }
    
    // MARK: - Application Lifecycle
    func applicationDidBecomeActive(_ application: UIApplication) {
        // App foreground'ga kelganda yangi kun bo'lsa notification'larni update qilish
        checkAndUpdatePrayerNotifications()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if #available(iOS 13.0, *) {
            BackgroundTaskManager.shared.scheduleBackgroundRefresh()
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func checkAndUpdatePrayerNotifications() {
        // Oxirgi update qilingan sanani tekshirish va agar yangi kun bo'lsa update qilish
        let userDefaults = UserDefaults.standard
        let lastUpdateKey = "lastNotificationUpdate"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let today = dateFormatter.string(from: Date())
        
        if userDefaults.string(forKey: lastUpdateKey) != today {
            setupInitialPrayerNotifications()
            userDefaults.set(today, forKey: lastUpdateKey)
        }
    }
    
    // MARK: - Network Retry Logic
    private func fetchPrayerDataWithRetry(retryCount: Int = 0, maxRetries: Int = 3) {
        // Network ishlamasa, bir necha marta urinib ko'ring
        guard retryCount < maxRetries else {
            print("Maximum retry attempts reached. Using offline fallback.")
            handleOfflineMode()
            return
        }
        
        print("Attempting to fetch prayer data (attempt \(retryCount + 1)/\(maxRetries + 1))...")
        
        // 2 soniya kutib, qayta urinish
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(retryCount * 2)) {
            // Bu yerda siz o'zingizning network request kodingizni qo'yishingiz kerak
            // Masalan: NetworkManager.shared.fetchPrayerTimes { result in ... }
            print("Network request would be made here...")
            
            // Agar network muvaffaqiyatsiz bo'lsa, qayta urinish
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.fetchPrayerDataWithRetry(retryCount: retryCount + 1, maxRetries: maxRetries)
            }
        }
    }
    
    private func handleOfflineMode() {
        // Offline rejim uchun fallback strategiya
        print("App is running in offline mode. Using cached data or default times.")
        
        // User'ni xabardor qilish uchun notification ko'rsatish
        let alert = UIAlertController(
            title: "Internet aloqasi yo'q",
            message: "Ma'lumotlar yangilanmadi. Internet aloqasini tekshiring.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        DispatchQueue.main.async {
            if let topViewController = self.getTopViewController() {
                topViewController.present(alert, animated: true)
            }
        }
    }
    
    private func getTopViewController() -> UIViewController? {
        guard let window = window else { return nil }
        var topViewController = window.rootViewController
        
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        
        if let navigationController = topViewController as? UINavigationController {
            topViewController = navigationController.visibleViewController
        }
        
        if let tabBarController = topViewController as? UITabBarController {
            topViewController = tabBarController.selectedViewController
        }
        
        return topViewController
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap
        let identifier = response.notification.request.identifier
        
        if identifier.contains("prayer_") {
            // User tapped on prayer notification - navigate to prayer times
            if let window = window,
               let nav = window.rootViewController as? UINavigationController {
                // Navigate to prayer times view controller if not already there
                // This depends on your navigation structure
            }
        }
        
        completionHandler()
    }
}

// MARK: - Network Debugging Extension
extension AppDelegate {
    
    // MARK: - Public Debug Methods
    /// Database holatini tekshirish uchun debug metod
    public func debugDatabaseState() {
        print("\n=== DATABASE DEBUG INFO ===")
        checkLocalPrayerData()
        print("===========================\n")
    }
    
    /// Ma'lum bir kun uchun ma'lumot bor yoki yo'qligini tekshirish
    public func checkDataForDate(_ dateString: String) {
        let dataManager = DataManager.shared
        let dayInfos = dataManager.fetchNamazDayInfo(day: dateString)
        
        if let info = dayInfos.first {
            print("✅ Data found for \(dateString):")
            print("   Bomdod: \(info.bomdodTime ?? "N/A")")
            print("   Quyosh: \(info.quyoshTime ?? "N/A")")
            print("   Peshin: \(info.peshinTime ?? "N/A")")
            print("   Asr: \(info.asrTime ?? "N/A")")
            print("   Shom: \(info.shomTime ?? "N/A")")
            print("   Xufton: \(info.xuftonTime ?? "N/A")")
        } else {
            print("❌ No data found for \(dateString)")
        }
    }
    
    func testServerConnectivity() {
        let serverURL = "http://194.135.85.227:9090/api/namazes/time/period"
        print("Testing server connectivity to: \(serverURL)")
        
        guard let url = URL(string: serverURL) else {
            print("❌ Invalid server URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Server connection failed:")
                    print("   Error: \(error.localizedDescription)")
                    if let urlError = error as? URLError {
                        print("   Error Code: \(urlError.code.rawValue)")
                        print("   Error Type: \(self.getErrorDescription(for: urlError.code))")
                    }
                    
                    // Faqat haqiqiy network muammosi bo'lsa alert ko'rsatish
                    // Server muammosi bo'lsa, foydalanuvchini bezovta qilmaslik
                    if let urlError = error as? URLError,
                       urlError.code == .notConnectedToInternet ||
                       urlError.code == .networkConnectionLost {
                        self.showNetworkErrorAlert()
                    } else {
                        print("ℹ️ Server issue detected, but user has internet connection")
                    }
                    
                } else if let response = response as? HTTPURLResponse {
                    print("✅ Server responded with status: \(response.statusCode)")
                    if response.statusCode == 200 {
                        print("✅ Server is reachable and working!")
                    } else {
                        print("⚠️ Server returned non-200 status code")
                    }
                }
            }
        }
        
        task.resume()
    }
    
    private func getErrorDescription(for errorCode: URLError.Code) -> String {
        switch errorCode {
        case .notConnectedToInternet:
            return "Internet connection yo'q"
        case .timedOut:
            return "Server javob bermadi (timeout)"
        case .cannotConnectToHost:
            return "Serverga ulanib bo'lmadi"
        case .networkConnectionLost:
            return "Internet aloqasi uzildi"
        case .dnsLookupFailed:
            return "DNS lookup failed (server topilmadi)"
        default:
            return "Network error: \(errorCode.rawValue)"
        }
    }
    
    private func showNetworkErrorAlert() {
        let alert = UIAlertController(
            title: "Internet aloqasi yo'q",
            message: "Internet aloqangizni tekshiring. App local ma'lumotlar bilan ishlaydi.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Qayta urining", style: .default) { _ in
            self.testServerConnectivity()
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        DispatchQueue.main.async {
            if let topViewController = self.getTopViewController() {
                topViewController.present(alert, animated: true)
            }
        }
    }
}

