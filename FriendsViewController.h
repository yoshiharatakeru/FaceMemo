//
//  FriendsViewController.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMUser.h"
#import "FMFriendManager.h"
#import "GAITrackedViewController.h"


@interface FriendsViewController : GAITrackedViewController
@property(nonatomic,strong) FMUser *user;
@property(nonatomic,strong) FMFriendManager *friendManager;
@property (weak, nonatomic) IBOutlet UIButton *menu_bt;
@property(nonatomic,strong) NSOperationQueue *queue;
@end
