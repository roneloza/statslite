//
//  Item.h
//  statslite
//
//  Created by rone shender loza aliaga on 4/16/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObjectInspectRuntime <NSObject>

/**
 *@brief
 *NSArray of *NSString describing the properties names declared by the class
 
 *@return
 *NSArray of *NSString
**/
@property (nonatomic, strong) NSArray *propertyListClassNames;

/**
 *@brief
 *NSArray of @ctype(id) describing the properties values declared by the class
 
 *@return
 *NSArray of *NSString
 **/
@property (nonatomic, strong) NSArray *propertyListClassValues;

/**
 *@brief
 *NSDictionary of @ctype(id) describing the properties names & values declared by the class
 
 *@return
 *NSArray of *NSString
 **/
@property (nonatomic, strong) NSDictionary *propertyKeyPairs;

@end

@interface Item : NSObject<NSCopying, NSCoding, ObjectInspectRuntime>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, strong) NSString *storyBoarID;
@property (nonatomic, strong) NSString *imageNamed;
@property (nonatomic, strong) NSString *key;

- (id)initWithTitle:(NSString *)title content:(NSString *)content;
- (id)initWithTitle:(NSString *)title content:(NSString *)content enabled:(BOOL)enabled;
- (id)initWithTitle:(NSString *)title content:(NSString *)content enabled:(BOOL)enabled storyBoarID:(NSString *)storyBoarID;
- (id)initWithTitle:(NSString *)title content:(NSString *)content enabled:(BOOL)enabled storyBoarID:(NSString *)storyBoarID imageNamed:(NSString *)imageNamed;
- (id)initWithTitle:(NSString *)title content:(NSString *)content enabled:(BOOL)enabled imageNamed:(NSString *)imageNamed;
- (id)initWithTitle:(NSString *)title content:(NSString *)content enabled:(BOOL)enabled key:(NSString *)key;

- (id)copyWithZone:(NSZone *)zone;

@end
