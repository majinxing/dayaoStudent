//
//  PlayerButton.h
//  Recorder
//
//  Created by Japho on 15/10/16.
//  Copyright © 2015年 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerButton : UIButton

//开始动画
- (void)startAnimating;
//结束动画
- (void)stopAnimating;
//设置描述
- (void)setSecond:(int)second;

@end
