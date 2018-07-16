//
//  MJXGroup.h
//  XinSuiFang
//
//  Created by majinxing on 16/11/23.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJXGroup : NSObject
@property (nonatomic,copy) NSString * gName;//组名
@property (nonatomic,copy) NSString * gId;//组的ID
@property (nonatomic,copy) NSString * selected;//是否被选中
-(void)saveGroup:(NSDictionary *)dict;

@end
