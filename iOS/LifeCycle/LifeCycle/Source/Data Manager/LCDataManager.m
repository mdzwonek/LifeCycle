//
//  LCDataManager.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCDataManager.h"
#import "LCUser.h"
#import "LCBike.h"
#import "NSString+JSON.h"
#import "AFNetworking.h"


static NSString *const UserIdKey = @"userId-1";
static NSString *const UserFullNameKey = @"userFullName";
static NSString *const ProfileImageURLKey = @"profileImageURL";

static NSString * const HTTP_METHOD_POST  = @"POST";
static NSString * const HTTP_CONTENT_TYPE = @"Content-Type";
static NSString * const HTTP_CONTENT_JSON = @"application/json";


@interface LCDataManager ()

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *userFullName;
@property (nonatomic) NSString *profileImageURL;
@property (nonatomic) NSArray *bikes;

- (instancetype)initPrivate;

@end


@implementation LCDataManager

+ (instancetype)sharedManager {
    static LCDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LCDataManager alloc] initPrivate];
    });
    return instance;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _userId = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
        _userFullName = [[NSUserDefaults standardUserDefaults] stringForKey:UserFullNameKey];
        _profileImageURL = [[NSUserDefaults standardUserDefaults] stringForKey:ProfileImageURLKey];
        
        // Mock data
        LCUser *user = [[LCUser alloc] initWithUserName:@"Mateusz Dzwonek" profileImageURL:@"https://graph.facebook.com/mateusz.dzwonek/picture"];
        _bikes = @[ [[LCBike alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:51.511 longitude:-0.056] owner:user],
                    [[LCBike alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:51.505 longitude:-0.057] owner:user],
                    [[LCBike alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:51.508 longitude:-0.067] owner:user] ];
    }
    return self;
}

- (BOOL)userIsLoggedIn {
    return _userId != nil && _userFullName != nil;
}

- (void)loginWithUsername:(NSString *)username fullName:(NSString *)fullName profileImageURL:(NSString *)profileImageURL completion:(void (^)())completion {
    [self sendRequest:@"add_user" withData:@{ @"name": fullName, @"login": username, @"photourl": profileImageURL } andCompletion:^(NSError *error, NSArray *response) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:response[0][@"id"] forKey:UserIdKey];
        [userDefaults setObject:fullName forKey:UserFullNameKey];
        [userDefaults setObject:profileImageURL forKey:ProfileImageURLKey];
        [userDefaults synchronize];
        completion();
    }];
}

- (void)sendRequest:(NSString *)path withData:(NSDictionary *)data andCompletion:(void (^)(NSError *error, NSArray *response))completion {
    NSURLRequest *urlRequest = [self prepareRequest:path withData:data];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Request finished successfully: %@", responseObject);
        completion(nil, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error when making a request: %@", error);
        completion(error, nil);
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

- (NSURLRequest *)prepareRequest:(NSString *)path withData:(NSDictionary *)data {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://10.205.252.18:3000/%@", path]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.timeoutInterval = 30;
    
    if (data != nil && data.allKeys.count > 0) {
        [urlRequest setValue:HTTP_CONTENT_JSON forHTTPHeaderField:HTTP_CONTENT_TYPE];
        NSString *jsonString = [NSString dictionaryToJSON:data];
        NSData *requestData = [NSData dataWithBytes:jsonString.UTF8String length:jsonString.length];
        urlRequest.HTTPBody = requestData;
    }
    
    urlRequest.HTTPMethod = HTTP_METHOD_POST;
    
    return urlRequest;
}

@end
