//
//  FMFrindManager.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/29.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMFriendManager.h"

static FMFriendManager *_sharedManager = nil;

@implementation FMFriendManager


+ (FMFriendManager*)sharedManager{
    
    if (!_sharedManager) {
        _sharedManager = [[FMFriendManager alloc]init];
        _sharedManager.friends = NSMutableArray.new;
    }
    return _sharedManager;
    
}


+ (id)allocWithZone:(NSZone *)zone{
    
    @synchronized(self){
        if (_sharedManager == nil) {
            _sharedManager = [super allocWithZone:zone];
            return _sharedManager;
        }
    }
    return nil;
}



- (id)copyWithZone:(NSZone*)zone{
    return self;
}



- (void)addFriend:(FMFriend*)friend{
    
    if (!friend) {
        return;
    }
    
    [_friends addObject:friend];
}



-(void)initFriends{
    [_friends removeAllObjects];
}

@end
