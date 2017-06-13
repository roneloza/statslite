//
//  ParamInput.h
//  statslite
//
//  Created by Daniel on 12/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "Item.h"

/*
 {
 "idparametro": 7,
 "idparametrodetalle": 20,
 "nombre": "Ingreso Laboral",
 "descripcion": "",
 "valora": "0",
 "valorb": "0",
 "valorc": "¿Deseas registrar tu ingreso laboral?",
 "valord": "1",
 "valore": "¡Registro exitoso!",
 "valorf": ""
 }
 */
@interface ParamInput : Item

@property (nonatomic, strong) NSNumber *idparametro;
@property (nonatomic, strong) NSNumber *idparametrodetalle;
@property (nonatomic, strong) NSString *nombre;

@property (nonatomic, strong) NSString *descripcion;
@property (nonatomic, strong) NSString *valora;
@property (nonatomic, strong) NSString *valorb;
@property (nonatomic, strong) NSString *valorc;
@property (nonatomic, strong) NSString *valord;
@property (nonatomic, strong) NSString *valore;
@property (nonatomic, strong) NSString *valorf;

@end
