//
//  MJXMedicalHistoryViewController.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/13.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJXPatients.h"
typedef void (^ReturnTextBlock)(NSString *returnText);

@interface MJXMedicalHistoryViewController : UIViewController
@property (nonatomic,strong)MJXPatients *patients;
@property (nonatomic,strong)NSString *medicaid;

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end
