//
//  Constants.h
//  statslite
//
//  Created by Daniel on 12/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h> 

#ifndef Constants_h
#define Constants_h

/**
 Colors RGB
 **/

#define kColorMenuCellText 0x656565

#define kColorRedStas 0xE00111

#define kColorMenuCell 0xFAFAFA
#define kColorMenuCellSelected 0xDCDCDC

#define kColorMenuHeaderCellA 0xFF1B1B
#define kColorMenuHeaderCellB 0xC81414

/**
 Constants
 **/

#define kNetworkDefaultTimeoutSeconds 60

/** Segue, StoryBoard Identifier **/

#define kSegueIdentifiShowDrawer @"segue_drawer"
#define kSegueIdentifiShowMapButtonSegue @"showMapButtonSegue"

#define kSegueIdentifiShowPhotoButtonSegue @"showPhotoButtonSegue"

#define kStoryboardIdentifierMenu @"MenuTableViewController"

#define kStoryboardIdentifierDrawer @"DrawerController"

#define kStoryboardIdentifierMenu @"MenuTableViewController"
#define kStoryboardIdentifierSignInVC @"SignInViewController"
#define kStoryboardIdentifierCheckInVC @"CheckInViewController"
#define kStoryboardIdentifierCheckInTableVC @"CheckInTableViewController"
#define kStoryboardIdentifierProfileVC @"ProfileViewController"

#define kStoryboardIdentifierMapVC @"MapViewController"

#define kStoryboardIdentifierTrackingVC @"TrackingViewController"

#define kStoryboardIdentifierTrackingGroupVC @"TrackingGroupViewController"

#define kStoryboardMain @"Main"

/** Table Identifier **/

#define kTableViewCellIdentifierMenuList @"MenuTableViewCell"
#define kTableViewCellIdentifierCheckIn @"CheckinTableViewCell"

#define kTableViewCellHeaderIndentifierMenu @"MenuHeaderView"
#define kTableViewCellTitleHeaderIndentifierMenu @"MenuTitleHeaderView"

#define kTableViewCellIndentifierProfileInput @"ProfileInputTableViewCell"
#define kTableViewCellIndentifierHeaderProfileInput @"ImageHeaderView"

#define kTableViewCellHeight 50.0f
#define kTableViewCellHeaderHeightA 165.0f
#define kTableViewCellHeaderHeightB 66.0f

/** Network **/

#define kUrlHost @"http://138.121.170.99:5000"

#define kUrlApiHeaderAuthorization @"Authorization"
#define kUrlApiHeaderPrefix @"Bearer"

#define kUrlApiUser @"api/Usuario"

#define kUrlApiUserParamName @"idusuario"
#define kUrlApiUserParamPass @"clave"
#define kUrlApiUserParamEncrypt @"kencrypt"
#define kUrlApiUserParamEncryptVal @"E546C8DF278CD5931069B522E695D4F2"


#define kUrlApiUserResponseCodeNoUser -1
#define kUrlApiUserResponseCodeNoPass 0
#define kUrlApiUserResponseCodeSuccess 1


#define kUrlApiToken @"api/token"
#define kUrlApiTokenParamName @"username"
#define kUrlApiTokenParamNameVal @"novit"

#define kUrlApiTokenParamPass @"password"
#define kUrlApiTokenParamPassVal @"dhh_n0v1t_dhh"


#define kUrlApiParams @"api/Parametro/7"

#define kUrlApiCheckIn @"api/Marcacion"

#define kUrlApiCheckInParam_idempresa @"idempresa"
#define kUrlApiCheckInParam_idsucursal @"idsucursal"
#define kUrlApiCheckInParam_idhorario @"idhorario"
#define kUrlApiCheckInParam_idturno @"idturno"
#define kUrlApiCheckInParam_idusuario @"idusuario"
#define kUrlApiCheckInParam_idzonahoraria @"idzonahoraria"
#define kUrlApiCheckInParam_sfmarcacion @"sfmarcacion"
#define kUrlApiCheckInParam_tmarcacion @"tmarcacion"
#define kUrlApiCheckInParam_tdispositivo @"tdispositivo"
#define kUrlApiCheckInParam_ip @"ip"
#define kUrlApiCheckInParam_mac @"mac"
#define kUrlApiCheckInParam_latitud @"latitud"
#define kUrlApiCheckInParam_longitud @"longitud"
#define kUrlApiCheckInParam_justificacion @"justificacion"
#define kUrlApiCheckInParam_ucreacion @"ucreacion"

