
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let screenSize = UIScreen.mainScreen().bounds.size
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        
        let vc = ViewController()
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }

}

