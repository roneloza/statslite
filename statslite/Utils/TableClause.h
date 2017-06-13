//
//  TableClause.h
//  sgs
//
//  Created by rone loza on 5/24/17.
//  Copyright © 2017 Novit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableClause : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;

@property (nonatomic, strong) NSString *operatorCondition;
@property (nonatomic, strong) NSString *operatorExpression;

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value operatorCondition:(NSString *)operatorCondition operatorExpression:(NSString *)operatorExpression;

@end
