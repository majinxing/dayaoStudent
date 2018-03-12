//
//  CreateTestViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"

@interface CreateTestViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *titleTextFile;
@property (strong, nonatomic) IBOutlet UITextField *typeTextFile;
@property (strong, nonatomic) IBOutlet UITextField *indexPoint;
@property (strong, nonatomic) IBOutlet UITextField *timeLimitTextFile;
@property (strong, nonatomic) IBOutlet UITextField *redoTextFile;
@property (nonatomic,strong)ClassModel * classModel;
@end
