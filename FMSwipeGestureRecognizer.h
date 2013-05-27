//
//  FMSwipeGestureRecognizer.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/24.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMSwipeGestureRecognizer : UISwipeGestureRecognizer

@property (nonatomic,strong) NSIndexPath *indexPath;

@end
