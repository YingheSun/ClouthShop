//
//  MainViewController.m
//  ESCloudsManager
//
//  Created by 孙滢贺 on 16/7/15.
//  Copyright © 2016年 ESClouds. All rights reserved.
//

#import "MainViewController.h"
#import "CardInViewController.h"
#import "ScanInViewController.h"
#import "GoodsInfoViewController.h"
#import "TopologyModel.h"

@interface MainViewController ()
@property (nonatomic,strong) NSMutableArray *listArray;
    
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self getPostTopology];
    [self setUpMainView];
}

-(void)getPostTopology{
    NSDictionary *dic = @{
                          @"uuid" : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                          };
    [XSHttpTool POST:@"PostTopology.GetTopology" param:dic success:^(id responseObject) {
        NSDictionary *jsonDic = responseObject;
        NSLog(@"返回json：%@",jsonDic);
        if ([jsonDic[@"ret"] intValue] == 200) {
            NSLog(@"获取岗位拓扑%@",jsonDic);
            _listArray = [[NSMutableArray alloc] initWithCapacity:0];
            [_listArray addObjectsFromArray:[TopologyModel objectArrayWithKeyValuesArray:jsonDic[@"data"]]];
            [self setTopology];
//            NSString *scanTopo = kgetLocalData(kScanTopology);
//            NSLog(@"%@",scanTopo);
        }else{
            kPError(jsonDic[@"msg"]);
        }
    } failure:^(NSError *error) {
        kPError(@"打卡失败");
    }];

}

-(void)setTopology{
    for (int i = 0; i < _listArray.count; i++) {
        TopologyModel *detailInfo = _listArray[i];
            NSLog(@"处理拓扑%@->%@->%@->%@->%@->%@->%@",detailInfo.compName,detailInfo.orgName,detailInfo.groupName,detailInfo.postName,detailInfo.dutyName,detailInfo.actionName,detailInfo.authName);
//        if([detailInfo.actionName isEqualToString:@"扫码"]){
//            NSLog(@"保存拓扑%@",detailInfo.actionName);
//            ksaveLocal(kScanCardTopology, detailInfo.actionName);
//        }
            NSLog(@"保存拓扑%@->%@->%@->%@->%@->%@->%@",detailInfo.compName,detailInfo.orgName,detailInfo.groupName,detailInfo.postName,detailInfo.dutyName,detailInfo.actionName,detailInfo.authName);
        
    }
}

