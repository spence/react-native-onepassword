#import "OnePassword.h"
#import "RCTUtils.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "OnePasswordExtension.h"
#import "RCTUIManager.h"
#import "UIWindow+VisibleViewController.h"

@implementation OnePassword

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(isSupported: (RCTResponseSenderBlock)callback)
{
    if ([[OnePasswordExtension sharedExtension] isAppExtensionAvailable]) {
        callback(@[[NSNull null], @true]);
    }
    else {
        callback(@[RCTMakeError(@"OnePassword is not supported.", nil, nil)]);
        return;
    }
}

RCT_EXPORT_METHOD(changeLogin: (NSString *)url
                  details: (NSDictionary *)details
                  generationOptions: (NSDictionary *)options
                  callback: (RCTResponseSenderBlock)callback)
{
    UIViewController *controller = RCTKeyWindow().visibleViewController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[OnePasswordExtension sharedExtension] changePasswordForLoginForURLString:url loginDetails:details passwordGenerationOptions:options forViewController:controller sender:nil completion:^(NSDictionary * _Nullable loginDictionary, NSError * _Nullable error) {
            
            if (loginDictionary.count == 0) {
                callback(@[RCTMakeError(@"Error while getting login credentials.", nil, nil)]);
                return;
            } else if (error) {
                callback(@[RCTMakeError(error.localizedDescription, nil, nil)]);
                return;
            }
            
            callback(@[[NSNull null], @{
                           @"username": loginDictionary[AppExtensionUsernameKey],
                           @"password": loginDictionary[AppExtensionPasswordKey]
                           }]);
        }];
    });
}

RCT_EXPORT_METHOD(findLogin: (NSString *)url
                  callback: (RCTResponseSenderBlock)callback)
{
    UIViewController *controller = RCTKeyWindow().visibleViewController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[OnePasswordExtension sharedExtension] findLoginForURLString:url
        forViewController:controller sender:nil completion:^(NSDictionary *loginDictionary, NSError *error) {
            if (loginDictionary.count == 0) {
                callback(@[RCTMakeError(@"Error while getting login credentials.", nil, nil)]);
                return;
            }
            
            callback(@[[NSNull null], @{
                           @"username": loginDictionary[AppExtensionUsernameKey],
                           @"password": loginDictionary[AppExtensionPasswordKey]
                           }]);
        }];
    });
}

RCT_EXPORT_METHOD(storeLogin: (NSString *)url
                  details: (NSDictionary *)details
                  generationOptions: (NSDictionary *)options
                  callback: (RCTResponseSenderBlock)callback)
{
    UIViewController *controller = RCTKeyWindow().visibleViewController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[OnePasswordExtension sharedExtension] storeLoginForURLString:url loginDetails:details passwordGenerationOptions:options forViewController:controller sender:nil completion:^(NSDictionary * _Nullable loginDictionary, NSError * _Nullable error) {
            
            
            if (loginDictionary.count == 0) {
                callback(@[RCTMakeError(@"Error while getting login credentials.", nil, nil)]);
                return;
            } else if (error) {
                callback(@[RCTMakeError(error.localizedDescription, nil, nil)]);
                return;
            }
            
            callback(@[[NSNull null], @{
                                @"username": loginDictionary[AppExtensionUsernameKey],
                                @"password": loginDictionary[AppExtensionPasswordKey]
                           }]);
        }];
    });
}

- (NSDictionary *)constantsToExport
{
    return @{
             @"PasswordKey": AppExtensionUsernameKey,
             @"UsernameKey": AppExtensionUsernameKey,
             @"UrlKey": AppExtensionURLStringKey,
             @"TitleKey": AppExtensionTitleKey,
             @"NotesKey": AppExtensionNotesKey
             };
}

@end
