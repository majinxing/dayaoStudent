//
//  JoinViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/25.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "JoinViewController.h"
#import "CollectionFlowLayout.h"
#import "CourseCollectionViewCell.h"
#import "MJRefresh.h"
#import "CourseDetailsViewController.h"
#import "TheMeetingInfoViewController.h"
#import "MeetingModel.h"
#import "CourseDetailsViewController.h"
#import "DYHeader.h"

static NSString * cellIdentifier = @"cellIdentifier";

@interface JoinViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UILabel *codeLable;
@property (strong, nonatomic) IBOutlet UITextField *textFile;
@property (nonatomic,strong) UICollectionView * collection;
@property (nonatomic,strong) NSMutableArray * classModelAry;
@property (nonatomic,strong) UserModel * userModel;
@property (nonatomic,copy) NSString * selectStr;
@property (nonatomic,copy) NSString * searchStr;
/** @brief 当前加载的页数 */
@property (nonatomic) int page;

@end

@implementation JoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _codeLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    
    _searchBtn.layer.masksToBounds = YES;
    
    _searchBtn.layer.cornerRadius = 22;
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    [self addTableView];
    
    self.title = @"搜索";
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)searchBtnPressed:(id)sender {
    _searchStr = _textFile.text;
    [self headerRereshing];
}
-(void)addTableView{
    CollectionFlowLayout * flowLayout = [[CollectionFlowLayout alloc] init];
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+CGRectGetMaxY(_searchBtn.frame),APPLICATION_WIDTH,APPLICATION_HEIGHT-54-64) collectionViewLayout:flowLayout];
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
//    __weak JoinViewController * weakSelf = self;
    
//    [self.collection addHeaderWithCallback:^{
//        [weakSelf headerRereshing];
//    }];
//    [self.collection addFooterWithCallback:^{
//        [weakSelf footerRereshing];
//    }];
    
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
            JoinViewController * strongSelf = weakSelf;
            if (aIsHeader) {
                [_classModelAry removeAllObjects];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf getSelfJoinClass:aPage];
            });
            
            if (aIsHeader) {
                [strongSelf.collection headerEndRefreshing];
            }else{
                [strongSelf.collection footerEndRefreshing];
            }
        }
    });
}

-(void)getSelfJoinClass:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"studentId",@"2017-07-01",@"actStartTime",@"1000",@"length",_userModel.school,@"universityId",[NSString stringWithFormat:@"%d",[UIUtils getTermId]],@"termId",@"1",@"courseType",_searchStr,@"courseId",nil];
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
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
        
        [self hideHud];
        
    }];
}

//临时
-(void)getSelfJoinClassType:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"studentId",@"2017-07-01",@"actStartTime",@"1000",@"length",_userModel.school,@"universityId",@"2",@"courseType",_searchStr,@"courseId",nil];
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collection reloadData];
            if (_classModelAry.count>0) {
                
            }else{
                [UIUtils showInfoMessage:@"没有搜索到对应的课程" withVC:self];
                
            }
            [self hideHud];
            
        });
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
        
        [self hideHud];
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
