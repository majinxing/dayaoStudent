//
//  MJXTemplateNameTableViewCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/26.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJXTemplateNameTableViewCell : UITableViewCell
@property (nonatomic,strong)NSString *templateName;
-(void)setUserTemplateWithImage:(NSString *)imageStr withTitleText:(NSString *)textStr;
-(void)setTemplateName:(NSString *)name;
@end
