//
//  optionsModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface optionsModel : NSObject
@property (nonatomic,copy) NSString * optionsTitle;
@property (nonatomic,strong) NSMutableArray * optionsImageAry;
@property (nonatomic,strong) NSMutableArray * optionsImageIdAry;
@property (nonatomic,copy) NSString *optionId;//选项id
@property (nonatomic,copy) NSString *index;//序号
@property (nonatomic,copy) NSString * questionId;//问题id
@property (nonatomic,assign) BOOL edit;
-(void)setContentWithDict:(NSDictionary *)dict;

-(float)returnOptionHeight;
@end
