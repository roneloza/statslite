//
//  CheckInItem.h
//  statslite
//
//  Created by Daniel on 4/19/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "Item.h"

/**
 
 {
 "idmarcacion": 459,
 "idempresa": 0,
 "idsucursal": 0,
 "idhorario": 0,
 "idturno": 0,
 "idusuario": "DHUAMAN",
 "idzonahoraria": 0,
 "fmarcacion": "2017-04-18T12:08:06",
 "sfmarcacion": null,
 "sFecha": null,
 "tmarcacion": 21,
 "tdispositivo": 35,
 "ip": "0.0.0.0",
 "mac": "00:00:00:00",
 "latitud": "-12.097183",
 "longitud": "-77.032585",
 "dia": null,
 "mes": null,
 "ano": null,
 "justificacion": "mi entrada es a la hora que llego.",
 "cestado": 0,
 "ucreacion": null,
 "fcreacion": "0001-01-01T00:00:00",
 "uactualizacion": null,
 "factualizacion": "0001-01-01T00:00:00",
 "nomempresa": "Ninguno",
 "nomsucursal": "Ninguno",
 "nomhorario": "Ninguno",
 "nomturno": "Ninguno",
 "nomtmarcacion": "Inicio Refrigerio",
 "nomtdispositivo": "Movil (iPhone)",
 "nombrecompleto": null,
 "altitud": "0.000000",
 "tplataforma": 38,
 "vplataforma": "8.1",
 "tnavegador": 0,
 "vnavegador": "",
 "valora": "0",
 "valorb": "",
 "valorc": "",
 "nomtplataforma": "iOS",
 "nomtnavegador": ""
 }
 
 **/

@interface CheckInItem : Item

@property (nonatomic, strong) NSNumber *idmarcacion;
@property (nonatomic, strong) NSNumber *idempresa;
@property (nonatomic, strong) NSNumber *idsucursal;
@property (nonatomic, strong) NSNumber *idhorario;
@property (nonatomic, strong) NSNumber *idturno;

@property (nonatomic, strong) NSString *idusuario;

@property (nonatomic, strong) NSNumber *idzonahoraria;
@property (nonatomic, strong) NSString *fmarcacion;
@property (nonatomic, strong) NSString *sfmarcacion;
@property (nonatomic, strong) NSString *sFecha;

@property (nonatomic, strong) NSNumber *tmarcacion;
@property (nonatomic, strong) NSNumber *tdispositivo;

@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *latitud;
@property (nonatomic, strong) NSString *longitud;

@property (nonatomic, strong) NSString *dia;
@property (nonatomic, strong) NSString *mes;
@property (nonatomic, strong) NSString *ano;
@property (nonatomic, strong) NSString *justificacion;

@property (nonatomic, strong) NSNumber *cestado;

@property (nonatomic, strong) NSString *ucreacion;
@property (nonatomic, strong) NSString *fcreacion;
@property (nonatomic, strong) NSString *uactualizacion;
@property (nonatomic, strong) NSString *factualizacion;
@property (nonatomic, strong) NSString *nomempresa;
@property (nonatomic, strong) NSString *nomsucursal;
@property (nonatomic, strong) NSString *nomhorario;
@property (nonatomic, strong) NSString *nomturno;
@property (nonatomic, strong) NSString *nomtmarcacion;
@property (nonatomic, strong) NSString *nomtdispositivo;
@property (nonatomic, strong) NSString *nombrecompleto;
@property (nonatomic, strong) NSString *altitud;

@property (nonatomic, strong) NSNumber *tplataforma;
@property (nonatomic, strong) NSString *vplataforma;

@property (nonatomic, strong) NSNumber *tnavegador;

@property (nonatomic, strong) NSString *vnavegador;
@property (nonatomic, strong) NSString *valora;
@property (nonatomic, strong) NSString *valorb;
@property (nonatomic, strong) NSString *valorc;
@property (nonatomic, strong) NSString *nomtplataforma;
@property (nonatomic, strong) NSString *nomtnavegador;

@property (nonatomic, assign) double heightCell;
@property (nonatomic, assign) double newHeightCell;

@property (nonatomic, assign) double heightTextViewFix;
@end
