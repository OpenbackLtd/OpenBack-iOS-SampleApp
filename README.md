# OpenBack iOS Sample App

This application is a simple project highlighting the integration of the OpenBack library into an iOS application. It shows how to set custom trigger values using the OpenBack SDK. It also comes with a ready made OpenBack app code, which has already been setup with some simple campaigns reacting to the trigger values.

> For the full iOS integration guide, check out the [OpenBack Documentation](https://docs.openback.com/ios/integration/).

## How the sample app was setup

A one view iOS application was created. The project capabilities were updated as listed in the integration guide.

Cocoapods Podfile was added using `pod init` and edited to add `pod OpenBack` as well as enabling the dynamic framework feature.

The [App Delegate](/SampleApp/AppDelegate.m) was tweaked to setup OpenBack in the `didFinishLaunchingWithOptions` call.

Check the [View Controller](/SampleApp/ViewController.m) to see how the custom triggers are called. For example:

```objective-c
[OpenBack setValue:@"Bob" forCustomTrigger:kOBKCustomTrigger1 error:&error];
``` 
