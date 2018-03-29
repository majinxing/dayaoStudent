//
//  StudentSorce.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/5.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentSorce : NSObject
@property(nonatomic,copy)NSString * studentName;
@property(nonatomic,copy)NSString * score;
-(void)setSelfInfoWithDict:(NSDictionary *)dict;
@end
