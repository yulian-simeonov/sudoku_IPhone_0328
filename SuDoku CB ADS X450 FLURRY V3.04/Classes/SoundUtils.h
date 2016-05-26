//
//  SoundUtils.h
//  Sudoku
//
//  Created by Maksim Shumilov on 03.10.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

void Sounds_Init();
void Sounds_Free();

void Sounds_PlayStartup();
void Sounds_PlayClose();
void Sounds_PlayTransform();
void Sounds_PlayClick();
void Sounds_PlayHintControls();
void Sounds_PlayEraser();

