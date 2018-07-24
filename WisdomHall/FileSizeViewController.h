//
//  FileSizeViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/13.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"

@interface FileSizeViewController : UIViewController
@property (nonatomic,strong)FileModel * fileModel;
@property (nonatomic,copy) NSString * urlStr;

@end
