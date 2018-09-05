//
//  TopologyModel.h
//  ESCloudsManager
//
//  Created by Yinghe Sun on 17/1/19.
//  Copyright © 2017年 ESClouds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopologyModel : NSObject
@property( nonatomic , copy ) NSString *actionId;
@property( nonatomic , copy ) NSString *actionName;
@property( nonatomic , copy ) NSString *authId;
@property( nonatomic , copy ) NSString *authName;
@property( nonatomic , copy ) NSString *compId;
@property( nonatomic , copy ) NSString *compName;
@property( nonatomic , copy ) NSString *dutyId;
@property( nonatomic , copy ) NSString *dutyName;
@property( nonatomic , copy ) NSString *groupId;
@property( nonatomic , copy ) NSString *groupName;
@property( nonatomic , copy ) NSString *orgId;
@property( nonatomic , copy ) NSString *orgName;
@property( nonatomic , copy ) NSString *postId;
@property( nonatomic , copy ) NSString *postName;
@property( nonatomic , copy ) NSString *userId;
@property( nonatomic , copy ) NSString *userName;
@end
