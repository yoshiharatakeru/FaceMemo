//
//  FMComment.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/30.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMComment : NSObject
@property(nonatomic,strong) NSString *comment;
@property(nonatomic,strong) NSString *to_user;
@property(nonatomic,strong) NSString *from_user;
@property(nonatomic,strong) NSString *disp_flg;
@property(nonatomic,strong) NSString *identifier;
@property(nonatomic,strong) NSString *date;


@end
