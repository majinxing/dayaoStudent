//
//  SignPeople.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignPeople : NSObject
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * seat;
//@property (nonatomic,copy) NSString * seatNumber;
@property (nonatomic,copy) NSString * signStatus;
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) NSString * workNo;
@property (nonatomic,copy) NSString * pictureId;
@property (nonatomic,assign) BOOL isSelect;


-(void)setInfoWithDict:(NSDictionary *)dict;
@end
