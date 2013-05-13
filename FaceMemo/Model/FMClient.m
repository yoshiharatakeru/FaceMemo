//
//  FMClient.m
//  FaceMemo
//
//  Created by Takeru Yoshihara on 2013/05/08.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "FMClient.h"
#import "SBJson.h"

@implementation FMClient
-(id)initWithBaseUrl:(NSString *)baseUrl{
    self = [super init];
    if (!self) {
        return nil;
    }
    _baseUrl = baseUrl;
    return self;
}


-(id)authorize{
    
    //現状ではただ登録するのみ
    //TODO:初めてのユーザーのみを検出してデータベースに登録
    NSString *path = @"sample/create";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            path,@"path",
                            @"POST",@"method",
                            nil];
    
    NSLog(@"params:%@",params.description);
    [self request:params];
    
    return self;
    
}


- (void)postToPath:(NSString*)path param:(NSDictionary*)param{
    NSLog(@"client:postToPath");
    
    //パラメータ作成
    NSData *paramData = [self textBodyForParam:param];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
    path,       @"path",
    paramData,  @"paramData",
    @"POST",    @"method",
    nil];
    
    NSLog(@"params:%@",params.description);
    
    [self request:params];
    

    
     
}



-(void)request:(NSDictionary*)params
{
    NSLog(@"client:request");
    //TODO:ちゃんと書く
    
    NSData        *data = nil;
    NSError       *err  = nil;
    NSHTTPURLResponse *res = nil;
    NSURL         *url;
    
    //リクエスト準備
    NSString *url_str = [NSString stringWithFormat:@"%@%@",_baseUrl,[params objectForKey:@"path"]];
    url = [NSURL URLWithString:url_str];
    NSLog(@"url:%@",[url absoluteString]);
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //ヘッダ,ボディ準備
    [req setHTTPMethod:[params objectForKey:@"method"]];
    [req setValue:@"multipart/form-data"forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:[params objectForKey:@"paramData"]];

    
    //送信
    data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    
    //エラーハンドリング
    NSLog(@"statuscode:%d",res.statusCode);
    if (err) {
        NSLog(@"nSURLException:%@#", err.localizedDescription);
        NSException *exception = [NSException exceptionWithName:@"nSURLException" reason:err.localizedDescription userInfo:nil];
        [exception raise];
    }
    
    //TODO:ステータスコードに応じたエラーハンドリング
    
    
    
    
    //結果の取得
    NSString *encodedStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonData = [encodedStr JSONValue];
    NSLog(@"jsonData:%@",jsonData.description);
    
    

    
}


//リクエストボディの準備（テキスト)
-(NSData*)textBodyForParam:(NSDictionary*)param{
    
    NSMutableString *textStr = [[NSMutableString alloc]init];
    if (!param) {
        return nil;
    }
    
    NSArray *allKeys = [param allKeys];
    for (int i=0; i<allKeys.count; i++) {
        
        //エスケープ
        NSString *key = [allKeys objectAtIndex:i];
        NSString *value = [self addEscape:[param objectForKey:key]];
        NSString *content = [NSString stringWithFormat:@"%@=%@&",key, value];
        [textStr appendString:content];
        
    }
    
    NSLog(@"text:%@",textStr);
    return [textStr dataUsingEncoding:NSUTF8StringEncoding];
    
}


//エスケープ
-(NSString*)addEscape:(NSString*)str{
    
    if (![str isKindOfClass:[NSString class]]) {
        return str;
    }
    
    NSString *result;
    result = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return result;
    
}

@end

