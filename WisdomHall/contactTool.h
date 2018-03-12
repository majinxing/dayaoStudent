//
//  contactTool.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/23.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface contactTool : NSObject
+(NSMutableArray *)returnQuestion:(FMDatabase *)db withTextId:(NSString *)textId;
+(NSMutableArray *)returnQuestion:(FMDatabase *)db;
+(NSMutableArray *)querContactTableData:(FMDatabase *)db withTextId:(NSString *)textId;
@end
