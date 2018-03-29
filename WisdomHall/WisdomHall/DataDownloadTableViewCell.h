//
//  DataDownloadTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/22.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"

@protocol DataDownloadTableViewCellDelegate <NSObject>

-(void)downloadFileDelegate:(UIButton *)btn;
-(void)secondDownloadBtnDelegate:(UIButton *)sender;
@end

@interface DataDownloadTableViewCell : UITableViewCell
@property (nonatomic,weak)id<DataDownloadTableViewCellDelegate>delegate;
-(void)addContentView:(FileModel *)f withIndex:(int)n;
-(void)addDownLoadContentView:(FileModel *)f withIndex:(int)n withIsSelect:(NSString *)b;
@end
