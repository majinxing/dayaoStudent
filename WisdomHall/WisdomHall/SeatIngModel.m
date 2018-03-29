//
//  SeatIngModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SeatIngModel.h"
#import "DYHeader.h"

@implementation SeatIngModel
-(void)setInfoWithDict:(NSDictionary *)dict{
    _seatTable = [dict objectForKey:@"seat"];
    
    _seatTableId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    
    _seatTableNamel = [dict objectForKey:@"name"];
    
    _seatColumn = [NSMutableArray arrayWithCapacity:1];
    
    if (![UIUtils isBlankString:_seatTable]) {
        
        NSMutableString * str = [NSMutableString stringWithFormat:@"%@",_seatTable];
        
        NSArray * seatAry = [str componentsSeparatedByString:@"\n"];
        
        _seatRow = (int)seatAry.count;
        
        for (int j = 0; j<seatAry.count; j++) {
            int a = 0;
            for(int i =0; i < [seatAry[j] length]; i++)
            {
                NSString * newStr = seatAry[j];
                NSString * temp = [newStr substringWithRange:NSMakeRange(i,1)];
                
                if ([temp isEqualToString:@"@"]) {
                    a++;
                }
            }
            
            [_seatColumn addObject:[NSString stringWithFormat:@"%d",a]];
            
        }
        
    }
    
}
@end
