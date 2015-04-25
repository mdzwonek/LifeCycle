//
//  LCLoginViewController.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 25/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Social/Social.h>
#import "LCLoginViewController.h"
#import "LCDataManager.h"


@interface LCLoginViewController ()

@property (nonatomic) IBOutlet UIView *playerContainerView;
@property (nonatomic) IBOutlet UIView *gradientView;

@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic) MPMoviePlayerController *playerController;

@end


@implementation LCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithWhite:0.9f alpha:1.0f] CGColor], nil];
    [_gradientView.layer insertSublayer:gradient atIndex:0];

    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
    self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPath]];
    [_playerController prepareToPlay];
    _playerController.view.frame = _playerContainerView.bounds;
    _playerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_playerContainerView addSubview:_playerController.view];
    _playerController.scalingMode = MPMovieScalingModeAspectFill;
    _playerController.controlStyle = MPMovieControlStyleNone;
    _playerController.repeatMode = MPMovieRepeatModeOne;
    [_playerController play];
}

- (IBAction)didTapLoginButton:(id)sender {
    [self loginWithFacebook];
}

- (void)loginWithFacebook {
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSString *appKey = @"825511244194883";
    NSDictionary *options = @{ ACFacebookAppIdKey: appKey, ACFacebookPermissionsKey: @[@"email"] };
    
    [_accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
         if (granted) {
             NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
             ACAccount *account = [accounts lastObject];
             
             NSString *userFullName = account.userFullName;
             NSString *username = account.username;
             NSString *profileImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", username];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                [self finishLoginWithUsername:username userFullName:userFullName profileImageURL:profileImageURL];
             });
         }
     }];
}

- (void)finishLoginWithUsername:(NSString *)username userFullName:(NSString *)userFullName profileImageURL:(NSString *)profileImageURL {
    NSLog(@"Logging in as %@ %@ %@", userFullName, username, profileImageURL);
    [[LCDataManager sharedManager] loginWithUsername:username fullName:userFullName profileImageURL:profileImageURL completion:^{
        [self performSegueWithIdentifier:@"login-bike-map-segue" sender:nil];
    }];
}

@end
