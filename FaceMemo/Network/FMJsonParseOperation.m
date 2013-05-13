//
//  FMJsonParseOperation.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/13.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMJsonParseOperation.h"
#import "SBJson.h"


@implementation FMJsonParseOperation

- (id)initWithUrl:(NSURL *)url{
    self = [super init];
    
    if (!self) {
        return nil;
    }

    _url = url;
    _isExecuting = NO;
    _isFinished  = NO;

    return self;

}


- (void)start{
    
    _isExecuting = YES;
    
    //リクエスト作成
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:_url];
    
    //コネクション作成
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:req delegate:self];
    
    // NSURLConnection は RunLoop をまわさないとメインスレッド以外で動かない
    if (connection != nil) {
        do{
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            
            if ([self isCancelled]) {
                //TODO:キャンセルの作業
                
            }
        } while(_isExecuting);
    }
     
}

- (BOOL)isConcurrent{
    
    return YES;
    
}


#pragma  mark
#pragma NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSLog(@"connection:didReceiveResponse");
    NSHTTPURLResponse *res = (NSHTTPURLResponse*)response;
    NSLog(@"statusCode:%d",res.statusCode);
    
    //バッファ作成
    _mutableData = [[NSMutableData alloc]init];
    
    [_delegate operation:self didReceiveResponse:res];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [_mutableData appendData:data];
    
    [_delegate operation:self didReceiveData:data];
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    //TODO:通信エラー処理
    [_delegate operation:self didFailWithError:error];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [_delegate operationDidFinishLoading:self];
    
    //jsonをパースしたデータを作成
    NSString *encodedData = [[NSString alloc]initWithData:_mutableData encoding:NSUTF8StringEncoding];
    _parsedData= [encodedData JSONValue];
    
    _isExecuting = NO;
    _isFinished  = YES;
    _mutableData = nil;
}


@end
