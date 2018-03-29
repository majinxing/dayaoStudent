//
//  ClassRoomModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/5.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassRoomModel : NSObject
@property (nonatomic,copy) NSString * seat;
@property (nonatomic,copy) NSString * classRoomId;
@property (nonatomic,copy) NSString * universityId;
@property (nonatomic,copy) NSString * classRoomName;
@property (nonatomic,copy) NSString * mck;
@property (nonatomic,copy) NSString * type;
-(void)setInfoWithDict:(NSDictionary *)dict;

@end
