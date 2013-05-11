//
//  FMFriend.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/29.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMFriend.h"

@implementation FMFriend

- (id)initWithName:(NSString *)name first_name:(NSString *)first_name id:(NSString *)id last_name:(NSString *)last_name username:(NSString *)username{
    self = [super init];
    if(self){
        _name = name;
        _first_name = first_name;
        _id = id;
        _last_name = last_name;
        _username = username;
     }
    return self;
    
}

@end
