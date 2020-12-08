# Usergeek iOS SDK

## Setup

### Podfile

```ruby
use_frameworks!
pod 'Usergeek-iOS', :git => "git@github.com:usergeek/Usergeek-iOS.git"
```

### Manually

Copy content of the `Usergeek-iOS/Sources` folder into your project

## Usage

### Objective-C

```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UsergeekInitConfig *initConfig = [[UsergeekInitConfig alloc] init];
    initConfig.enableStartAppEvent = YES;
    initConfig.enableSessionTracking = YES;
    initConfig.devicePropertyConfig = [[[UsergeekDevicePropertyConfig new] trackBrand] trackAppVersion];
    [Usergeek initializeWithApiKey:@"<API_KEY>" initConfig:initConfig];
    return YES;
}

//later in the code...
[Usergeek logUserProperties:[[UsergeekUserProperties instance] set:@"foo" forKey:@"bar"]];
[Usergeek setUserId:@"123123-341231"];
[Usergeek logEvent:@"StartConversation" eventProperties:[[[UsergeekEventProperties instance] set:@"private" forKey:@"type"] set:@"foo" forKey:@"bar"]];
[Usergeek logEvent:@"EndConversation"];
[Usergeek flush];
```

### Swift

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let initConfig = UsergeekInitConfig()
    initConfig.enableStartAppEvent = true
    initConfig.enableSessionTracking = true
    initConfig.devicePropertyConfig = UsergeekDevicePropertyConfig().trackBrand().trackAppVersion()
    Usergeek.initialize(withApiKey: "<API_KEY>", initConfig: initConfig)
    return true
}

//later in the code...
Usergeek.logUserProperties(UsergeekUserProperties.instance().set("bar", forKey: "foo"))
Usergeek.setUserId("123123-341231")
Usergeek.logEvent("StartConversation", eventProperties: UsergeekEventProperties.instance().set("private", forKey: "type").set("foo", forKey: "bar"))
Usergeek.logEvent("EndConversation")
Usergeek.flush()
```

## License

`Usergeek-iOS` is distributed under the terms and conditions of the [MIT license](https://github.com/usergeek/Usergeek-iOS/blob/master/LICENSE).
