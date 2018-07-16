//
//  MJXCourseOfDiseaseTableViewCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/2.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol courseOfDiseaseTableViewCellDelegate <NSObject>
-(void)vistCameraButtonPressed:(UIButton *)btn;
-(void)descriptionButtonPressedCD:(UIButton *)btn;
-(void)historyButtonPressed;
-(void)delecateImagefromBrowsePicturesCollectionViewCellDelegated:(UIButton *)btn;
-(void)bjButtonPressed;
@end
@interface MJXCourseOfDiseaseTableViewCell : UITableViewCell
@property (nonatomic,weak) UIViewController *handleVC;

@property (nonatomic,weak)id<courseOfDiseaseTableViewCellDelegate> delegate;
@property (nonatomic,strong)UITextView *descriptionTextView;
-(void)setTimeClassificationWithTitle:(NSString *)title withImageName:(NSString *)name;

-(void)setFirstOptionWith:(NSString *)str;

-(void)setHeadImageWithName:(NSString *)imageUrl withName:(NSString *)name withSex:(NSString *)sex;

-(void)setTitle:(NSString *) title Button:(bool)B withButtonTag:(NSInteger)t ImageUrlArray:(NSArray *)ary Description:(NSString *)description history:(NSString *)historyStr;
-(void)setDiagnosisTextWithString:(NSString *)str;
@end
