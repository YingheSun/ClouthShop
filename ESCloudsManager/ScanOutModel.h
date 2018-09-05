//
//  ScanOutModel.h
//  ESCloudsManager
//
//  Created by Yinghe Sun on 17/2/4.
//  Copyright © 2017年 ESClouds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanOutModel : NSObject

@property( nonatomic , copy ) NSString *id;
@property( nonatomic , copy ) NSString *uuid;
@property( nonatomic , copy ) NSString *barcode;
@property( nonatomic , copy ) NSString *name;
@property( nonatomic , copy ) NSString *number;
@property( nonatomic , copy ) NSString *account;
@property( nonatomic , copy ) NSString *scantype;
@property( nonatomic , copy ) NSString *time;
@property( nonatomic , copy ) NSString *comp_id;
@property( nonatomic , copy ) NSString *store_id;
@property( nonatomic , copy ) NSString *price;
@property( nonatomic , copy ) NSString *cost;

@end
