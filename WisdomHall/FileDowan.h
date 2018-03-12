//
//  FileDowan.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DYHeader.h"

@interface FileDowan : NSObject

@property (nonatomic, strong) AFHTTPRequestSerializer *serializer;
//@property (nonatomic, strong) AFHTTPRequestOperation *downLoadOperation;
+ (instancetype)getInstance;

@end
