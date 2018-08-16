//
//  FileModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject
@property (nonatomic,copy)NSString * fileName;
@property (nonatomic,copy)NSString * fileDescription;
@property (nonatomic,copy)NSString * fileId;
@property (nonatomic,copy)NSString * fileCreatTime;
@property (nonatomic,assign)BOOL isLocal;//是否存在本地
@property (nonatomic,copy)NSString * fileSize;//文件的大小

-(void)setInfoWithDict:(NSDictionary *)dict;
@end
