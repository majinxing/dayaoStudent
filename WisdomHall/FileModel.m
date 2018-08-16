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
    NSString * str = [dict objectForKey:@"url"];
    if (![UIUtils isBlankString:str]) {
        NSArray *ary = [str componentsSeparatedByString:@"/"];
        if (ary.count>1) {
            _fileName = ary[1];
        }else{
            _fileName = ary[0];
        }
    }
    _fileDescription = [dict objectForKey:@"description"];
    _fileId = [dict objectForKey:@"id"];
    _fileCreatTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"createTime"]];
    _fileSize = [NSString stringWithFormat:@"%@",[dict objectForKey:@"size"]];

}
@end
