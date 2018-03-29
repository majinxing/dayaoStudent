//
//  SelectClassViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/15.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SelectClassViewController.h"
#import "CourseCollectionViewCell.h"
#import "CollectionFlowLayout.h"
#import "DYHeader.h"
#import "TheMeetingInfoViewController.h"
#import "MeetingModel.h"
#import "MJRefresh.h"
#import "CourseDetailsViewController.h"

static NSString * cellIdentifier = @"cellIdentifier";
@interface SelectClassViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong) UICollectionView * collection;
@property (nonatomic,strong) NSMutableArray * classModelAry;
@property (nonatomic,strong) UserModel * userModel;
@property (nonatomic,strong)UISearchBar * mySearchBar;
@property (nonatomic,copy) NSString * selectStr;
@property (nonatomic,copy) NSString * searchStr;
/** @brief 当前加载的页数 */
@property (nonatomic) int page;
@end

@implementation SelectClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _classModelAry = [NSMutableArray arrayWithCapacity:12];
    
    [self addSeachBar];
    
    [self setNavigationTitle];
    
    [self addCollection];
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)addSeachBar{
    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, 54)];
    _mySearchBar.backgroundColor = [UIColor clearColor];
    //去掉搜索框背景
    
    //1.
    for (UIView *subview in _mySearchBar.subviews)
        
    {
        
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            
        {
            
            [subview removeFromSuperview];
            
            break;
            
        }
        
    }
    _mySearchBar.delegate = self;
    _mySearchBar.searchBarStyle = UISearchBarStyleDefault;
    //这个可以加方法 取消的方法
    //_mySearchBar.showsCancelButton = YES;
    _mySearchBar.tintColor = [UIColor blackColor];
    [_mySearchBar setPlaceholder:@"搜索"];
    //[_mySearchBar setBackgroundImage:[UIImage imageNamed:@"search-1"]];
    _mySearchBar.showsScopeBar = YES;
    //    [_mySearchBar sizeToFit];
    //_mySearchBar.hidden = YES;  ///隐藏搜索框
    [self.view addSubview:self.mySearchBar];
    //    [self.mySearchBar becomeFirstResponder];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   
    self.title = @"搜索";
    
};
/**
 * 添加collection
 **/
-(void)addCollection{
    CollectionFlowLayout * flowLayout = [[CollectionFlowLayout alloc] init];
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+54,APPLICATION_WIDTH,APPLICATION_HEIGHT-54-64) collectionViewLayout:flowLayout];
//    flowLayout.headerReferenceSize = CGSizeMake(0, APPLICATION_HEIGHT/4);
    self.automaticallyAdjustsScrollViewInsets = NO;
    //注册
    [_collection registerClass:[CourseCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.allowsMultipleSelection = YES;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.showsHorizontalScrollIndicator = NO;
    //取消滑动的滚动条
    _collection.decelerationRate = UIScrollViewDecelerationRateNormal;
    _collection.backgroundColor = [UIColor clearColor];
    self.collection.alwaysBounceVertical = YES; //垂直方向遇到边框是否总是反弹
    __weak SelectClassViewController * weakSelf = self;
    
    [self.collection addHeaderWithCallback:^{
        [weakSelf headerRereshing];
    }];
    [self.collection addFooterWithCallback:^{
        [weakSelf footerRereshing];
    }];
    
    //    [self headerRereshing];
    [self.view addSubview:_collection];
}
#pragma mrak MJR
-(void)headerRereshing{
    self.page = 1;
    [self fetchChatRoomsWithPage:self.page isHeader:YES];
}
-(void)footerRereshing{
    self.page +=1;
    [self fetchChatRoomsWithPage:self.page isHeader:NO];
}
- (void)fetchChatRoomsWithPage:(NSInteger)aPage
                      isHeader:(BOOL)aIsHeader{
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (weakSelf) {
            SelectClassViewController * strongSelf = weakSelf;
            if (aIsHeader) {
                [_classModelAry removeAllObjects];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf getDataWithPage:aPage];
            });
            
            if (aIsHeader) {
                [strongSelf.collection headerEndRefreshing];
            }else{
                [strongSelf.collection footerEndRefreshing];
            }
        }
    });
}

