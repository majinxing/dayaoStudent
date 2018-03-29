//
//  ZFSeatViewController.h
//  
//
//  Created by qq 316917975  on 16/1/27.
//  gitHub地址：https://github.com/ZFbaby
//  后面还会增加多种样式（格瓦拉，淘票票，微票儿）实现UI可定制效果及开场动画样式，请关注更新！记得点星哦！！！

#import <UIKit/UIKit.h>
#import "ClassModel.h"

@interface ZFSeatViewController : UIViewController
@property (nonatomic,copy)NSString * seatTable;//座次表
@property (nonatomic,copy)NSString * seat;//座位号
@property (nonatomic,copy)NSString * type;//是否允许选座
@property (nonatomic,strong)ClassModel * classModel;
@end
