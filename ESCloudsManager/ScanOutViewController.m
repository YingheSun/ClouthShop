//
//  ScanOutViewController.m
//  ESCloudsManager
//
//  Created by 孙滢贺 on 16/7/18.
//  Copyright © 2016年 ESClouds. All rights reserved.
//

#import "ScanOutViewController.h"
#import "ScanOutModel.h"
#import "ScanOutCellTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AudioToolbox/AudioToolbox.h"

@interface ScanOutViewController ()<AVCaptureMetadataOutputObjectsDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSTimer *_timer;
    BOOL  _flag;
    BOOL  _isOn;
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
    AVCaptureSession *_captureSession;
}
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIImageView *redLabel;
@property (nonatomic,strong) UITableView *detailTable;
@property (nonatomic,strong) NSString *orderStr;
@property (nonatomic,strong) NSMutableArray *listArray;

@end

@implementation ScanOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    BOOL cameraIsAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (cameraIsAvailable && authStatus != AVAuthorizationStatusRestricted && authStatus != AVAuthorizationStatusDenied) {
        [self initCapture]; // 启动摄像头
    } else {
        [self alertWithTitle:@"温馨提示" msg:@"请在设置中打开摄像头权限" btnTitle:@"确定"];
    }
    [self SetUpMainView];
    //    [self requestForInOrder:@"7"];
}

-(void)SetUpMainView{
    UIColor *color = kRGBColor(0, 0, 0);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,(kScreenHeight - kScreenWidth * 1.3) / 2 )];
    view.backgroundColor = color;
    view.alpha = 0.5;
    [self.view addSubview:view];
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0,(kScreenHeight - kScreenWidth * 1.3) / 2 + kScreenWidth * 0.3, kScreenWidth, kScreenHeight)];
    viewBottom.backgroundColor = color;
    viewBottom.alpha = 0.5;
    [self.view addSubview:viewBottom];
    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0,(kScreenHeight - kScreenWidth * 1.3) / 2, kScreenWidth * 0.25 , kScreenWidth * 0.3)];
    viewLeft.backgroundColor = color;
    viewLeft.alpha = 0.5;
    [self.view addSubview:viewLeft];
    UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.75,(kScreenHeight - kScreenWidth * 1.3) / 2 , kScreenWidth * 0.25 , kScreenWidth * 0.3)];
    viewRight.backgroundColor = color;
    viewRight.alpha = 0.5;
    [self.view addSubview:viewRight];
    UIView *shortLine1 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.25, (kScreenHeight - kScreenWidth * 1.3) / 2, kScreenWidth * 0.045, kScreenWidth * 0.013)];
    shortLine1.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine1];
    UIView *shortLine2 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.25, (kScreenHeight - kScreenWidth * 1.3) / 2, kScreenWidth * 0.013, kScreenWidth * 0.045)];
    shortLine2.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine2];
    UIView *shortLine3 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.75 - kScreenWidth * 0.013, (kScreenHeight - kScreenWidth * 1.3) / 2, kScreenWidth * 0.013, kScreenWidth * 0.045)];
    shortLine3.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine3];
    UIView *shortLine4 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.75 - kScreenWidth * 0.045, (kScreenHeight - kScreenWidth * 1.3) / 2, kScreenWidth * 0.045, kScreenWidth * 0.013)];
    shortLine4.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine4];
    UIView *shortLine5 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.25, (kScreenHeight - kScreenWidth * 1.3) / 2 + kScreenWidth * 0.3 - kScreenWidth * 0.013, kScreenWidth * 0.045, kScreenWidth * 0.013)];
    shortLine5.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine5];
    UIView *shortLine6 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.25, (kScreenHeight - kScreenWidth * 1.3) / 2 + kScreenWidth * 0.3 - kScreenWidth * 0.045, kScreenWidth * 0.013, kScreenWidth * 0.045)];
    shortLine6.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine6];
    UIView *shortLine7 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.75 - kScreenWidth * 0.013, (kScreenHeight - kScreenWidth * 1.3) / 2 + kScreenWidth * 0.3 - kScreenWidth * 0.045, kScreenWidth * 0.013, kScreenWidth * 0.045)];
    shortLine7.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine7];
    UIView *shortLine8 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.75 - kScreenWidth * 0.045,(kScreenHeight - kScreenWidth * 1.3) / 2 + kScreenWidth * 0.3 - kScreenWidth * 0.013, kScreenWidth * 0.045, kScreenWidth * 0.013)];
    shortLine8.backgroundColor = kRGBColor(255,255,255);
    [self.view addSubview:shortLine8];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"将条码放入框内扫码";
    label.frame = CGRectMake(0, 10, kScreenWidth, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    [viewBottom addSubview:label];
    
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, kYHeight(shortLine8) + 50, kScreenWidth, (kScreenHeight-kYHeight(shortLine8)) - 50)];
    //downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downView];
    
    UIButton *detailButton = [[UIButton alloc]initWithFrame:CGRectMake(0 , kHeight(downView) -50 , kScreenWidth / 2, 50)];
    [detailButton setTitle:@"详细" forState:UIControlStateNormal];
    
    [downView addSubview:detailButton];
    
    UIButton *commitButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth / 2, kHeight(downView) -50 , kScreenWidth / 2, 50)];
    [commitButton setTitle:@"下一步" forState:UIControlStateNormal];
    [downView addSubview:commitButton];
    
    //返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10,30, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"JS0301"] forState:0];
    button.alpha = 1;
    [view addSubview:button];
    
    UIButton *upButton = [[UIButton alloc] init];
    upButton.frame = CGRectMake(10, 20, 40, 40);
    upButton.backgroundColor = [UIColor clearColor];
    [upButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:1<<6];
    [view addSubview:upButton];
    [button addTarget:self action:@selector(leftButtonClicked) forControlEvents:1<<6];
    //闪光灯打开按钮
    //    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightButton.frame = CGRectMake(kScreenWidth - 40,30, 40, 22);
    //    rightButton.alpha = 0.5 ;
    //    [rightButton setBackgroundImage:[UIImage imageNamed:@"JS0302"] forState:0];
    //    [view addSubview:rightButton];
    //    _isOn = NO;
    //    [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:1<<6];
    //    [self rightButtonClicked];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    static dispatch_once_t onceTaken;
    _flag = NO;
    dispatch_once(&onceTaken,^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(viewMove) userInfo:nil repeats:YES];
    });
    _redLabel = [[UIImageView alloc] init];
    _redLabel.image = [UIImage imageNamed:@"JS0303"];
    _redLabel.frame = CGRectMake(kScreenWidth * 0.25 + kScreenWidth * 0.013, (kScreenHeight - kScreenWidth * 1.3) / 2 + kScreenWidth * 0.013,kScreenWidth  * 0.5 - kScreenWidth * 0.026, kScreenWidth * 0.0106);
    [self.view addSubview:_redLabel];
}

