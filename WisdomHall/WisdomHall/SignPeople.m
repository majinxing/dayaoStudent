//
//  SignPeople.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SignPeople.h"

@implementation SignPeople
-(void)setInfoWithDict:(NSDictionary *)dict{
    self.name = [dict objectForKey:@"name"];
    self.seat = [dict objectForKey:@"seat"];
    self.signStatus = [dict objectForKey:@"signStatus"];
    self.userId = [dict objectForKey:@"userId"];
    self.workNo = [dict objectForKey:@"workNo"];
    self.pictureId = [dict objectForKey:@"pictureId"];
    self.isSelect = NO;
}
@end
