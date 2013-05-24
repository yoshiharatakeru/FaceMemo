//
//  FMFriendManager.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/29.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMFriend.h"

@interface FMFriendManager : NSObject
@property (nonatomic,strong) NSMutableArray *friends;
@property (nonatomic,strong) NSArray *allFriends;

+(FMFriendManager*)sharedManager;
-(void)initFriends;
-(void)addFriend:(FMFriend*)friend;

@end
