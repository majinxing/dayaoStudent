//
//  JFAlbumVC.m
//  JFAlbum
//
//  Created by Japho on 15/10/22.
//  Copyright © 2015年 Japho. All rights reserved.
//

#import "JFAlbumVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JFGroupInfo.h"
#import "JFGroupCell.h"
#import "JFPhotoVC.h"
#import "JFImagePickerController.h"
#import "MJXRootViewController.h"

@interface JFAlbumVC () <UITableViewDataSource,UITableViewDelegate,JFPhotoViewControllerDelegate>
{
    ALAssetsLibrary *_assetsLibrary;//资源库
    NSMutableArray *_groupArray;
    UITableView *_tableView;
}
@end

@implementation JFAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"照片";
    
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"照片"];
    
    [self addBackButton];
    //添加tableView
    [self addTableView];
    //从资源库中加载相册信息
    [self loadAssetsGroup];
    
}
-(void)addBackButton{
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


//添加tableView
- (void)addTableView
{
    CGRect frame = self.view.frame;
//    frame.size.height -= 44 + 20;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

//从资源库中加载相册信息
- (void)loadAssetsGroup
{
    ALAuthorizationStatus authorStatus = [ALAssetsLibrary authorizationStatus];
    if (authorStatus == ALAuthorizationStatusDenied || authorStatus == ALAuthorizationStatusRestricted)
    {
        //程序的名字
        NSDictionary*info = [[NSBundle mainBundle] infoDictionary];
        NSString*projectName = [info objectForKey:@"CFBundleName"];
        NSString *message = [NSString stringWithFormat:@"请在%@的“设置－隐私－照片”选项中，允许%@访问您的手机。",[UIDevice currentDevice].model,projectName];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alertView show];
    }
    
    //初始化资源库
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    //初始化数组
    _groupArray = [NSMutableArray arrayWithCapacity:10];
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum | ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            //添加资源过滤器
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            //判断照片里的照片数量大于零·
            if (group.numberOfAssets > 0)
            {
                JFGroupInfo *groupInfo = [JFGroupInfo groupInfoWithGroup:group];
                [_groupArray addObject:groupInfo];
            }
        }
        else
        {
            _groupArray = (NSMutableArray *)[[_groupArray reverseObjectEnumerator] allObjects];
            JFPhotoVC *firstPhotoVC;
            if (_groupArray.count>0&&_groupArray!=nil) {
              firstPhotoVC = [[JFPhotoVC alloc] initWithGroupInfo:_groupArray[0]];
            }else{
              firstPhotoVC = [[JFPhotoVC alloc] initWithGroupInfo:nil];
            }
            firstPhotoVC.delegate = self;
            firstPhotoVC.maxAmount = _maxAmount;
            firstPhotoVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:firstPhotoVC animated:NO];
            //获取组结束
            [_tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"获取组失败");
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    JFGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell)
    {
        cell = [[JFGroupCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
    }
    
    [cell setContentView:_groupArray[indexPath.row]];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JFPhotoVC *photoVC = [[JFPhotoVC alloc] initWithGroupInfo:_groupArray[indexPath.row]];
    photoVC.delegate = self;
    photoVC.maxAmount = _maxAmount;
    photoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:photoVC animated:NO];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JFGroupCell getCellHeight];
}

#pragma mark JFPhotoViewControllerDelegate

- (void)photoViewControllerImagePickerSuccess:(NSArray *)array
{
    if (self.delegate && [self.delegate respondsToSelector:
                            @selector(imagePickerControllerDidFinishWithArray:)])
    {
        [self.delegate imagePickerControllerDidFinishWithArray:array];
    }
}
@end
