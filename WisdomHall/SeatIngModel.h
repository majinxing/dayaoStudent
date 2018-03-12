//
//  SeatIngModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeatIngModel : NSObject
@property (nonatomic,copy)NSString * seatTable;//座次字符串
@property (nonatomic,copy)NSString * seatTableId;//会场id
@property (nonatomic,copy)NSString * seatTableNamel;//会场名字
@property (nonatomic,assign) int seatRow;//坐场有几排
@property (nonatomic,strong) NSMutableArray * seatColumn;
-(void)setInfoWithDict:(NSDictionary *)dict;
@end
