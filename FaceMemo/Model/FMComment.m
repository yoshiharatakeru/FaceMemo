//
//  FMComment.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/04/30.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMComment.h"

@implementation FMComment

-(id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _comment = @"";
    _date = @"";
    _disp_flg = @"false";
    
    //識別師の作成
    /*これはバックエンドだろうな
    CFUUIDRef uuid;
    uuid = CFUUIDCreate(NULL);
    _identifier = (NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    NSLog(@"cuuuid:%@",_identifier);
     */

    return self;
}


@end
