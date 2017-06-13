//
//  FireBaseManager.m
//  statslite
//
//  Created by rone shender loza aliaga on 4/15/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "FireBaseManager.h"
#import "PreferencesManager.h"

#import <FirebaseStorage/FirebaseStorage.h>
#import <FirebaseInstanceID/FirebaseInstanceID.h>

@implementation FireBaseManager

+ (void)uploadPathFile:(NSString *)pathFile fromData:(NSData *)data completion:(void (^)(NSError *error))completion {
    
    
    NSDictionary *plist = [PreferencesManager getDictionaryFromPlist:@"GoogleService-Info"];

    
    // Get a non-default Storage bucket
    FIRStorage *storage = [FIRStorage storageWithURL:[plist valueForKey:@"STORAGE_BUCKET_GS"]];
    
    // Create a root reference
    FIRStorageReference *rootStorageRef = [storage reference];
    
//    String photoUrl = AppFields.Firebase.MARCACIONES_FOLDER + "/"+ UserProfileHelper.getInstance().getUser().getIdusuario() +"/" + photoName;
    
    /// Create a reference to the file you want to upload
    FIRStorageReference *storageRef = [rootStorageRef child:pathFile];
    
    
    
    // Data in memory
    //NSData *data = [NSData dataWithContentsOfFile:@"rivers.jpg"];
    
    
    FIRStorageMetadata *newMetadata = [[FIRStorageMetadata alloc] init];
    newMetadata.contentType = @"image/jpg";
    
    // Upload the file to the path "images/rivers.jpg"
//    FIRStorageUploadTask *uploadTask = 
    [storageRef putData:data metadata:newMetadata completion:^(FIRStorageMetadata *metadata, NSError *error) {
        
        if (completion) completion(error);
        
//        if (error == nil) {
//            
//            // Uh-oh, an error occurred!
//            
//            if (onSuccess) onSuccess();
//        }
//        else {
//            
//            if (onFailure) onFailure();
//        
//            // Metadata contains file metadata such as size, content-type, and download URL.
//            //NSURL *downloadURL = metadata.downloadURL;
//        }
    }];

    
}

+ (void)downloadPathFile:(NSString *)pathFile completion:(void (^)(NSData *data, NSError *error))completion {
    
    
    NSDictionary *plist = [PreferencesManager getDictionaryFromPlist:@"GoogleService-Info"];
    
    
    // Get a non-default Storage bucket
    FIRStorage *storage = [FIRStorage storageWithURL:[plist valueForKey:@"STORAGE_BUCKET_GS"]];
    
    // Create a root reference
    FIRStorageReference *rootStorageRef = [storage reference];
    
    //    String photoUrl = AppFields.Firebase.MARCACIONES_FOLDER + "/"+ UserProfileHelper.getInstance().getUser().getIdusuario() +"/" + photoName;
    
    /// Create a reference to the file you want to upload
    FIRStorageReference *storageRef = [rootStorageRef child:pathFile];
    
    
    
    // Data in memory
    //NSData *data = [NSData dataWithContentsOfFile:@"rivers.jpg"];
    
    
    FIRStorageMetadata *newMetadata = [[FIRStorageMetadata alloc] init];
    newMetadata.contentType = @"image/jpg";
    
    // Upload the file to the path "images/rivers.jpg"
    //    FIRStorageUploadTask *uploadTask =
    [storageRef dataWithMaxSize:20 * 1024 *1024 completion:^(NSData *data, NSError *error) {
        
        if (completion) completion(data, error);
    }];
    
    
}


@end