#define kUrlApiCheckInParam_altitud @"altitud"
#define kUrlApiCheckInParam_tplataforma @"tplataforma"
#define kUrlApiCheckInParam_vplataforma @"vplataforma"
#define kUrlApiCheckInParam_valora @"valora"

#define kUrlApiCheckInResponseCodeError0 0
#define kUrlApiCheckInResponseCodeError1 -1
#define kUrlApiCheckInResponseCodeError2 -2

#define kUrlApiProfile @"api/Persona"
#define kUrlApiProfileParam_pnombre @"pnombre"
#define kUrlApiProfileParam_apaterno @"apaterno"
#define kUrlApiProfileParam_amaterno @"amaterno"
#define kUrlApiProfileParam_ecivil @"ecivil"
#define kUrlApiProfileParam_genero @"genero"
#define kUrlApiProfileParam_sfactualizacion @"sfactualizacion"
#define kUrlApiProfileParam_idusuario @"idusuario"

#define kUrlApiProfileParam_idpersona @"idpersona"
#define kUrlApiProfileParam_idpersona_correo @"idpersona_correo"
#define kUrlApiProfileParam_idpersona_telefono @"idpersona_telefono"
#define kUrlApiProfileParam_snombre @"snombre"
#define kUrlApiProfileParam_tnombre @"tnombre"
#define kUrlApiProfileParam_ttelefono @"ttelefono"

#define kUrlApiProfileParam_idoperador @"idoperador"
#define kUrlApiProfileParam_ntelefono @"ntelefono"
#define kUrlApiProfileParam_ncorreo @"ncorreo"

#define kUrlApiProfileResponseCodeError1 -1
#define kUrlApiProfileResponseCodeError2 -2

#define kResponseCodeUnauthorize 401
#define kResponseCodeOk 200
#define kResponseCodeNoInternet 404

/*
 POST /api/Developer/last HTTP/1.1
 Host: 138.121.170.99:5000
 Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJub3ZpdCIsImp0aSI6IjViZjkwNDcxLWY5YjAtNGQ0Yi1hMzNmLWZjZWZlODYwNzFjZCIsImlhdCI6MTQ5NjkzOTEzMiwibmJmIjoxNDk2OTM5MTMyLCJleHAiOjE0OTY5NDI3MzIsImlzcyI6IkV4YW1wbGVJc3N1ZXIiLCJhdWQiOiJFeGFtcGxlQXVkaWVuY2UifQ.L7aLyVmsU1w8SBCLVoWFsbRIoF7eWgQW-j6ox5VBh9U
 Cache-Control: no-cache
 Postman-Token: 246c67b5-79a2-901d-1f53-32b627cb2486
 Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW
 */

#define kUrlApiLastTrackingGroup @"api/Developer/last"

/*
 POST /api/Developer/ HTTP/1.1
 Host: 138.121.170.99:5000
 Content-Type: application/x-www-form-urlencoded
 Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJub3ZpdCIsImp0aSI6IjViZjkwNDcxLWY5YjAtNGQ0Yi1hMzNmLWZjZWZlODYwNzFjZCIsImlhdCI6MTQ5NjkzOTEzMiwibmJmIjoxNDk2OTM5MTMyLCJleHAiOjE0OTY5NDI3MzIsImlzcyI6IkV4YW1wbGVJc3N1ZXIiLCJhdWQiOiJFeGFtcGxlQXVkaWVuY2UifQ.L7aLyVmsU1w8SBCLVoWFsbRIoF7eWgQW-j6ox5VBh9U
 Cache-Control: no-cache
 Postman-Token: 062d9cb1-1b6a-56d8-7b68-6bf3d21a5bb1
 
 idusuario=DHUAMAN&sfecha=07%2F06%2F2017&latitud=lat&longitud=lon&altitud=alt&idgrupotracking=38&tdispositivo=99&tplataforma=99&vplataforma=99&ip=99&mac=00%3A99
 */

