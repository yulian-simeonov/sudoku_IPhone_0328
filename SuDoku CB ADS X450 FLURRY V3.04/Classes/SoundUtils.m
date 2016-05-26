//
//  SoundUtils.m
//  Sudoku
//
//  Created by Maksim Shumilov on 03.10.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "SudokuAppDelegate.h"
#import "SoundUtils.h"

#import "SoundEffect.h"

SoundEffect* g_SoundStartup;
SoundEffect* g_SoundClose;
SoundEffect* g_SoundTransform;
SoundEffect* g_SoundClick;
SoundEffect* g_SoundHint;
SoundEffect* g_SoundEraser;

void Sounds_Init()
{
	NSString* soundPath;
	
	soundPath = [[NSBundle mainBundle] pathForResource:@"Startup" ofType:@"wav"];
	g_SoundStartup = [[SoundEffect soundEffectWithContentsOfFile:soundPath] retain];
	
	soundPath = [[NSBundle mainBundle] pathForResource:@"Close" ofType:@"wav"];
	g_SoundClose = [[SoundEffect soundEffectWithContentsOfFile:soundPath] retain];
	
	soundPath = [[NSBundle mainBundle] pathForResource:@"Transform" ofType:@"wav"];
	g_SoundTransform = [[SoundEffect soundEffectWithContentsOfFile:soundPath] retain];
	
	soundPath = [[NSBundle mainBundle] pathForResource:@"Click" ofType:@"wav"];
	g_SoundClick = [[SoundEffect soundEffectWithContentsOfFile:soundPath] retain];
	
	soundPath = [[NSBundle mainBundle] pathForResource:@"HintFound" ofType:@"wav"];
	g_SoundHint = [[SoundEffect soundEffectWithContentsOfFile:soundPath] retain];
	
	soundPath = [[NSBundle mainBundle] pathForResource:@"Undo" ofType:@"wav"];
	g_SoundEraser = [[SoundEffect soundEffectWithContentsOfFile:soundPath] retain];
}

void Sounds_Free()
{
	[g_SoundStartup release];
	[g_SoundClose release];
	[g_SoundTransform release];
	[g_SoundClick release];
	[g_SoundHint release];
	[g_SoundEraser release];
}

void Sounds_PlayStartup()
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	if(!appDelegate.prefSoundsOn)
		return;
	
	if(!appDelegate.prefSoundsStartup)
		return;
	
	[g_SoundStartup play];
}

void Sounds_PlayClose()
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	if(!appDelegate.prefSoundsOn)
		return;
	
	if(!appDelegate.prefSoundsClose)
		return;
	
	[g_SoundClose play];
}

void Sounds_PlayTransform()
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	if(!appDelegate.prefSoundsOn)
		return;
	
	if(!appDelegate.prefSoundsTransform)
		return;
	
	[g_SoundTransform play];
}

void Sounds_PlayClick()
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	if(!appDelegate.prefSoundsOn)
		return;
	
	if(!appDelegate.prefSoundsClick)
		return;
	
	[g_SoundClick play];
}

void Sounds_PlayHintControls()
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	if(!appDelegate.prefSoundsOn)
		return;
	
	if(!appDelegate.prefSoundsHintControls)
		return;
	
	[g_SoundHint play];
}

void Sounds_PlayEraser()
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	if(!appDelegate.prefSoundsOn)
		return;
	
	if(!appDelegate.prefSoundsEraser)
		return;

	[g_SoundEraser play];
}
