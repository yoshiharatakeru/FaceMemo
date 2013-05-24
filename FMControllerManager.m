//
//  FMControllerManager.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/18.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMControllerManager.h"

static FMControllerManager *_sharedManager = nil;

@implementation FMControllerManager

+ (FMControllerManager*)sharedManager{
    if (_sharedManager == nil) {
        _sharedManager = FMControllerManager.new;
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



@end
