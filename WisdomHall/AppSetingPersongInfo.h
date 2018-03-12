//
//  AppSetingPersongInfo.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSetingPersongInfo : NSObject

@property NSUserDefaults *mySettingData;//归档的一种 用来把用户数据本地化保存

+(AppSetingPersongInfo *)sharedInstance;
-(void)isLogin;//登录
-(void)loginOut;//退出
@end
