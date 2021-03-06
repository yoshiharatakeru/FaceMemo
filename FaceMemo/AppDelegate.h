//
//  AppDelegate.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

extern NSString *const SCSessionStateChangedNotification;
@property (strong, nonatomic) UIWindow *window;

+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message;
@end
