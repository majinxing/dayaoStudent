//
//  Group.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/9.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject
@property (nonatomic,copy)NSString * groupName;
@property (nonatomic,copy)NSString * groupId;
-(void)setSelfWithDict:(NSDictionary *)dict;
@end
