//
//  ClassTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/18.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ClassTableViewCell.h"
#import "ClassModel.h"
#import "DYHeader.h"


@interface ClassTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *weekDay;
@property (strong, nonatomic) IBOutlet UILabel *sclass;
@property (strong, nonatomic) IBOutlet UIButton *monday;
@property (strong, nonatomic) IBOutlet UIButton *tuesday;
@property (strong, nonatomic) IBOutlet UIButton *wednesday;
@property (strong, nonatomic) IBOutlet UIButton *thursday;
@property (strong, nonatomic) IBOutlet UIButton *friday;
@property (strong, nonatomic) IBOutlet UIButton *saturday;
@property (strong, nonatomic) IBOutlet UIButton *sunday;
@property (strong, nonatomic) IBOutlet UIView *h;
@property (strong, nonatomic) IBOutlet UIView *s;
@property (nonatomic,strong)NSMutableArray * weekday;
@property (nonatomic,strong)NSMutableArray * ary;
@property (nonatomic,copy)NSString * index;
@property (nonatomic,strong)NSMutableDictionary * dictAry;

@end
@implementation ClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _weekday = [[NSMutableArray alloc] initWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天", nil];
    _monday.tag = 1;
    _tuesday.tag = 2;
    _wednesday.tag = 3;
    _thursday.tag = 4;
    _friday.tag = 5;
    _saturday.tag = 6;
    _sunday.tag = 7;
    _h.backgroundColor = RGBA_COLOR(184, 216, 248, 1);
    _s.backgroundColor = RGBA_COLOR(184, 216, 248, 1);
    _weekDay.textColor = RGBA_COLOR(57, 114, 172, 1);
    _sclass.textColor = RGBA_COLOR(57, 114, 172, 1);
    _dictAry = [[NSMutableDictionary alloc] init];
    for (int i = 1; i<=7; i++) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:1];
        [_dictAry setObject:ary forKey:[NSString stringWithFormat:@"%d",i]];
    }
    // Initialization code
}
-(void)addFirstContentViewWith:(int)index withClass:(NSMutableArray *)classAry{
    _index = [NSString stringWithFormat:@"%d",index+1];
    for (int i = 0; i<7; i++) {
        NSString * ss = [[NSString alloc] init];
        
        UIButton * btn = [self viewWithTag:i+1];
        NSMutableArray * ary = [_dictAry objectForKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
        [ary removeAllObjects];
        for (int j = 0; j<classAry.count; j++) {
            NSString * str = _weekday[i];
            ClassModel * c = classAry[j];
            if ([c.weekDayName isEqualToString:str]) {
                if ([UIUtils isBlankString:ss]) {
                    ss = [NSString stringWithFormat:@"%@@%@",c.name,c.typeRoom];
                    NSMutableArray * ary = [_dictAry objectForKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
                    [ary addObject:[NSString stringWithFormat:@"%d",j]];
                    [_dictAry setObject:[NSString stringWithFormat:@"%ld",(long)btn.tag] forKey:ary];
                }else{
                    ss = [NSString stringWithFormat:@"%@ %@@%@",ss,c.name,c.typeRoom];
                    NSMutableArray * ary = [_dictAry objectForKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
                    [ary addObject:[NSString stringWithFormat:@"%d",j]];
                    [_dictAry setObject:[NSString stringWithFormat:@"%ld",(long)btn.tag] forKey:ary];
                }
            }
        }
        if ([UIUtils isBlankString:ss]) {
            [btn setEnabled:NO];
            [btn setTitle:@"" forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor clearColor];
        }else{
            NSMutableArray * ary = [_dictAry objectForKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
            int n = 0;
            if (ary.count>0) {
                n = [ary[0] intValue];
            }
            ClassModel * c = classAry[n];
            [btn setTitle:ss forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setEnabled:YES];
            btn.backgroundColor  = c.backColock;//YELLOW;//RGBA_COLOR(80, 172, 224, 1);
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            btn.titleLabel.lineBreakMode = 0;//这句话很重要，不加这句话加上换行符也没用
            [btn addTarget:self action:@selector(intoTheCurriculum:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    _weekDay.text = [NSString stringWithFormat:@"%d",index*2+1];
    
    _sclass.text = [NSString stringWithFormat:@"%d",index*2+2];
    
//    _weekDay.textColor = [UIColor whiteColor];
//    _sclass.textColor = [UIColor whiteColor];
    
}
-(void)intoTheCurriculum:(UIButton *)btn{
    //    NSString * str = [NSString stringWithFormat:@"%@",_index];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(intoTheCurriculumDelegate:withNumber:)]) {
        NSMutableArray * ary = [_dictAry objectForKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];

        [self.delegate intoTheCurriculumDelegate:_index withNumber:ary];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
