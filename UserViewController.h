//
//  UserViewController.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/18.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCommentManager.h"
#import "FMUser.h"
#import "FMCommentNetworkOperation.h"
#import "FMConnector.h"
#import "FMComment.h"
#import "FMControllerManager.h"
#import "GAITrackedViewController.h"


@interface UserViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) FMCommentManager *commentManager;
@property (nonatomic, strong) FMUser *user;
@property (nonatomic,strong) MBProgressHUD *HUD;


@end
