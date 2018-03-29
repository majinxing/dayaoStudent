//
//  MJXFollowUpTemplateInfoViewController.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/20.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJXPatients.h"
@interface MJXFollowUpTemplateInfoViewController : UIViewController
@property (nonatomic,strong)NSString *templateName;
@property (nonatomic,strong)MJXPatients *patients;
@property (nonatomic,strong)NSMutableArray *timeAdviceArray;
@property (nonatomic,assign)BOOL whetherTemplate;
@end
