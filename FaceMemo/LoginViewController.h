//
//  LoginViewController.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@protocol LoginViewControllerDelegate;

@interface LoginViewController : GAITrackedViewController   
@property(nonatomic,weak) id delegate;

@end

@protocol LoginViewControllerDelegate <NSObject>

-(void)loginViewControllerDidLogin:(id)sender;

@end
