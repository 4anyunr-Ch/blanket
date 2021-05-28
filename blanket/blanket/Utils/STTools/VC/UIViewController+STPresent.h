//
//  UIViewController+STPresent.h
//  SportHome
//
//  Created by stoneobs on 16/11/25.
//  Copyright © 2016年 stoneobs. All rights reserved.

#import <UIKit/UIKit.h>
#import "STImagePickerController.h"
typedef void(^ST_ALERT_BLOCK)(NSString * name);//alert 回调
typedef void (^ST_ACTION_BLOCK)(int tag); //actionsheet 回调
typedef void (^ST_IMAGE_PICKER_BLOCK) (UIImage * image); //图片选择回调
typedef void (^ST_MULTI_SELECT_BLOCK)(NSArray<STPhotoModel*>* array);//多选图片后的回调

@interface UIViewController (STPresent)
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

// UIAlertController
- (void)showAlert:(NSString*)message;
- (void)showAlert:(NSString *)message andWithBlock:(ST_ALERT_BLOCK)finsh;
- (void)showAlertTitle:(NSString*)title
               message:(NSString *)message
          andWithBlock:(ST_ALERT_BLOCK)finsh;
- (void)showAlertTitle:(NSString*)title
               message:(NSString *)message
             leftTitle:(NSString*)leftTitle
            rightTitle:(NSString*)rightTitle
                 block:(ST_ALERT_BLOCK)finsh;
//默认取消和确认按钮，可以通过finsh中的string来判断
- (void)showAlertCancelAndConfirm:(NSString*)message
                     andWithBlock:(ST_ALERT_BLOCK)finsh;
- (void)showAlertCustomTitleOne:(NSString *)one
                            Two:(NSString*)two
                        message:(NSString*)message
                   andWithBlock:(ST_ALERT_BLOCK)finsh;

- (void)showActionSheet:(NSArray<NSString*>*)strArray
           andWithBlock:(ST_ACTION_BLOCK)test;
//直接弹出图片选择控制器
- (void)showDefultImagePicker:(ST_IMAGE_PICKER_BLOCK)pickerBlock;
//照片可多选，拍照系统
- (void)showSTImagePickerHandle:(void(^)(NSArray<STPhotoModel*>* array)) handle pickerBlock:(ST_IMAGE_PICKER_BLOCK)pickerBlock ;

//完全自定义alert
- (void)showAlertWithTitle:(NSString*)title
                titleColor:(UIColor*)titleColor
                   message:(NSString*)message
              messageColor:(UIColor*)messageColor
                 leftTitle:(NSString*)leftTitle
            leftTitleColor:(UIColor*)leftTitleColor
                rightTitle:(NSString*)rightTitle
           rightTitleColor:(UIColor*)rightTitleColor
                    handle:(ST_ALERT_BLOCK)handle;
//展示emial的特殊alert
- (void)showEmailAlertWithTitle:(NSString*)title
                     titleColor:(UIColor*)titleColor
                        message:(NSString*)message
                   messageColor:(UIColor*)messageColor
                      leftTitle:(NSString*)leftTitle
                 leftTitleColor:(UIColor*)leftTitleColor
                     rightTitle:(NSString*)rightTitle
                rightTitleColor:(UIColor*)rightTitleColor
                     customView:(UIView*)customView
                         handle:(ST_ALERT_BLOCK)handle;
@end
