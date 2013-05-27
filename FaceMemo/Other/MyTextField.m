//
//  MyTextField.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/11.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect{
    [[UIColor grayColor]setFill];
    [[self placeholder]drawInRect:rect withFont:[UIFont systemFontOfSize:16]];
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
