//
//  UserProfile.h
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "Item.h"

@interface UserProfile : Item

@property (nonatomic, strong) NSString *idusuario;
@property (nonatomic, strong) NSString *clave;

@property (nonatomic, assign) NSInteger idpersona;
@property (nonatomic, strong) NSString *pnombre;
@property (nonatomic, strong) NSString *snombre;
@property (nonatomic, strong) NSString *tnombre;
@property (nonatomic, strong) NSString *apaterno;
@property (nonatomic, strong) NSString *amaterno;
@property (nonatomic, strong) NSString *acasado;
@property (nonatomic, strong) NSString *nombrecompleto;
@property (nonatomic, strong) NSString *ncorreo;
@property (nonatomic, strong) NSString *ntelefono;
@property (nonatomic, assign) NSInteger genero;
@property (nonatomic, strong) NSString *nomgenero;
@property (nonatomic, assign) NSInteger ecivil;
@property (nonatomic, strong) NSString *nomecivil;

@property (nonatomic, strong) NSString *kencrypt;

@property (nonatomic, assign) NSInteger ibloqueo;
@property (nonatomic, assign) NSInteger idperfil;
@property (nonatomic, strong) NSString *nomperfil;
@property (nonatomic, assign) NSInteger idzonahoraria;
@property (nonatomic, strong) NSString *nomzonahoraria;
@property (nonatomic, assign) NSInteger idpersona_correo;
@property (nonatomic, assign) NSInteger idpersona_telefono;

@property (nonatomic, assign) NSInteger ttelefono;
@property (nonatomic, assign) NSInteger idoperador;

@property (nonatomic, strong) NSString *sfactualizacion;
@property (nonatomic, strong) NSString *nclave;

@end
