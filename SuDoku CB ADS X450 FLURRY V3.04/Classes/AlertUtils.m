//
//  AlertUtils.m
//  Sudoku
//
//  Created by Maksim Shumilov on 31.05.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "AlertUtils.h"

@implementation AlertUtils

@synthesize delegate;	
@synthesize selector;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(delegate && selector)
		[delegate performSelector:selector withObject:[NSNumber numberWithInt:buttonIndex]];
	
	[self release];
}

- (void)dealloc 
{
	[delegate release];
	[super dealloc];
}

@end

void AlertUtils_ShowOkCancelAlert(id delegate, SEL selector, NSString* title, NSString* message)
{
	AlertUtils* utilsClass = [[AlertUtils alloc] init];
	
	utilsClass.delegate = delegate;
	utilsClass.selector = selector;
	
	UIAlertView* alert =  [[UIAlertView alloc] initWithTitle:title message:message delegate:utilsClass cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK",@""), NSLocalizedString(@"Cancel",@""), nil];
	[alert show];
	[alert release];
}

void AlertUtils_ShowYesNoAlert(id delegate, SEL selector, NSString* title, NSString* message)
{
	AlertUtils* utilsClass = [[AlertUtils alloc] init];
	
	utilsClass.delegate = delegate;
	utilsClass.selector = selector;
	
	UIAlertView* alert =  [[UIAlertView alloc] initWithTitle:title message:message delegate:utilsClass cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"YES",@""), NSLocalizedString(@"NO",@""), nil];
	[alert show];
	[alert release];
}

void AlertUtils_ShowDoneAlert(id delegate, SEL selector, NSString* title, NSString* message)
{
	AlertUtils* utilsClass = [[AlertUtils alloc] init];
	
	utilsClass.delegate = delegate;
	utilsClass.selector = selector;
	
	UIAlertView* alert =  [[UIAlertView alloc] initWithTitle:title message:message delegate:utilsClass cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Done",@""), nil];
	[alert show];
	[alert release];
}

void AlertUtils_ShowAlert(id delegate, SEL selector, UIAlertView* alert)
{
	AlertUtils* utilsClass = [[AlertUtils alloc] init];
	
	utilsClass.delegate = delegate;
	utilsClass.selector = selector;
	
	alert.delegate = utilsClass;
	[alert show];
}
