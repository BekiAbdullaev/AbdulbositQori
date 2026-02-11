import Foundation
import MBProgressHUD
import Moya

public struct NetworkManager{
  public enum Config {
        case noHudAuthorized
        case noHud
        case defaultConfig
        case authorized
    }
    // MARK: - Properties
    // MARK: - Change build configuration before release
    // Product->Scheme->Edit Scheme->Build Configuration = Release
    #if DEBUG
    var plugins = [NetworkPlugins.Logger.plugin]
    #else
    var plugins = [PluginType]()
    #endif
    var provider: MoyaProvider<MultiTarget>?
    public init(_ type:Config) {
        switch type {
        case .noHudAuthorized:
            provider = MoyaProvider<MultiTarget>(plugins:plugins)
        case .noHud:
            provider = MoyaProvider<MultiTarget>(plugins:plugins)
        case .defaultConfig:
           // plugins.append(NetworkPlugins.Hud.plugin)
            provider = MoyaProvider<MultiTarget>(plugins:plugins)
        case .authorized:
           // plugins.append(NetworkPlugins.Hud.plugin)
            provider = MoyaProvider<MultiTarget>(plugins:plugins)
        }
    }
    
    // MARK: Generic method for sendinig any targetype
    public func request<T: TargetType>(_ target: T, response: @escaping (Result<Response, MoyaError>) -> Void) {
        provider!.request(MultiTarget(target), completion: response)
    }
}

enum NetworkPlugins:PluginType{
    case Logger 
    //case Hud

    var plugin:PluginType{
        switch self {
        case .Logger:
            return NetworkLoggerPlugin(
                configuration: .init(
                    formatter: .init(),
                    output: NetworkLoggerPlugin.Configuration.defaultOutput(target:items:),
                    logOptions: .verbose))
//        case .Hud:
//            return RequestLoadingPlugin()
        }
    }
    
}