-(void)getDataWithPage:(NSInteger)page{
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"teacherId",@"2017-07-01",@"actStartTime",@"1000",@"length",_userModel.school,@"universityId",@"2",@"type",[NSString stringWithFormat:@"%d",[UIUtils getTermId]],@"termId",@"1",@"courseType",_searchStr,@"keywords",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        //NSLog(@"%@",data);
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classModelAry addObject:c];
            }
        }
        [self getSelfJoinClass:page];
    } failure:^(NSError *error) {
        [self hideHud];

        NSLog(@"%@",error);
    }];
}
-(void)getSelfJoinClass:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"studentId",@"2017-07-01",@"actStartTime",@"1000",@"length",_userModel.school,@"universityId",@"1",@"type",[NSString stringWithFormat:@"%d",[UIUtils getTermId]],@"termId",@"1",@"courseType",_searchStr,@"keywords",nil];
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        // NSLog(@"%@",data);
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classModelAry addObject:c];
            }
        }
        [self getSelfCreateClassType:page];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self hideHud];

    }];
}
//临时
-(void)getSelfCreateClassType:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"teacherId",@"2017-07-01",@"actStartTime",@"1000",@"length",_userModel.school,@"universityId",@"2",@"type",@"2",@"courseType",_searchStr,@"keywords",nil];
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        // NSLog(@"%@",data);
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classModelAry addObject:c];
            }
        }
        [self getSelfJoinClassType:page];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self hideHud];

    }];
}
//临时
-(void)getSelfJoinClassType:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"studentId",@"2017-07-01",@"actStartTime",@"1000",@"length",_userModel.school,@"universityId",@"1",@"type",@"2",@"courseType",_searchStr,@"keywords",nil];
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        //NSLog(@"%@",data);
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classModelAry addObject:c];
            }
        }
        [self deleteTheDuplicateData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collection reloadData];
            if (_classModelAry.count>0) {
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有搜索到对应的课程" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
            [self hideHud];

        });
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self hideHud];

    }];
}
-(void)deleteTheDuplicateData{
    for (int i = 0; i<_classModelAry.count; i++) {
        ClassModel * c = _classModelAry[i];
        for (int j = i+1; j<_classModelAry.count; j++) {
            ClassModel * d = _classModelAry[j];
            NSString * s1 = [NSString stringWithFormat:@"%@",c.sclassId];
            NSString * s2 = [NSString stringWithFormat:@"%@",d.sclassId];
            if ([s1 isEqualToString:s2]) {
                [_classModelAry removeObjectAtIndex:j];
            }
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    _searchStr = searchBar.text;
    
    [self headerRereshing];
    [self.view endEditing:YES];
}
-(void)getSelfCreateMeetingList:(NSInteger)page{
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    if ([[NSString stringWithFormat:@"%@",user.identity] isEqualToString:@"0"]) {
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_userModel.peopleId,@"userId",[UIUtils getTime],@"startTime",@"",@"endTime",[NSString stringWithFormat:@"%ld",(long)page],@"start",nil];
        [[NetworkRequest sharedInstance] GET:QueryMeeting dict:dict succeed:^(id data) {
            //            NSLog(@"succeed%@",data);
            NSArray * d = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<d.count; i++) {
                MeetingModel * m = [[MeetingModel alloc] init];
                [m setMeetingInfoWithDict:d[i]];
                for (int j = 0; j<_classModelAry.count; j++) {
                    MeetingModel * n = _classModelAry[j];
                    if ([[NSString stringWithFormat:@"%@",n.meetingId] isEqualToString:[NSString stringWithFormat:@"%@",m.meetingId]]) {
                        break;
                    }else if(j == (_classModelAry.count - 1)){
                        [_classModelAry addObject:m];
                    }
                }
            }
            if (_classModelAry.count>0) {
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有搜索到对应的课程" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
            [_collection reloadData];
        } failure:^(NSError *error) {
            NSLog(@"失败%@",error);
        }];
    }
    
}
#pragma mark UICollectionViewDataSource
//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);//分别为上、左、下、右
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_classModelAry.count>0) {
        return _classModelAry.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row<_classModelAry.count) {
        [cell setClassInfoForContentView:_classModelAry[indexPath.row]];
    }
    return cell;
}
#pragma mark UICollectionViewDelegate
//初次点击走
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CourseDetailsViewController * mInfo = [[CourseDetailsViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    mInfo.c = _classModelAry[indexPath.row];
    [self.navigationController pushViewController:mInfo animated:YES];
    // self.hidesBottomBarWhenPushed=NO;
    
}
//有了初次点击再走这个
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CourseDetailsViewController * mInfo = [[CourseDetailsViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    mInfo.c = _classModelAry[indexPath.row];
    [self.navigationController pushViewController:mInfo animated:YES];
    // self.hidesBottomBarWhenPushed=NO;
    
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(APPLICATION_WIDTH, Collection_height);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
