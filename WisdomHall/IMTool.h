//
//  IMTool.h
//  WisdomHall
//
///Users/xtu-ti/Documents/IM_integration/IM_integration/imkit/Users/xtu-ti/Documents/IM_integration/IM_integration/imsdk  Created by XTU-TI on 2018/6/29.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMTool : NSObject
+(void)IMLogin:(NSString *)UId;

@property(nonatomic) NSString *deviceToken;

@end