-(void)viewMove{
    if (_flag == YES) {
        [UIView animateWithDuration:2.9 animations:^{
            _redLabel.frame = CGRectMake(kScreenWidth * 0.25 + kScreenWidth * 0.013, (kScreenHeight - kScreenWidth * 1.3) / 2 + kScreenWidth * 0.013,kScreenWidth  * 0.5 - kScreenWidth * 0.026, kScreenWidth * 0.0106);
        }];
        
    }else{
        [UIView animateWithDuration:2.9 animations:^{
            _redLabel.frame = CGRectMake(kScreenWidth * 0.25 + kScreenWidth * 0.013, (kScreenHeight - kScreenWidth * 1.3) / 2 + kScreenWidth * 0.3 - kScreenWidth * 0.013,kScreenWidth  * 0.5 - kScreenWidth * 0.026, kScreenWidth * 0.0106);
        }];
    }
    _flag = !_flag;
}

-(void)leftButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initCapture {
    // capture session 数据的捕获,操作,输出
    _captureSession = [[AVCaptureSession alloc] init];
    // 捕获设备,这里是摄像头
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //    AVCaptureDevice *inputDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    // 捕获设备的输入
    NSError *error = nil;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if (!error) {
        // 正常捕获数据
        [_captureSession addInput:captureInput]; // 将输入添加到session上
    } else {
        // 捕获数据失败
        [self alertWithTitle:@"警告" msg:@"手机摄像头捕获图像出现故障,请检查权限设置!" btnTitle:@"确定"];
    }
    if (IOS7) {
        // 捕获到的数据的输出
        AVCaptureMetadataOutput *captureOutput = [[AVCaptureMetadataOutput alloc] init];
        [captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        CGSize size = self.view.bounds.size;
        CGRect cropRect = CGRectMake(87, 100, 240, 240);
        CGFloat p1 = size.height/size.width;
        CGFloat p2 = 1920./1080.; //使用了1080p的图像输出
        if (p1 < p2) {
            CGFloat fixHeight = self.view.bounds.size.width * 1920. / 1080.;
            CGFloat fixPadding = (fixHeight - size.height)/2;
            captureOutput.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight, cropRect.origin.x/size.width, cropRect.size.height/fixHeight, cropRect.size.width/size.width);
        } else {
            CGFloat fixWidth = self.view.bounds.size.height * 1080. / 1920.;
            CGFloat fixPadding = (fixWidth - size.width)/2;
            captureOutput.rectOfInterest = CGRectMake(cropRect.origin.y/size.height, (cropRect.origin.x + fixPadding)/fixWidth, cropRect.size.height/size.height, cropRect.size.width/fixWidth);
        }
        
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        [_captureSession addOutput:captureOutput];
        captureOutput.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        if (!_captureVideoPreviewLayer) {
            _captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
        }
        _captureVideoPreviewLayer.frame = self.view.bounds;
        _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:_captureVideoPreviewLayer];
        [_captureSession startRunning];
    }
}

