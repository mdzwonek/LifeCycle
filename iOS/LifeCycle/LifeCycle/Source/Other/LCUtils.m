//
//  LCUtils.m
//  LifeCycle
//
//  Created by Mateusz Dzwonek on 26/04/2015.
//  Copyright (c) 2015 Mateusz Dzwonek. All rights reserved.
//

#import "LCUtils.h"
#import "CustomIOS7AlertView.h"


@implementation LCUtils

+ (CustomIOS7AlertView *)showProgressAlertView {
    UIView *progressAlertViewContent = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 290.0f, 110.0f)];
    progressAlertViewContent.backgroundColor = [UIColor clearColor];
    
    UILabel *pleaseWaitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 25.0f, 250.0f, 30.0f)];
    pleaseWaitLabel.text = NSLocalizedString(@"Please wait...", @"Please wait...");
    pleaseWaitLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    pleaseWaitLabel.textAlignment = NSTextAlignmentCenter;
    [progressAlertViewContent addSubview:pleaseWaitLabel];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(135.0f, 65.0f, 20.0f, 20.0f)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activityIndicator startAnimating];
    [progressAlertViewContent addSubview:activityIndicator];
    
    CustomIOS7AlertView *progressAlertView = [[CustomIOS7AlertView alloc] init];
    progressAlertView.useMotionEffects = YES;
    progressAlertView.buttonTitles = nil;
    progressAlertView.containerView = progressAlertViewContent;
    [progressAlertView show];
    return progressAlertView;
}

@end
