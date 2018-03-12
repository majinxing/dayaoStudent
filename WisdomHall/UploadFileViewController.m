//
//  UploadFileViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "UploadFileViewController.h"
#import "DYHeader.h"
#import "FileModel.h"
#import "DataDownloadTableViewCell.h"
#import "TFFileUploadManager.h"

@interface UploadFileViewController ()<UITableViewDelegate,UITableViewDataSource,DataDownloadTableViewCellDelegate,UIDocumentInteractionControllerDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * fileAry;
@property(nonatomic,strong)NSMutableArray * boolAry;
@property (strong, nonatomic) IBOutlet UIButton *sendbtn;
@property (nonatomic,assign)int temp;
@property (nonatomic,strong)UIAlertView * alter;
@property (nonatomic,assign)int n;
@property (nonatomic,assign)int m;
@end

@implementation UploadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _temp = 0;
    
    _fileAry = [NSMutableArray arrayWithCapacity:1];
    
    _boolAry = [NSMutableArray arrayWithCapacity:1];
    
    [self addSendBtn];
    
    [self retrieveLocalFile];
    
    [self setNavigationTitle];
    
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)addSendBtn{
    [_sendbtn setBackgroundColor:[UIColor colorWithHexString:@"#f7f7f7"]];
    [_sendbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_sendbtn setTitle:[NSString stringWithFormat:@"发送"] forState:UIControlStateNormal];
    _sendbtn.layer.masksToBounds = YES;
    _sendbtn.layer.cornerRadius = 5;
    [_sendbtn setEnabled:NO];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"资料上传";
    
    //    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    //    self.navigationItem.leftBarButtonItem = selection;
    UIBarButtonItem * createMeeting = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = createMeeting;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)retrieveLocalFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths lastObject];
    
    //    NSLog(@"app_home_doc: %@",documentsDirectory);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"File"]; //docPath为文件名
    
    //判断文件夹是否存在，若不存在创建路径中的文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path=filePath; // 要列出来的目录
    
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    
    NSDirectoryEnumerator *myDirectoryEnumerator;
    
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
    
    //列举目录内容，可以遍历子目录
    NSLog(@"用enumeratorAtPath:显示目录%@的内容：",path);
    
    while((path=[myDirectoryEnumerator nextObject])!=nil)
    {

        if (![path isEqualToString:@".DS_Store"]) {
            
            FileModel * f = [[FileModel alloc] init];
            f.fileName = path;
            
            [_fileAry addObject:f];
            
            NSString * a = @"NO";
            
            [_boolAry addObject:a];
        }
       
    }
    
    [_tableView reloadData];

}
- (IBAction)sendBtnPressed:(id)sender {
    _n = 0;
    for (int i = 0; i<_boolAry.count; i++) {
        NSString * str = _boolAry[i];
        if ([str isEqualToString:@"Yes"]) {
            _n++;
        }
    }
    for (int i = 0; i<_boolAry.count; i++) {
        NSString * str = _boolAry[i];
        _m = 1;

        if ([str isEqualToString:@"Yes"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //获取主线程
                [self hideHud];
                [self showHudInView:self.view hint:NSLocalizedString(@"正在上传数据", @"Load data...")];
            });
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *documentsDirectory = [paths lastObject];
            
            NSLog(@"app_home_doc: %@",documentsDirectory);
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            FileModel * f = _fileAry[i];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"File/%@",f.fileName]]; //docPath为文件名
            
            if (![fileManager fileExistsAtPath:filePath]) {
                NSLog(@"%s",__func__);
            }
            NSString * str ;

            if ([_type isEqualToString:@"meeting"]) {
                str = [NSString stringWithFormat:@"%@",_meeting.meetingId];
                NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"9",@"type",@"www",@"description",@"2",@"function",[NSString stringWithFormat:@"%@",str],@"relId",@"2",@"relType",nil];
                
                [[NetworkRequest sharedInstance] POSTImage:FileUpload filePath:filePath dict:dict succeed:^(id data) {
                    if (_m == _n) {
                        [UIUtils showInfoMessage:@"上传完成"];
                        [self hideHud];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        _m++;
                    }
                } failure:^(NSError *error) {
                    if (_m==_n) {
                        
                    }else{
                        _m++;
                    }
                    [UIUtils showInfoMessage:@"上传失败,请检查网络"];
                    [self hideHud];
                }];
            }else{
                str = [NSString stringWithFormat:@"%@",_classModel.sclassId];
                NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"9",@"type",@"www",@"description",@"3",@"function",[NSString stringWithFormat:@"%@",str],@"relId",@"1",@"relType",nil];
                [[NetworkRequest sharedInstance] POSTImage:FileUpload filePath:filePath dict:dict succeed:^(id data) {
                    if (_m == _n) {
                        [UIUtils showInfoMessage:@"上传完成"];
                        [self.navigationController popViewControllerAnimated:YES];
                        [self hideHud];
                    }else{
                        _m++;
                    }
                } failure:^(NSError *error) {
                    if (_m==_n) {
                        
                    }else{
                        _m++;
                    }
                    [UIUtils showInfoMessage:@"上传失败，请检查网络"];
                    [self hideHud];
                }];

            }
            
        }
    }
    NSTimer *timer;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(doTime) userInfo:nil repeats:NO];
    
}
-(void)doTime{
    [self hideHud];
    _alter = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"上传完成"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [_alter show];
}
/** 打开文件 @param filePath 文件路径 */
-(void)openDocxWithPath:(NSString *)filePath {
    
    UIDocumentInteractionController *doc= [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    doc.delegate = self;
    
    [doc presentPreviewAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIDocumentInteractionControllerDelegate
//必须实现的代理方法 预览窗口以模式窗口的形式显示，因此需要在该方法中返回一个view controller ，作为预览窗口的父窗口。如果你不实现该方法，或者在该方法中返回 nil，或者你返回的 view controller 无法呈现模式窗口，则该预览窗口不会显示。

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    
    return self;
    
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    
    return self.view;
    
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    
    return CGRectMake(0, 30, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    
}
#pragma mark DataDownloadTableViewCellDelegate

-(void)secondDownloadBtnDelegate:(UIButton *)sender{
    if ((sender.tag-1)<_boolAry.count) {
        if ([_boolAry[sender.tag-1] isEqualToString:@"NO"]) {
            _boolAry[sender.tag-1] = @"Yes";
            _temp++;
            [_sendbtn setBackgroundColor:RGBA_COLOR(32, 170, 238, 1)];
            [_sendbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_sendbtn setTitle:[NSString stringWithFormat:@"发送(%d)",_temp] forState:UIControlStateNormal];
            [_sendbtn setEnabled:YES];

            
        }else{
            _boolAry[sender.tag-1] = @"NO";
            _temp--;
            
            if (_temp == 0) {
                [_sendbtn setBackgroundColor:[UIColor colorWithHexString:@"#f7f7f7"]];
                [_sendbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [_sendbtn setTitle:[NSString stringWithFormat:@"发送"] forState:UIControlStateNormal];
                [_sendbtn setEnabled:NO];
            }else{
                [_sendbtn setTitle:[NSString stringWithFormat:@"发送(%d)",_temp] forState:UIControlStateNormal];
            }
            
        }
        [_tableView reloadData];
    }
}

#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_fileAry.count>0) {
        return _fileAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DataDownloadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DataDownloadTableViewCellSecond"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DataDownloadTableViewCell" owner:self options:nil] objectAtIndex:1];
    }
    cell.delegate = self;
    
    FileModel * f = _fileAry[indexPath.row];
    
    [cell addDownLoadContentView:f withIndex:(int)(indexPath.row+1) withIsSelect:_boolAry[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths lastObject];
    
    FileModel *f = _fileAry[indexPath.row];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"File/%@",f.fileName]]; //docPath为文件名
    
    [self openDocxWithPath:filePath];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
