//
//  FMClient.h
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/08.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMClient : NSObject
@property (nonatomic,strong) NSString *baseUrl;

- (id)initWithBaseUrl:(NSString*)baseUrl;
- (id)authorize;
- (void)postToPath:(NSString*)path param:(NSDictionary*)param;

@end
