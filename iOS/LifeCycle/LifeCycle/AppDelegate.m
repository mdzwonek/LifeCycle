//
//  AppDelegate.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import <HealthKit/HealthKit.h>
#import "AppDelegate.h"
#import "PayPalMobile.h"
#import "LCDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"Afp2yAdLXxHG6EYv1TDHaH9jsA7X-L2y3k5tblbXFvFM0evlPcxssqpVj8XJUaCJxbQDjcN7MG_J4wT-",
                                                           PayPalEnvironmentSandbox : @"Afp2yAdLXxHG6EYv1TDHaH9jsA7X-L2y3k5tblbXFvFM0evlPcxssqpVj8XJUaCJxbQDjcN7MG_J4wT-"}];
    
    
    application.idleTimerDisabled = YES;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[LCDataManager sharedManager] updateToken:[self hexToken:deviceToken]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (NSString *)hexToken:(NSData *)token {
    const unsigned *tokenBytes = [token bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x", ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]), ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    return hexToken;
}

- (void)authorizeHealthKitWithCompletion:(void (^)(BOOL success, NSError *error))completion {
//    NSArray *healthKitTypesToWrite = @[ HKQuantityTypeIdentifierDistanceCycling ];
//    if (![HKHealthStore isHealthDataAvailable]) {
//        
//    }
}

//func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
//{
//    // 1. Set the types you want to read from HK Store
//    let healthKitTypesToRead = Set(arrayLiteral:[
//                                                 HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth),
//                                                 HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType),
//                                                 HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex),
//                                                 HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass),
//                                                 HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight),
//                                                 HKObjectType.workoutType()
//                                                 ])
//    
//    // 2. Set the types you want to write to HK Store
//    let healthKitTypesToWrite = Set(arrayLiteral:[
//                                                  HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex),
//                                                  HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned),
//                                                  HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning),
//                                                  HKQuantityType.workoutType()
//                                                  ])
//    
//    // 3. If the store is not available (for instance, iPad) return an error and don't go on.
//    if !HKHealthStore.isHealthDataAvailable()
//    {
//        let error = NSError(domain: "com.raywenderlich.tutorials.healthkit", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
//        if( completion != nil )
//        {
//            completion(success:false, error:error)
//        }
//        return;
//    }
//    
//    // 4.  Request HealthKit authorization
//    healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead) { (success, error) -> Void in
//        
//        if( completion != nil )
//        {
//            completion(success:success,error:error)
//        }
//    }
//}

@end
