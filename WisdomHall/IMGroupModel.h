//
//  IMGroupModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/19.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMGroupModel : NSObject
@property (nonatomic,copy)NSString * groupName;
@property (nonatomic,copy)NSString * groupIntroduction;
@property (nonatomic,strong)NSMutableArray * groupPeople;
@end
