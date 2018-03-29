//
//  MJXPersonalCenterCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/10/9.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJXPersonalCenterCell : UITableViewCell
-(void)setImageName:(NSString *)imageName withText:(NSString *)text;
-(void)addHeadImage:(NSString *)imageUrl withName:(NSString *)name withTheTitle:(NSString *)title withHospital:(NSString *)hospital;
-(void)setImageWithImageName:(NSString *)nameImage;
@end
