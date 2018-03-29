//
//  MJXTabbarItem.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/10.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    ETabBarItemTypeHomeRecommend = 0,
    ETabBarItemTypeConsulting,
    ETabBarItemTypeFollowUp,
    ETabBarItemTypePersonalCenter,
}MJXTabbarItemType;

@interface MJXTabbarItem : NSObject  //封装按钮的基础数据
@property(nonatomic,copy)             NSString *title;  // 标题
@property(nonatomic,strong)           UIImage *image;  // 图像
@property(nonatomic,strong)           UIImage *selectedImage;  // 选中状态图像
@property(nonatomic)                  NSInteger tag;  // 标识

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag;
@end
