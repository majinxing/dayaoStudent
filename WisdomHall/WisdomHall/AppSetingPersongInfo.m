//
//  AppSetingPersongInfo.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "AppSetingPersongInfo.h"

@implementation AppSetingPersongInfo
+(AppSetingPersongInfo *)sharedInstance{
    static AppSetingPersongInfo * sharedInstance = nil;
    static dispatch_once_t  predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
//本地化初始化
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _mySettingData = [NSUserDefaults standardUserDefaults];//本地化处理
    }
    
    return self;
}
-(void)isLogin{

}
-(void)loginOut{
    [_mySettingData synchronize];
}
@end
