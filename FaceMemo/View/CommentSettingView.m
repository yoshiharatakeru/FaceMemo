//
//  CommentSettingView.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/27.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "CommentSettingView.h"

@implementation CommentSettingView

- (id)init{
    
    UINib *nib = [UINib nibWithNibName:@"CommentSettingView" bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil]objectAtIndex:0];
    if (!self) {
        return nil;
    }
    
    return self;
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
