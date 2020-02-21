#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    FlutterEventChannel* chargingChannel = [FlutterEventChannel eventChannelWithName:@"time.flutter.io/count" binaryMessenger:controller];
    [chargingChannel setStreamHandler:self];
    ///hit.flutter.io/count 必须与flutter 请求的key一样才会调用到函数中
    FlutterMethodChannel* batteryChannel = [FlutterMethodChannel methodChannelWithName:@"hit.flutter.io/count" binaryMessenger:controller];
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        ///这个是flutter 请求的事件
        if ([@"hitCount" isEqualToString:call.method]) {
            static int count =0;
            return result(@(++count));
        }
        
        
    }];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (FlutterError*)onListenWithArguments:(id)arguments
                             eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    static int mm = 0;
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (!_eventSink) return;
        _eventSink(@(++mm));
    }];
    return nil;
}


- (FlutterError*)onCancelWithArguments:(id)arguments {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _eventSink = nil;
    return nil;
}

@end
