//
//  FMUser.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/08.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMUser.h"
#import "FMClient.h"

@implementation FMUser

-(id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

-(void)updateUserData{
    NSString *baseUrl = @"http://testapp0421.herokuapp.com/";
    FMClient *client = [[FMClient alloc]initWithBaseUrl:baseUrl];
    [client authorize];
}
@end
