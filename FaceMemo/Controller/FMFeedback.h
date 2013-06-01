//
//  FMFeedback.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/28.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMFeedback : NSObject

@property(nonatomic,strong) NSString *userid;
@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *modelname;
@property(nonatomic,strong) NSString *systemversion;
@property(nonatomic,strong) NSString *model;

@end
