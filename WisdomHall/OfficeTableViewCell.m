//
//  OfficeTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/23.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "OfficeTableViewCell.h"
#import "DYHeader.h"
#import "ShareButton.h"
#import "FMDBTool.h"
#import "CollectionHeadView.h"

#define columns 3
#define buttonWH 60
#define marginHeight 8

@interface OfficeTableViewCell()<CollectionHeadViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *signBtn;
@property (strong, nonatomic) IBOutlet UILabel *signIN;
@property (strong, nonatomic) IBOutlet UILabel *signBack;
@property (nonatomic,strong)FMDatabase * db;
@property (nonatomic,strong)UIView * btnView;
@property (nonatomic,strong)UIView *fLineView;
@property (nonatomic,strong)UIView *sLineView;
@property (nonatomic,strong)UIView *tLineView;
@property (nonatomic,strong)CollectionHeadView *collectionHeadView;

@end
@implementation OfficeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _signBtn.layer.masksToBounds = YES;
    _signBtn.layer.cornerRadius = 40;
    _signBtn.backgroundColor = [UIColor colorWithHexString:@"#29a7e1"];
    [_signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT-20-100-140, APPLICATION_WIDTH, 140)];
    _btnView.backgroundColor = [UIColor whiteColor];
    _fLineView = [[UIView alloc] init];
    _sLineView = [[UIView alloc] init];
    _tLineView = [[UIView alloc] init];
    _collectionHeadView = [CollectionHeadView sharedInstance];
    
    _collectionHeadView.delegate = self;
//    [self signState];
    self.backgroundColor = [UIColor clearColor];
    //    [self addSecondContentView];
    // Initialization code
}
-(void)signState{
//    FMDatabase * db = [FMDBTool createDBWithName:SQLITE_NAME];
//    if ([db open]) {
//        NSString * sql = [NSString stringWithFormat:@"select * from %@",DAILYCHECK_TABLE_NAME];
//        FMResultSet * rs = [FMDBTool queryWithDB:db withSqlStr:sql];
//        int n = 0;
//        while (rs.next) {
//            NSString * date = [rs stringForColumn:@"date"];
//            NSString * today = [UIUtils getTime];
//            if ([today isEqualToString:date]) {
//                n = 1;
//                NSString * signIn = [rs stringForColumn:@"signIn"];
//                NSString * sInS = [rs stringForColumn:@"signInState"];
//                if ([UIUtils isBlankString:signIn]) {
//                    _signIN.text = @"签到状态:未签到";
//                }else{
//                    _signIN.text = [NSString stringWithFormat:@"签到状态:%@",sInS];
//                }
//
//                NSString * signBack = [rs stringForColumn:@"signBack"];
//                NSString * sBS = [rs stringForColumn:@"signBackState"];
//                if ([UIUtils isBlankString:signBack]) {
//                    _signBack.text = @"签退状态:未签退";
//                }else{
//                    _signBack.text = [NSString stringWithFormat:@"签退状态:%@",sBS];
//                }
//                break;
//            }
//        }
//    }
//    [db close];
    
}
//choolCommunity             @"校圈"
//#define AroundSchool                @"学校周边"
//#define Community
-(void)addSecondContentView{
    NSArray * array = @[
                        Meeting,
                        Announcement,
                        //Leave,
                        //Business,
                        //Lotus,
                        SchoolCommunity,
                        AroundSchool,
                        Community
                        ];
    NSArray * lineAry = @[_fLineView,_sLineView,_tLineView];
    //水平间距
    int marginWidth = (APPLICATION_WIDTH/3 - buttonWH) / 2;
    //起始XY坐标
    int oneX = marginWidth;
    int oneY = marginHeight;
    int xx = APPLICATION_WIDTH/3;
    for (int i = 0; i < array.count; i++)
    {
        //行
        int row = i / columns;
        //列
        int column = i % columns;
        //        int x = oneX + (buttonWH + marginWidth) * column;
        int x = oneX + xx*column;
        int y = oneY + 70 * row;
        
        
        if (i>0&&i<3) {
            
            UIView * view = lineAry[i-1];
            view.frame = CGRectMake(xx*i, 0, 1, 140);
            view.backgroundColor = RGBA_COLOR(190, 219, 244, 1);
            [_btnView addSubview:view];
        }
        ShareButton * button = [[ShareButton alloc] initWithFrame:CGRectMake(x, y, buttonWH, buttonWH) andType:array[i]];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:button];
    }
    UIView * view = lineAry[2];
    view.frame = CGRectMake(0, 70, APPLICATION_WIDTH, 1);
    view.backgroundColor = RGBA_COLOR(190, 219, 244, 1);
    [_btnView addSubview:view];
    
    _collectionHeadView.frame = CGRectMake(10,APPLICATION_HEIGHT-20-100-140-100, ScrollViewW,ScrollViewH);
    
    [self.contentView addSubview:_collectionHeadView];
    
    [self.contentView addSubview:_btnView];
}
- (void)shareButtonClicked:(UIButton *)button
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(shareButtonClickedDelegate:)]) {
        [self.delegate shareButtonClickedDelegate:button.titleLabel.text];
    }
    
}
- (IBAction)signPressed:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(signBtnPressedDelegate:)]) {
        [self.delegate signBtnPressedDelegate:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma dark CollectionHeadViewDelegate
-(void)noticeBtnPressedDelegate:(NoticeModel *)notice{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(noticeBtnPressedDelegateOfficeCellDelegate:)]) {
        [self.delegate noticeBtnPressedDelegateOfficeCellDelegate:notice];
    }
}
@end

