//
//  MJXClient.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/25.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import "AFNetworking.h"

@interface MJXClient : AFHTTPSessionManager
+ (instancetype)sharedInstance;
+(AFHTTPRequestOperationManager *)setAFHTTPRequestOperationManagerSomeQuality;
@end
