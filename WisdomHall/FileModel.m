//
//  FileModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "FileModel.h"
#import "DYHeader.h"
@implementation FileModel
-(void)setInfoWithDict:(NSDictionary *)dict{
    _fileName = [dict objectForKey:@"url"];
    _fileDescription = [dict objectForKey:@"description"];
    _fileId = [dict objectForKey:@"id"];
    _fileCreatTime = [UIUtils timeWithTimeIntervalString:[dict objectForKey:@"createTime"]];
}
@end