#define kUrlApiInsertTracking @"api/Developer/"

#define kUrlInsertTrackingParam_idusuario @"idusuario"
#define kUrlInsertTrackingParam_sfecha @"sfecha"
#define kUrlInsertTrackingParam_latitud @"latitud"
#define kUrlInsertTrackingParam_longitud @"longitud"
#define kUrlInsertTrackingParam_altitud @"altitud"
#define kUrlInsertTrackingParam_idgrupotracking @"idgrupotracking"
#define kUrlInsertTrackingParam_tdispositivo @"tdispositivo"
#define kUrlInsertTrackingParam_tplataforma @"tplataforma"
#define kUrlInsertTrackingParam_vplataforma @"vplataforma"
#define kUrlInsertTrackingParam_ip @"ip"
#define kUrlInsertTrackingParam_mac @"mac"

/**
 
 GET /api/Developer/RLOZA HTTP/1.1
 Host: 138.121.170.99:5000
 Content-Type: application/x-www-form-urlencoded
 Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJub3ZpdCIsImp0aSI6IjhlNjY0NDJjLWIxZDktNGJkNy1iNzM1LWZmYWNlYmQyNTFmNyIsImlhdCI6MTQ5NzAyNzI0MSwibmJmIjoxNDk3MDI3MjQxLCJleHAiOjE0OTcwMzA4NDEsImlzcyI6IkV4YW1wbGVJc3N1ZXIiLCJhdWQiOiJFeGFtcGxlQXVkaWVuY2UifQ.mO214Y3Q5IHI0gvlao1Kr-_EQ7kcd9M8Lkre52kztaE
 Cache-Control: no-cache
 Postman-Token: b4188b8d-fa9e-412e-caf5-f13842970786
 
 **/

#define kUrlApiListTrackingGroup @"api/Developer"

/**
 GET /api/Developer/1/RLOZA/44 HTTP/1.1
 Host: 138.121.170.99:5000
 Content-Type: application/x-www-form-urlencoded
 Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJub3ZpdCIsImp0aSI6IjdjYzNkNWNjLWE3NTctNDBkMi1iYmU1LTQ1MDViYzcyODdkMSIsImlhdCI6MTQ5NzA0Mzg0NywibmJmIjoxNDk3MDQzODQ3LCJleHAiOjE0OTcwNDc0NDcsImlzcyI6IkV4YW1wbGVJc3N1ZXIiLCJhdWQiOiJFeGFtcGxlQXVkaWVuY2UifQ.uwGIQVw8g4LUBQOkuaErUZgTpqH19dPjpr2uqne0ze0
 Cache-Control: no-cache
 Postman-Token: f5b86f26-773f-29b8-d7ea-4f9a823a62ea

 **/

#define kUrlApiDetailListTrackingGroup @"api/Developer/1"

/** JSON **/
#define kJson_Key_access_token @"access_token"

#define kJson_Key_user_info @"user_info"

//#define kJson_Key_checkin_params @"checkin_params"

/** Preferences **/

#define kPrefUserLoged @"user_logged"

/** Functions **/

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define AppDebugECLog(s,...) NSLog(s, ##__VA_ARGS__)
//#define AppDebugECLog(s,...)


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

typedef void (^completionBlock)(void);

inline BOOL isSystemVersionGreatherThanOrEqaulTo(NSString *v) {
    
    return YES;
    //return ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending);
}

static inline id UIStoryboardInstantiateViewControllerWithIdentifier(NSString *storyboarName, NSString *identifier)
{
    
    return [[UIStoryboard storyboardWithName:storyboarName bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}

/** ENUMS **/

//typedef enum : NSUInteger {
//    
//    AlertCodeUserNameError = 10001,
//    AlertCodeUserPassError
//} AlertCode;

#endif /* Constants_h */


