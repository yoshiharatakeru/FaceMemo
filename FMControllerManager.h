//
//  FMControllerManager.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/18.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserViewController.h"
#import "FriendsViewController.h"

@interface FMControllerManager : NSObject

@property (nonatomic,strong) id  userViewController;
@property (nonatomic,strong) FriendsViewController *friendViewController;

+ (FMControllerManager*)sharedManager;

@end
