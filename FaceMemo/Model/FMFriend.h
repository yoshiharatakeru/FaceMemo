//
//  FMFriend.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/29.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMFriend : NSObject
@property (nonatomic,strong) NSString *first_name;
@property (nonatomic,strong) NSString *identifier;
@property (nonatomic,strong) NSString *last_name;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *username;

- (id)initWithName:(NSString*)name first_name:(NSString*)first_name identifier:(NSString*)identifier last_name:(NSString*)last_name username:(NSString*)username;
- (NSComparisonResult) compareName:(FMFriend*)friend;

@end
