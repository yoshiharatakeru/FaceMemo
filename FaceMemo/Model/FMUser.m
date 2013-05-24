//
//  FMUser.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/08.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMUser.h"
#import "FMClient.h"

static FMUser *_sharedUser = nil;

@implementation FMUser

+ (FMUser*)sharedInstance{
    if (!_sharedUser) {
        _sharedUser = [[FMUser alloc]init];
    }
    return _sharedUser;
}


+ (id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (_sharedUser == nil) {
            _sharedUser = [super allocWithZone:zone];
            return _sharedUser;
        }
    }
    return nil;
}



- (id)copyWithZone:(NSZone*)zone{
    return self;
}



-(void)updateUserData{
    NSString *baseUrl = @"http://testapp0421.herokuapp.com/";
    FMClient *client = [[FMClient alloc]initWithBaseUrl:baseUrl];
    [client authorize];
}
@end
