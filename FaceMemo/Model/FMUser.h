//
//  FMUser.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/08.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMUser : NSObject
@property (nonatomic,strong) NSString *id_facebook;
@property (nonatomic,strong) NSString *first_name;
@property (nonatomic,strong) NSString *middle_name;
@property (nonatomic,strong) NSString *last_name;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *location;
//@property (nonatomic,strong) NSString *link;
//@property (nonatomic,strong) NSString *birthday;

+ (FMUser*)sharedInstance;
-(void)updateUserData;
@end