-(void)setUpMainView{
    UIColor *backgroundColor = kRGBColor(224 , 240, 233);
    [self.view setBackgroundColor:backgroundColor];
    
    UIImageView *topImage = [[UIImageView alloc]init];
    [self.view addSubview:topImage];
    topImage.image = [UIImage imageNamed:@"JS0201"];
    //topImage.backgroundColor = [UIColor greenColor];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    UIImageView *cardInImg = [[UIImageView alloc]init];
    [self.view addSubview:cardInImg];
    cardInImg.image = [UIImage imageNamed:@"JS0202"];
    //cardInImg.backgroundColor = [UIColor redColor];
    [cardInImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(-kWidth(self.view)/4);
        make.top.equalTo(topImage).with.offset(50 + (kHeight(self.view)-74)/16);
        make.height.mas_equalTo((kHeight(self.view)-74)/8);
        make.width.mas_equalTo((kHeight(self.view)-74)/8);
    }];
    
    UILabel *cardInText = [[UILabel alloc]init];
    [self.view addSubview:cardInText];
    cardInText.text = @"打卡";
    //cardInText.backgroundColor = [UIColor blueColor];
    cardInText.textAlignment = NSTextAlignmentCenter;
    [cardInText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cardInImg);
        //make.centerY.equalTo(cardInImg);
        make.top.equalTo(cardInImg).with.offset(5 + (kHeight(self.view)-74)/8);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(100);
        //make.width.mas_equalTo(kWidth(topImage));
    }];
    
    UIImageView *shopImg = [[UIImageView alloc]init];
    [self.view addSubview:shopImg];
    //shopImg.backgroundColor = [UIColor redColor];
    shopImg.image = [UIImage imageNamed:@"JS0203"];
    [shopImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(kWidth(self.view)/4);
        make.top.equalTo(topImage).with.offset(50 + (kHeight(self.view)-74)/16);
        make.height.mas_equalTo((kHeight(self.view)-74)/8);
        make.width.mas_equalTo((kHeight(self.view)-74)/8);
    }];
    
    UILabel *shopText = [[UILabel alloc]init];
    [self.view addSubview:shopText];
    shopText.text = @"商品";
    //cardInText.backgroundColor = [UIColor blueColor];
    shopText.textAlignment = NSTextAlignmentCenter;
    [shopText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shopImg);
        //make.centerY.equalTo(cardInImg);
        make.top.equalTo(shopImg).with.offset(5 + (kHeight(self.view)-74)/8);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(100);
        //make.width.mas_equalTo(kWidth(topImage));
    }];
    
    UIView *lineOne = [[UIView alloc]init];
    [self.view addSubview:lineOne];
    lineOne.backgroundColor = kSepareLineColor;
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardInImg).with.offset(30 + (kHeight(self.view)-74)/8);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(kWidth(self.view));
    }];
    
    UIImageView *scanInImg = [[UIImageView alloc]init];
    [self.view addSubview:scanInImg];
    //scanInImg.backgroundColor = [UIColor redColor];
    scanInImg.image = [UIImage imageNamed:@"JS0204"];
    [scanInImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cardInImg);
        make.top.equalTo(lineOne).with.offset((kHeight(self.view)-74)/16);
        make.height.mas_equalTo((kHeight(self.view)-74)/8);
        make.width.mas_equalTo((kHeight(self.view)-74)/8);
    }];
    
    UILabel *scanInText = [[UILabel alloc]init];
    [self.view addSubview:scanInText];
    scanInText.text = @"入库";
    //cardInText.backgroundColor = [UIColor blueColor];
    scanInText.textAlignment = NSTextAlignmentCenter;
    [scanInText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scanInImg);
        //make.centerY.equalTo(cardInImg);
        make.top.equalTo(scanInImg).with.offset(5 + (kHeight(self.view)-74)/8);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(100);
        //make.width.mas_equalTo(kWidth(topImage));
    }];
    
    UIView *lineTwo = [[UIView alloc]init];
    [self.view addSubview:lineTwo];
    lineTwo.backgroundColor = kSepareLineColor;
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanInImg).with.offset(30 + (kHeight(self.view)-74)/8);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(kWidth(self.view)/2);
    }];
    
    UIImageView *scanOutImg = [[UIImageView alloc]init];
    [self.view addSubview:scanOutImg];
    //scanOutImg.backgroundColor = [UIColor redColor];
    scanOutImg.image = [UIImage imageNamed:@"JS0205"];
    [scanOutImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scanInImg);
        make.top.equalTo(lineTwo).with.offset((kHeight(self.view)-74)/16);
        make.height.mas_equalTo((kHeight(self.view)-74)/8);
        make.width.mas_equalTo((kHeight(self.view)-74)/8);
    }];
    
    UILabel *scanOutText = [[UILabel alloc]init];
    [self.view addSubview:scanOutText];
    scanOutText.text = @"出库";
    //cardInText.backgroundColor = [UIColor blueColor];
    scanOutText.textAlignment = NSTextAlignmentCenter;
    [scanOutText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scanOutImg);
        //make.centerY.equalTo(cardInImg);
        make.top.equalTo(scanOutImg).with.offset(5 + (kHeight(self.view)-74)/8);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(100);
        //make.width.mas_equalTo(kWidth(topImage));
    }];
    
    UIView *lineThree = [[UIView alloc]init];
    [self.view addSubview:lineThree];
    lineThree.backgroundColor = kSepareLineColor;
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanOutImg).with.offset(30 + (kHeight(self.view)-74)/8);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(kWidth(self.view));
    }];
    
    UIView *lineY = [[UIView alloc]init];
    [self.view addSubview:lineY];
    lineY.backgroundColor = kSepareLineColor;
    [lineY mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne);
        make.centerX.equalTo(lineOne);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(2);
    }];
    
    UIImageView *manageImg = [[UIImageView alloc]init];
    [self.view addSubview:manageImg];
    //manageImg.backgroundColor = [UIColor redColor];
    manageImg.image = [UIImage imageNamed:@"JS0206"];
    [manageImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shopImg);
        make.top.equalTo(lineOne).with.offset((kHeight(self.view)-74)/7);
        make.height.mas_equalTo((kHeight(self.view)-74)/8);
        make.width.mas_equalTo((kHeight(self.view)-74)/8);
    }];
    
    UILabel *manageText = [[UILabel alloc]init];
    [self.view addSubview:manageText];
    manageText.text = @"管理";
    //cardInText.backgroundColor = [UIColor blueColor];
    manageText.textAlignment = NSTextAlignmentCenter;
    [manageText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(manageImg);
        //make.centerY.equalTo(cardInImg);
        make.top.equalTo(manageImg).with.offset(10 + (kHeight(self.view)-74)/8);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(100);
        //make.width.mas_equalTo(kWidth(topImage));
    }];
    
    UIImageView *setImg = [[UIImageView alloc]init];
    [self.view addSubview:setImg];
    //setImg.backgroundColor = [UIColor redColor];
    setImg.image = [UIImage imageNamed:@"JS0208"];
    [setImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scanInImg);
        make.top.equalTo(lineThree).with.offset((kHeight(self.view)-74)/16);
        make.height.mas_equalTo((kHeight(self.view)-74)/8);
        make.width.mas_equalTo((kHeight(self.view)-74)/8);
    }];
    
    UILabel *setText = [[UILabel alloc]init];
    [self.view addSubview:setText];
    setText.text = @"设置";
    //cardInText.backgroundColor = [UIColor blueColor];
    setText.textAlignment = NSTextAlignmentCenter;
    [setText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(setImg);
        //make.centerY.equalTo(cardInImg);
        make.top.equalTo(setImg).with.offset(10 + (kHeight(self.view)-74)/8);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(100);
        //make.width.mas_equalTo(kWidth(topImage));
    }];
    
    UIImageView *myImg = [[UIImageView alloc]init];
    [self.view addSubview:myImg];
    //myImg.backgroundColor = [UIColor redColor];
    myImg.image = [UIImage imageNamed:@"JS0207"];
    [myImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shopImg);
        make.top.equalTo(lineThree).with.offset((kHeight(self.view)-74)/16);
        make.height.mas_equalTo((kHeight(self.view)-74)/8);
        make.width.mas_equalTo((kHeight(self.view)-74)/8);
    }];
    
    UILabel *myText = [[UILabel alloc]init];
    [self.view addSubview:myText];
    myText.text = @"我的";
    //cardInText.backgroundColor = [UIColor blueColor];
    myText.textAlignment = NSTextAlignmentCenter;
    [myText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(myImg);
        //make.centerY.equalTo(cardInImg);
        make.top.equalTo(myImg).with.offset(10 + (kHeight(self.view)-74)/8);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(100);
        //make.width.mas_equalTo(kWidth(topImage));
    }];
    
    UIButton *cardInButton = [[UIButton alloc]init];
    [self.view addSubview:cardInButton];
    [cardInButton addTarget:self action:@selector(cardInClicked) forControlEvents:UIControlEventTouchUpInside];
    [cardInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage).with.offset(50);
        make.bottom.equalTo(lineOne);
        make.left.equalTo(self.view);
        make.centerX.equalTo(cardInImg);
    }];
    
    UIButton *goodsInfoButton = [[UIButton alloc]init];
    [self.view addSubview:goodsInfoButton];
    [goodsInfoButton addTarget:self action:@selector(goodsClicked) forControlEvents:UIControlEventTouchUpInside];
    [goodsInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage).with.offset(50);
        make.bottom.equalTo(lineOne);
        make.right.equalTo(self.view);
        make.centerX.equalTo(shopImg);
        //make.width.mas_equalTo(kWidth(topImage));
    }];
    
    
    UIButton *scanInButton = [[UIButton alloc]init];
    [self.view addSubview:scanInButton];
    [scanInButton addTarget:self action:@selector(scanInClicked) forControlEvents:UIControlEventTouchUpInside];
    [scanInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne).with.offset(50);
        make.bottom.equalTo(lineTwo);
        make.left.equalTo(self.view);
        make.centerX.equalTo(cardInImg);
    }];
    
    UIButton *sellButton = [[UIButton alloc]init];
    [self.view addSubview:sellButton];
    [sellButton addTarget:self action:@selector(sellClicked) forControlEvents:UIControlEventTouchUpInside];
    [sellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTwo).with.offset(50);
        make.bottom.equalTo(lineThree);
        make.left.equalTo(self.view);
        make.centerX.equalTo(cardInImg);
    }];
    
    
}

-(void)cardInClicked{
    NSLog(@"跳往打卡模块");
    
    CardInViewController *CardInVC = [[CardInViewController alloc] init];
    [self.navigationController pushViewController:CardInVC animated:true];
}

-(void)scanInClicked{
    NSLog(@"跳往入库模块");
    ScanInViewController *ScanInVC = [[ScanInViewController alloc]init];
    [self.navigationController pushViewController:ScanInVC animated:true];
}

-(void)sellClicked{
    NSLog(@"跳往销售出库模块");
}

-(void)goodsClicked{
    NSLog(@"跳往商品信息模块");
    GoodsInfoViewController *GoodsInfoVC = [[GoodsInfoViewController alloc]init];
    [self.navigationController pushViewController:GoodsInfoVC animated:true];
}


@end
