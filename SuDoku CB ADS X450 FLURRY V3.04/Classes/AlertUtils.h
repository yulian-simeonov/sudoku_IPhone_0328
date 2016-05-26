//
//  AlertUtils.h
//  Sudoku
//
//  Created by Maksim Shumilov on 31.05.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertUtils : NSObject <UIAlertViewDelegate>
{
	id delegate;	
	SEL selector;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic) SEL selector;

@end

void AlertUtils_ShowOkCancelAlert(id delegate, SEL selector, NSString* title, NSString* message);
void AlertUtils_ShowYesNoAlert(id delegate, SEL selector, NSString* title, NSString* message);
void AlertUtils_ShowDoneAlert(id delegate, SEL selector, NSString* title, NSString* message);
void AlertUtils_ShowAlert(id delegate, SEL selector, UIAlertView* alert);
