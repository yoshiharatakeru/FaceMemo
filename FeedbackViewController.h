//
//  FeedbackViewController.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMFeedback.h"
#import "MBProgressHUD.h"
#import "GAITrackedViewController.h"


@interface FeedbackViewController : GAITrackedViewController
@property(nonatomic,strong) FMFeedback *feedback;
@property(nonatomic,strong) NSOperationQueue *queue;
@property(nonatomic,strong) MBProgressHUD *HUD;

@end