- (void)alertWithTitle:(NSString *)titleStr msg:(NSString *)msgStr btnTitle:(NSString *)btnTitle {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:titleStr message:msgStr delegate:self cancelButtonTitle:btnTitle otherButtonTitles:nil, nil];
    av.tag = 1000;
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSLog(@"扫描页面里的扫描结果输出:%@", metadataObject.stringValue);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self requestForScanOut:metadataObject.stringValue];
    }
    [_captureSession stopRunning];
    //[self.navigationController popViewControllerAnimated:YES];
}

//重构，订单生成后置
/*
 -(void)requestForInOrder:(NSString *)StoreidStr{
 NSDictionary *dic = @{@"storeid"  : StoreidStr};
 [XSHttpTool GET:@"Order.Createinorder" param:dic success:^(id responseObject) {
 //kPNone(@"正在创建订单，请稍后...");
 NSDictionary *jsonDic = [[NSDictionary alloc]init];
 jsonDic = responseObject;
 NSLog(@"请求入库订单号返回json：%@",jsonDic);
 if ([jsonDic[@"ret"] intValue] == 200) {
 NSLog(@"入库订单号请求成功:%@",jsonDic[@"data"]);
 _orderStr = jsonDic[@"data"];
 //kPSuccess();
 kPdismiss;
 }else{
 kPError(jsonDic[@"msg"]);
 }
 } failure:^(NSError *error) {
 kPError(@"打卡失败");
 }];
 }*/

-(void)requestForScanOut:(NSString *)barcode{
    NSDictionary *dic = @{
                          @"storeId" : @"1",
                          @"barcode" : barcode,
                          @"uuid" : [[[UIDevice currentDevice] identifierForVendor] UUIDString]
                          };
    [XSHttpTool GET:@"StockInStack.AddToStack" param:dic success:^(id responseObject) {
        NSDictionary *jsonDic = [[NSDictionary alloc]init];
        jsonDic = responseObject;
        NSLog(@"扫描返回json：%@",jsonDic);
        if ([jsonDic[@"ret"] intValue] == 200) {
            NSLog(@"扫描成功：%@",barcode);
            _listArray = [[NSMutableArray alloc] initWithCapacity:0];
            [_listArray addObjectsFromArray:[ScanOutModel objectArrayWithKeyValuesArray:jsonDic[@"data"]]];
            if (!_detailTable) {
                [self createDetailTable];
            }
            [_detailTable reloadData];
            [_captureSession startRunning];
            //kPSuccess();
        }else{
            kPError(jsonDic[@"msg"]);
        }
    } failure:^(NSError *error) {
        kPError(@"扫描失败");
    }];
}

-(void)createDetailTable{
    _detailTable = [[UITableView alloc]init];
    //_detailTable.backgroundColor = [UIColor blueColor];
    _detailTable.delegate = self;
    _detailTable.dataSource = self;
    _detailTable.scrollEnabled = NO;
    [self.view addSubview:_detailTable];
    [_detailTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-50);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(5 * 46);
    }];
    _detailTable.backgroundColor = [UIColor clearColor];
    _detailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_detailTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_detailTable registerClass:[ScanOutCellTableViewCell class] forCellReuseIdentifier:@"cellID"];
    
    UILabel *barcodeLabel = [[UILabel alloc]init];
    UILabel *goodnameLabel = [[UILabel alloc]init];
    UILabel *numberLabel = [[UILabel alloc]init];
    [self.view addSubview:barcodeLabel];
    [self.view addSubview:goodnameLabel];
    [self.view addSubview:numberLabel];
    barcodeLabel.textColor = [UIColor whiteColor];
    goodnameLabel.textColor = [UIColor whiteColor];
    numberLabel.textColor = [UIColor whiteColor];
    barcodeLabel.text = @"条码号";
    goodnameLabel.text = @"名称";
    numberLabel.text = @"数量";
    [barcodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_detailTable).with.offset(-220);
        make.left.equalTo(self.view).with.offset(20);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(46);
    }];
    [goodnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_detailTable).with.offset(-220);
        make.left.equalTo(self.view).with.offset(kScreenWidth / 3 + 40);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(46);
    }];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_detailTable).with.offset(-220);
        make.left.equalTo(self.view).with.offset(kScreenWidth * 5 / 6 );
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(46);
    }];
    UILabel *tableLine = [[UILabel alloc]init];
    tableLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableLine];
    [tableLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailTable).with.offset(-3);
        make.left.equalTo(self.view).with.offset(10);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
    
    
}

#pragma mark -UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 44;
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    ScanOutCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.backgroundColor = [UIColor clearColor];
    ScanOutModel *model = _listArray[indexPath.row];
    [cell getInformation:model];
    return cell;
}

@end
