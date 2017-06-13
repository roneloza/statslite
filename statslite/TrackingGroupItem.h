//
//  TrackingGroupItem.h
//  statslite
//
//  Created by rone loza on 6/9/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "Item.h"

/*
 {
 "iddev_tracking": 0,
 "idusuario": "RLOZA",
 "fecha": "2017-06-08T05:28:16",
 "tfecha": "08/06/2017",
 "thoras": "05:28:16",
 "sfecha": null,
 "latitud": "-12.070222",
 "longitud": "-77.035529",
 "altitud": "0.000000",
 "idgrupotracking": 44,
 "tdispositivo": 0,
 "tplataforma": 0,
 "vplataforma": "8.1",
 "ip": "0.0.0.0",
 "mac": "00:00:00:00",
 "nomtdispositivo": "Movil (iPhone)",
 "nomtplataforma": "iOS"
 }
 */
@interface TrackingGroupItem : Item

@property (nonatomic, strong) NSNumber *iddev_tracking;
@property (nonatomic, strong) NSString *idusuario;
@property (nonatomic, strong) NSString *fecha;
@property (nonatomic, strong) NSString *tfecha;
@property (nonatomic, strong) NSString *thoras;
@property (nonatomic, strong) NSString *sfecha;
@property (nonatomic, strong) NSString *latitud;
@property (nonatomic, strong) NSString *longitud;
@property (nonatomic, strong) NSString *altitud;
@property (nonatomic, strong) NSNumber *idgrupotracking;
@property (nonatomic, strong) NSNumber *tdispositivo;
@property (nonatomic, strong) NSNumber *tplataforma;
@property (nonatomic, strong) NSString *vplataforma;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *nomtdispositivo;
@property (nonatomic, strong) NSString *nomtplataforma;

@end
