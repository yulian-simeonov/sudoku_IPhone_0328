//
//  MenuDefenitions.m
//  Sudoku
//
//  Created by Maksim Shumilov on 13.05.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import "MenuDefenitions.h"

const MenuDef _menuDef_Tools_NewSudoku = 
{
	6,
	@"onStartNewGameUpddateMenuDef:",
	nil,
	{
		{0, @"Simple", kImageBarEmpty, @"menu_diff_1.png", @"onStartNewGame:", NULL},
		{1, @"Easy", kImageBarEmpty, @"menu_diff_2.png", @"onStartNewGame:", NULL},
		{2, @"Medium", kImageBarEmpty, @"menu_diff_3.png", @"onStartNewGame:", NULL},
		{3, @"Hard", kImageBarEmpty, @"menu_diff_4.png", @"onStartNewGame:", NULL},
		{4, @"Very Hard", kImageBarEmpty, @"menu_diff_5.png", @"onStartNewGame:", NULL},
		{5, @"Sudoku Master!", kImageBarEmpty, @"menu_diff_6.png", @"onStartNewGame:", NULL},
	}
};

const MenuDef _menuDef_MoreTools_ClearNumbers_ByColor = 
{
	6,
	nil,
	nil,
	{
		{1, @"Clear All Dark Gray", kImageBarEmpty, @"menu_clear_dark_gray.png", @"onClearNumbersByColor:", NULL},
		{2, @"Clear All Red", kImageBarEmpty, @"menu_clear_red.png", @"onClearNumbersByColor:", NULL},
		{3, @"Clear All Orange", kImageBarEmpty, @"menu_clear_orange.png", @"onClearNumbersByColor:", NULL},
		{4, @"Clear All Yellow", kImageBarEmpty, @"menu_clear_yellow.png", @"onClearNumbersByColor:", NULL},
		{5, @"Clear All Green", kImageBarEmpty, @"menu_clear_green.png", @"onClearNumbersByColor:", NULL},
		{6, @"Clear All Blue", kImageBarEmpty, @"menu_clear_blue.png", @"onClearNumbersByColor:", NULL},
	}
};

const MenuDef _menuInfo_MoreTools_ClearNumbers_ByValue = 
{
	9,
	nil,
	nil,
	{
		{1, @"Clear All 1s", kImageBarEmpty, @"menu_clearnumbyval_1.png", @"onClearNumbersByValue:", NULL},
		{2, @"Clear All 2s", kImageBarEmpty, @"menu_clearnumbyval_2.png", @"onClearNumbersByValue:", NULL},
		{3, @"Clear All 3s", kImageBarEmpty, @"menu_clearnumbyval_3.png", @"onClearNumbersByValue:", NULL},
		{4, @"Clear All 4s", kImageBarEmpty, @"menu_clearnumbyval_4.png", @"onClearNumbersByValue:", NULL},
		{5, @"Clear All 5s", kImageBarEmpty, @"menu_clearnumbyval_5.png", @"onClearNumbersByValue:", NULL},
		{6, @"Clear All 6s", kImageBarEmpty, @"menu_clearnumbyval_6.png", @"onClearNumbersByValue:", NULL},
		{7, @"Clear All 7s", kImageBarEmpty, @"menu_clearnumbyval_7.png", @"onClearNumbersByValue:", NULL},
		{8, @"Clear All 8s", kImageBarEmpty, @"menu_clearnumbyval_8.png", @"onClearNumbersByValue:", NULL},
		{9, @"Clear All 9s", kImageBarEmpty, @"menu_clearnumbyval_9.png", @"onClearNumbersByValue:", NULL},
	}
};

const MenuDef _menuInfo_MoreTools_ClearNumbers = 
{
	3,
	nil,
	nil,
	{
		{0, @"Clear All Numbers", kImageBarEmpty, @"menu_clearnumb_all.png", @"onClearNumbersAll:", NULL},
		{0, @"Clear Numbers By Color", kImageBarEmpty, @"menu_clearnumb_color.png", nil, &_menuDef_MoreTools_ClearNumbers_ByColor},
		{0, @"Clear Numbers By Value", kImageBarEmpty, @"menu_clearnumb_value.png", nil, &_menuInfo_MoreTools_ClearNumbers_ByValue},
	}
};


const MenuDef _menuInfo_MoreTools_ClearCandidates_ByValue = 
{
	9,
	nil,
	nil,
	{
		{1, @"Clear All 1s", kImageBarEmpty, @"menu_clearcand_1s.png", @"onClearPossibleByValue:", NULL},
		{2, @"Clear All 2s", kImageBarEmpty, @"menu_clearcand_2s.png", @"onClearPossibleByValue:", NULL},
		{3, @"Clear All 3s", kImageBarEmpty, @"menu_clearcand_3s.png", @"onClearPossibleByValue:", NULL},
		{4, @"Clear All 4s", kImageBarEmpty, @"menu_clearcand_4s.png", @"onClearPossibleByValue:", NULL},
		{5, @"Clear All 5s", kImageBarEmpty, @"menu_clearcand_5s.png", @"onClearPossibleByValue:", NULL},
		{6, @"Clear All 6s", kImageBarEmpty, @"menu_clearcand_6s.png", @"onClearPossibleByValue:", NULL},
		{7, @"Clear All 7s", kImageBarEmpty, @"menu_clearcand_7s.png", @"onClearPossibleByValue:", NULL},
		{8, @"Clear All 8s", kImageBarEmpty, @"menu_clearcand_8s.png", @"onClearPossibleByValue:", NULL},
		{9, @"Clear All 9s", kImageBarEmpty, @"menu_clearcand_9s.png", @"onClearPossibleByValue:", NULL},
	}
};

const MenuDef _menuInfo_MoreTools_ClearCandidates = 
{
	2,
	nil,
	nil,
	{
		{0, @"Clear All Candidates", kImageBarEmpty, @"menu_clearcand_all.png", @"onClearPossibleAll:", NULL},
		{0, @"Clear Candidates By Value", kImageBarEmpty, @"menu_clearcand_number.png", nil, &_menuInfo_MoreTools_ClearCandidates_ByValue},
	}
};

const MenuDef _menuInfo_MoreTools_ChangeColors_Colors = 
{
	6,
	nil,
	nil,
	{
		{1, @"Dark Gray", kImageBarEmpty, @"menu_col_grey.png", @"onChangeNumberColors:", NULL},
		{2, @"Red", kImageBarEmpty, @"menu_col_red.png", @"onChangeNumberColors:", NULL},
		{3, @"Orange", kImageBarEmpty, @"menu_col_orange.png", @"onChangeNumberColors:", NULL},
		{4, @"Yellow", kImageBarEmpty, @"menu_col_yellow.png", @"onChangeNumberColors:", NULL},
		{5, @"Green", kImageBarEmpty, @"menu_col_green.png", @"onChangeNumberColors:", NULL},
		{6, @"Blue", kImageBarEmpty, @"menu_col_blue.png", @"onChangeNumberColors:", NULL},
	}
};

const MenuDef _menuInfo_MoreTools_ChangeColors = 
{
	9,
	nil,
	nil,
	{
		{1, @"All Number 1s", kImageBarEmpty, @"menu_n1.png", nil, &_menuInfo_MoreTools_ChangeColors_Colors},
		{2, @"All Number 2s", kImageBarEmpty, @"menu_n2.png", nil, &_menuInfo_MoreTools_ChangeColors_Colors},
		{3, @"All Number 3s", kImageBarEmpty, @"menu_n3.png", nil, &_menuInfo_MoreTools_ChangeColors_Colors},
		{4, @"All Number 4s", kImageBarEmpty, @"menu_n4.png", nil, &_menuInfo_MoreTools_ChangeColors_Colors},
		{5, @"All Number 5s", kImageBarEmpty, @"menu_n5.png", nil, &_menuInfo_MoreTools_ChangeColors_Colors},
		{6, @"All Number 6s", kImageBarEmpty, @"menu_n6.png", nil, &_menuInfo_MoreTools_ChangeColors_Colors},
		{7, @"All Number 7s", kImageBarEmpty, @"menu_n7.png", nil, &_menuInfo_MoreTools_ChangeColors_Colors},
		{8, @"All Number 8s", kImageBarEmpty, @"menu_n8.png", nil, &_menuInfo_MoreTools_ChangeColors_Colors},
		{9, @"All Number 9s", kImageBarEmpty, @"menu_n9.png", nil, &_menuInfo_MoreTools_ChangeColors_Colors},
	}
};

const MenuDef _menuInfo_MoreTools = 
{
	3,
	nil,
	nil,
	{
		{0, @"Clear Numbers", kImageBarEmpty, @"menu_mt_clrnumbers.png", nil, &_menuInfo_MoreTools_ClearNumbers},
		{0, @"Clear Candidates", kImageBarEmpty, @"menu_mt_clrcands.png", nil, &_menuInfo_MoreTools_ClearCandidates},
		{0, @"Change Number Colors", kImageBarEmpty, @"menu_mt_clrnumcol.png", nil, &_menuInfo_MoreTools_ChangeColors},
	}
};

const MenuDef _menuInfo_Options_NumberStyles = 
{
	6,
	nil,
	@"onNumbersStyleMenuUpdate:",
	{
		{0, @"Plain Numbers", kImageBarEmpty, @"menu_options_number_stules.png", @"onChangeNumbersStyle:", NULL},
		{1, @"Sketch Numbers", kImageBarEmpty, @"menu_options_number_stules.png", @"onChangeNumbersStyle:", NULL},
		{7, @"Alpha", kImageBarEmpty, @"menu_options_number_stules.png", @"onChangeNumbersStyle:", NULL},
		{8, @"Roman", kImageBarEmpty, @"menu_options_number_stules.png", @"onChangeNumbersStyle:", NULL},
		{10, @"L.C.D.", kImageBarEmpty, @"menu_options_number_stules.png", @"onChangeNumbersStyle:", NULL},
		{11, @"Pool", kImageBarEmpty, @"menu_options_number_stules.png", @"onChangeNumbersStyle:", NULL},
	}
};

const MenuDef _menuInfo_Options_PictureStyles = 
{
	5,
	nil,
	@"onNumbersStyleMenuUpdate:",
	{
		{2, @"Bugs", kImageBarEmpty, @"menu_options_picture_stules.png", @"onChangeNumbersStyle:", NULL},
		{3, @"Flowers", kImageBarEmpty, @"menu_options_picture_stules.png", @"onChangeNumbersStyle:", NULL},
		{4, @"Kanji", kImageBarEmpty, @"menu_options_picture_stules.png", @"onChangeNumbersStyle:", NULL},
		{5, @"Yang Yang", kImageBarEmpty, @"menu_options_picture_stules.png", @"onChangeNumbersStyle:", NULL},
		//{6, @"Flags", kImageBarEmpty, @"menu_options_picture_stules.png", @"onChangeNumbersStyle:", NULL},
		{9, @"1980s", kImageBarEmpty, @"menu_options_picture_stules.png", @"onChangeNumbersStyle:", NULL},
		
	}
};

const MenuDef _menuInfo_Options_GridStyles = 
{
	7,
	nil,
	@"onGridStyleMenuUpdate:",
	{
		{0, @"Alpha", kImageBarEmpty, @"menu_gridstyle.png", @"onChangeGridStyle:", NULL},
		{1, @"Mellow Yellow", kImageBarEmpty, @"menu_gridstyle.png", @"onChangeGridStyle:", NULL},
		{2, @"Plain", kImageBarEmpty, @"menu_gridstyle.png", @"onChangeGridStyle:", NULL},
		//{3, @"Tiles", kImageBarEmpty, @"menu_gridstyle.png", @"onChangeGridStyle:", NULL},
		{4, @"Symbol", kImageBarEmpty, @"menu_gridstyle.png", @"onChangeGridStyle:", NULL},
		{3, @"Shadow", kImageBarEmpty, @"menu_gridstyle.png", @"onChangeGridStyle:", NULL},
		//{6, @"Roman", kImageBarEmpty, @"menu_gridstyle.png", @"onChangeGridStyle:", NULL},
		{7, @"Pitch", kImageBarEmpty, @"menu_gridstyle.png", @"onChangeGridStyle:", NULL},
		{8, @"L.C.D.", kImageBarEmpty, @"menu_gridstyle.png", @"onChangeGridStyle:", NULL},
        
		//{8, @"Roman 2", kImageBarEmpty, @"menu_gridstyle.png", @"onChangeGridStyle:", NULL},
	}
};

//const MenuDef _menuInfo_Options_BackStyles = 
//{
//	2,
//	nil,
//	@"onBackStyleMenuUpdate:",
//	{
//		{0, @"Darkness", kImageBarEmpty, @"menu_darkness.png", @"onChangeBackStyle:", NULL},
//		{1, @"Sky", kImageBarEmpty, @"menu_sky.png", @"onChangeBackStyle:", NULL},
//	}
//};

const MenuDef _menuInfo_Options_SkinPresets = 
{
	4,
	nil,
	nil,
	{
		{0, @"Plain", kImageBarEmpty, @"menu_options_skin_presets.png", @"onSkinPresets:", NULL},
		{1, @"Alpha", kImageBarEmpty, @"menu_options_skin_presets.png", @"onSkinPresets:", NULL},
        {2, @"1980s", kImageBarEmpty, @"menu_options_skin_presets.png", @"onSkinPresets:", NULL},
        {3, @"L.C.D.", kImageBarEmpty, @"menu_options_skin_presets.png", @"onSkinPresets:", NULL},
		//{3, @"Roman", kImageBarEmpty, @"menu_options_skin_presets.png", @"onSkinPresets:", NULL},
			}
};

const MenuDef _menuInfo_Options_Symmetry = 
{
	3,
	nil,
	@"onSymmetryMenuUpdate:",
	{
		{0, @"Symmetrical", kImageBarEmpty, @"menu_options_symmetry.png", @"onSymmetryMenu:", NULL},
		{1, @"Symmetrical and Assymetrical", kImageBarEmpty, @"menu_options_symmetry.png", @"onSymmetryMenu:", NULL},
		{2, @"Assymetrical", kImageBarEmpty, @"menu_options_symmetry.png", @"onSymmetryMenu:", NULL},
	}
};

const MenuDef _menuInfo_Options_Sounds = 
{
	7,
	nil,
	@"onSoundsMenuUpdate:",
	{
		{0, @"Sounds On", kImageBarEmpty, @"menu_options_sounds.png", @"onSoundsMenu:", NULL},
		{1, @"Startup", kImageBarEmpty, @"menu_options_sounds.png", @"onSoundsMenu:", NULL},
		{2, @"Close", kImageBarEmpty, @"menu_options_sounds.png", @"onSoundsMenu:", NULL},
		{3, @"Transform", kImageBarEmpty, @"menu_options_sounds.png", @"onSoundsMenu:", NULL},
		{4, @"Click", kImageBarEmpty, @"menu_options_sounds.png", @"onSoundsMenu:", NULL},
		{5, @"Hint Controls", kImageBarEmpty, @"menu_options_sounds.png", @"onSoundsMenu:", NULL},
		{6, @"Eraser (Undo)", kImageBarEmpty, @"menu_options_sounds.png", @"onSoundsMenu:", NULL},
	}
};

const MenuDef _menuInfo_Options_Keypad_options = 
{
	4,
	nil,
	@"onKeypadOptionsUpdate:",
	{
		{0, @"Keypad is Draggable", kImageBarEmpty, @"menu_keypad.png", @"onKeypadOptions:", NULL},
		{1, @"Keypad is Sticky", kImageBarEmpty, @"menu_keypad.png", @"onKeypadOptions:", NULL},
		{2, @"Autohide Keypad", kImageBarEmpty, @"menu_keypad.png", @"onKeypadOptions:", NULL},
		{3, @"OK always hides Keypad", kImageBarEmpty, @"menu_keypad.png", @"onKeypadOptions:", NULL},
	}
};

const MenuDef _menuInfo_Options_Keypad = 
{
	3,
	nil,
	@"onKeyPadMenuUpdate:",
	{
		{0, @"Fixed keypad", kImageBarEmpty, @"menu_keypad.png", @"onKeyPadMenu:", NULL},
		{1, @"Flying keypad", kImageBarEmpty, @"menu_keypad.png", @"onKeyPadMenu:", NULL},
		{2, @"Flying keypad options", kImageBarEmpty, @"menu_keypad.png", nil, &_menuInfo_Options_Keypad_options},
	}
};

const MenuDef _menuInfo_Options = 
{
	7,
	nil,
	nil,
	{
		{0, @"Number Styles", kImageBarEmpty, @"menu_options_number_stules.png", nil, &_menuInfo_Options_NumberStyles},
		{0, @"Picture Styles", kImageBarEmpty, @"menu_options_picture_stules.png", nil, &_menuInfo_Options_PictureStyles},
		{0, @"Grid Styles", kImageBarEmpty, @"menu_gridstyle.png", nil, &_menuInfo_Options_GridStyles},
		//{0, @"Background Styles", kImageBarEmpty, @"menu_options_back_styles.png", nil, &_menuInfo_Options_BackStyles},
		{0, @"Skin Presets", kImageBarEmpty, @"menu_options_skin_presets.png", nil, &_menuInfo_Options_SkinPresets},
		{0, @"Symmetry", kImageBarEmpty, @"menu_options_symmetry.png", nil, &_menuInfo_Options_Symmetry},
		{0, @"Sounds", kImageBarEmpty, @"menu_options_sounds.png", nil, &_menuInfo_Options_Sounds},
		{0, @"Keypad Type", kImageBarEmpty, @"menu_keypad.png", nil, &_menuInfo_Options_Keypad},
	}
};

const MenuDef _menuInfo_AdvancedStatistics = 
{
	7,
	nil,
	nil,
	{
		{0, @"Simple", kImageBarEmpty, @"menu_stat_1.png", @"onShowAdvancedStats:", NULL},
		{1, @"Easy", kImageBarEmpty, @"menu_stat_2.png", @"onShowAdvancedStats:", NULL},
		{2, @"Medium", kImageBarEmpty, @"menu_stat_3.png", @"onShowAdvancedStats:", NULL},
		{3, @"Hard", kImageBarEmpty, @"menu_stat_4.png", @"onShowAdvancedStats:", NULL},
		{4, @"Very Hard", kImageBarEmpty, @"menu_stat_5.png", @"onShowAdvancedStats:", NULL},
		{5, @"SuDoku Master", kImageBarEmpty, @"menu_stat_6.png", @"onShowAdvancedStats:", NULL},
		{0, @"Reset Statistics", kImageBarEmpty, @"menu_clearstats.png", @"onResetStats:", NULL},
	}
};

const MenuDef _menuInfo_GameCenter = 
{
	2,
	nil,
	nil,
	{
		{0, @"Leaderboard", kImageBarEmpty, @"menu_gamecenter.png", @"onShowLeaderboard:", NULL},
		{0, @"Achievements", kImageBarEmpty, @"menu_gamecenter.png", @"onShowAchievements:", NULL},
	}
};

MenuDef _menuInfo = 
{
	7,
	nil,
	nil,
	{
		{0, @"Create New Sudoku", kImageBarEmpty, @"menu_tools_create_new.png",nil,  &_menuDef_Tools_NewSudoku},
		{0, @"Enter Own Sudoku", kImageBarEmpty, @"menu_tools_enter_own.png", @"onEnterOwnSudoku:",  NULL},
		{0, @"Solve!", kImageBarEmpty, @"menu_tools_solve.png", @"onSolve:", NULL},
		{0, @"More Tools", kImageBarEmpty, @"menu_tools_more.png", nil, &_menuInfo_MoreTools},
		{0, @"Options", kImageBarEmpty, @"menu_tools_options.png", nil, &_menuInfo_Options},
		{0, @"Advanced Statistics", kImageBarEmpty, @"menu_tools_adv_stat.png", nil, &_menuInfo_AdvancedStatistics},
		{0, @"Game Center", kImageBarEmpty, @"menu_gamecenter.png", nil, &_menuInfo_GameCenter},
	}
};

const MenuDef _menuHelp = 
{
	4,
	nil,
	nil,
	{
		{0, @"About", kImageBarEmpty, @"menu_help_about.png", @"onHelpAbout:", NULL},
		{0, @"Credits", kImageBarEmpty, @"menu_help_credits.png", @"onHelpCredits:", NULL},
		{0, @"Help", kImageBarEmpty, @"menu_help_help.png", @"onHelpHelp:", NULL},
		{0, @"Other Titles", kImageBarEmpty, @"menu_help_other.png", @"onHelpOtherTitles:", NULL},
	}
};

const MenuDef _menuWand_NakedSubset = 
{
	4,
	nil,
	nil,
	{
		{0, @"Highlight Singles", kImageBarEmpty, @"menu_naked_1.png", @"onShowNakedSubset:", NULL},
		{1, @"Highlight Twins", kImageBarEmpty, @"menu_naked_2.png", @"onShowNakedSubset:", NULL},
		{2, @"Highlight Triplets", kImageBarEmpty, @"menu_naked_3.png", @"onShowNakedSubset:", NULL},
		{3, @"Highlight Quadruplets", kImageBarEmpty, @"menu_naked_4.png", @"onShowNakedSubset:", NULL},
	}
};

const MenuDef _menuWand_HiddenSubset_Items = 
{
	4,
	nil,
	nil,
	{
		{0, @"Highlight Hidden Singles", kImageBarEmpty, @"menu_hidden_1.png", @"onShowHiddenSubset:", NULL},
		{1, @"Highlight Hidden Twins", kImageBarEmpty, @"menu_hidden_2.png", @"onShowHiddenSubset:", NULL},
		{2, @"Highlight Hidden Triplets", kImageBarEmpty, @"menu_hidden_3.png", @"onShowHiddenSubset:", NULL},
		{3, @"Highlight Hidden Quadruplets", kImageBarEmpty, @"menu_hidden_4.png", @"onShowHiddenSubset:", NULL},
	}
};

const MenuDef _menuWand_HiddenSubset_DirectItems = 
{
	3,
	nil,
	nil,
	{
		{1, @"Direct Hidden Twins", kImageBarEmpty, nil, @"onShowHiddenSubset:", NULL},
		{2, @"Direct Hidden Triplets", kImageBarEmpty, nil, @"onShowHiddenSubset:", NULL},
		{3, @"Direct Hidden Quadruplets", kImageBarEmpty, nil, @"onShowHiddenSubset:", NULL},
	}
};

const MenuDef _menuWand_HiddenSubset = 
{
	2,
	nil,
	nil,
	{
		{0, @"Hidden Subset", kImageBarEmpty, nil, nil, &_menuWand_HiddenSubset_Items},
		{1, @"Direct Hidden Subset", kImageBarEmpty, nil, nil, &_menuWand_HiddenSubset_DirectItems},
	}
};

const MenuDef _menuWand_Fisherman = 
{
	3,
	nil,
	nil,
	{
		{2, @"Highlight X-Wings", kImageBarEmpty, @"menu_wand_xwings.png", @"onFishermanSubset:", NULL},
		{3, @"Highlight Swordfish", kImageBarEmpty, @"menu_wand_swordfish.png", @"onFishermanSubset:", NULL},
		{4, @"Highlight Jellyfish", kImageBarEmpty, @"menu_wand_jellyfish.png", @"onFishermanSubset:", NULL},
	}
};

const MenuDef _menuWand_Intersections = 
{
	2,
	nil,
	nil,
	{
		{0, @"Intersections", kImageBarEmpty, nil, @"onIntersectionsSubset:", NULL},
		{1, @"Direct Intersections", kImageBarEmpty, nil, @"onIntersectionsSubset:", NULL},
	}
};

const MenuDef _menuWand_Suggest_Value_Cell = 
{
	2,
	nil,
	nil,
	{
		{0, @"Suggest a Cell", kImageBarEmpty, @"menu_wand_suggest_cell.png", @"onSuggestCell:", NULL},
		{1, @"Suggest a Value", kImageBarEmpty, @"menu_wand_suggest_value.png", @"onSuggestValue:", NULL},
	}
};

const MenuDef _menuWand_Wings = 
{
	2,
	nil,
	nil,
	{
		{0, @"XY Wing Subset", kImageBarEmpty, nil, @"onXYWingsSubset:", NULL},
		{1, @"XYZ Wing Subset", kImageBarEmpty, nil, @"onXYWingsSubset:", NULL},
	}
};

const MenuDef _menuWand_AlignedExclusion = 
{
	3,
	nil,
	nil,
	{
		{0, @"Aligned Pair Exclusion", kImageBarEmpty, nil, nil, NULL},
		{0, @"Aligned Triplet Exclusion", kImageBarEmpty, nil, nil, NULL},
		{0, @"Aligned Quad Exclusion", kImageBarEmpty, nil, nil, NULL},
	}
};

const MenuDef _menuWand = 
{
	7,
	nil,
	nil,
	{
		{0, @"Wrong Values", kImageBarEmpty, @"menu_wand_wrong.png", @"onWrongValues:", NULL},
		{0, @"Suggest a Cell/Value", kImageBarEmpty, @"menu_wand_suggest_cell.png", nil, &_menuWand_Suggest_Value_Cell},
		{0, @"Naked Subset", kImageBarEmpty, @"menu_wand_naked.png", nil, &_menuWand_NakedSubset},
		{0, @"Hidden Subset", kImageBarEmpty, @"menu_wand_hidden.png", nil, &_menuWand_HiddenSubset},
		{0, @"Fisherman Subset", kImageBarEmpty, @"menu_fisherman24.png", nil, &_menuWand_Fisherman},
		{0, @"Intersections Subset", kImageBarEmpty, @"menu_inter32.png", nil, &_menuWand_Intersections},
		{0, @"XY/Z Wings Subset", kImageBarEmpty, @"menu_xyz124.png", nil, &_menuWand_Wings},
	}
};

const MenuDef _menuWisard_PossibleSells = 
{
	9,
	nil,
	nil,
	{
		{1, @"1 / Red", kImageBarEmpty, @"menu_possible_cell_1.png", @"onPossibleImpossibleCell:", NULL},	
		{2, @"2 / Orange", kImageBarEmpty, @"menu_possible_cell_2.png", @"onPossibleImpossibleCell:", NULL},
		{3, @"3 / Yellow", kImageBarEmpty, @"menu_possible_cell_3.png", @"onPossibleImpossibleCell:", NULL},
		{4, @"4 / Green", kImageBarEmpty, @"menu_possible_cell_4.png", @"onPossibleImpossibleCell:", NULL},
		{5, @"5 / Blue", kImageBarEmpty, @"menu_possible_cell_5.png", @"onPossibleImpossibleCell:", NULL},
		{6, @"6 / Indigo", kImageBarEmpty, @"menu_possible_cell_6.png", @"onPossibleImpossibleCell:", NULL},
		{7, @"7 / Violet", kImageBarEmpty, @"menu_possible_cell_7.png", @"onPossibleImpossibleCell:", NULL},
		{8, @"8 / Black", kImageBarEmpty, @"menu_possible_cell_8.png", @"onPossibleImpossibleCell:", NULL},
		{9, @"9 / White", kImageBarEmpty, @"menu_possible_cell_9.png", @"onPossibleImpossibleCell:", NULL},
	}
};

const MenuDef _menuWisard_ImpossibleSells = 
{
	9,
	nil,
	nil,
	{
		{1, @"1 / Red", kImageBarEmpty, @"menu_impossible_cell_1.png", @"onPossibleImpossibleCell:", NULL},	
		{2, @"2 / Orange", kImageBarEmpty, @"menu_impossible_cell_2.png", @"onPossibleImpossibleCell:", NULL},
		{3, @"3 / Yellow", kImageBarEmpty, @"menu_impossible_cell_3.png", @"onPossibleImpossibleCell:", NULL},
		{4, @"4 / Green", kImageBarEmpty, @"menu_impossible_cell_4.png", @"onPossibleImpossibleCell:", NULL},
		{5, @"5 / Blue", kImageBarEmpty, @"menu_impossible_cell_5.png", @"onPossibleImpossibleCell:", NULL},
		{6, @"6 / Indigo", kImageBarEmpty, @"menu_impossible_cell_6.png", @"onPossibleImpossibleCell:", NULL},
		{7, @"7 / Violet", kImageBarEmpty, @"menu_impossible_cell_7.png", @"onPossibleImpossibleCell:", NULL},
		{8, @"8 / Black", kImageBarEmpty, @"menu_impossible_cell_8.png", @"onPossibleImpossibleCell:", NULL},
		{9, @"9 / White", kImageBarEmpty, @"menu_impossible_cell_9.png", @"onPossibleImpossibleCell:", NULL},
	}
};

const MenuDef _menuWisard = 
{
	9,
	nil,
	@"onWisardMenuUpdate:",
	{
		{0, @"Possible Values (10%)", kImageBarEmpty, @"menu_wisard_possible_values.png", @"onWisardPossibleValues:", NULL},
		{1, @"Possible Cells (10%)", kImageBarEmpty, @"menu_wisard_possible_cells.png", nil, &_menuWisard_PossibleSells},
		{2, @"Impossible Cells (10%)", kImageBarEmpty, @"menu_wisard_impossible_cells.png", nil, &_menuWisard_ImpossibleSells},
		{3, @"Duplicate Box/Row/Col (10%)", kImageBarEmpty, @"menu_wisard_duplicates.png", @"onWisardDuplicatesBoxRowCol:", NULL},
		{4, @"Duplicate Values (10%)", kImageBarEmpty, @"menu_wisard_duplicate_values.png", @"onWisardDuplicateValues:", NULL},
		{5, @"Show Candidates (10%)", kImageBarEmpty, @"menu_wisard_show_candidates.png", @"onWisardShowCandidates:", NULL},
		{6, @"Calculate Candidates (25%)", kImageBarEmpty, @"menu_wisard_calculate_candidates.png", @"onWisardCalculateCandidates:", NULL},
		{7, @"Auto Candidates (75%)", kImageBarEmpty, @"menu_wisard_auto_candidates.png", @"onWisardAutoCandidates:", NULL},
		{8, @"Suggest a Technique (35%)", kImageBarEmpty, @"menu_wisard_suggest_tech.png", @"onWisardSuggestTech:", NULL},
	}
};

const MenuDef _menuTransform = 
{
	4,
	nil,
	nil,
	{
		{0, @"Rotate Clockwise", kImageIconTransform, nil, @"onTransformRotateClockWise:", NULL},
		{1, @"Rotate Anti Clockwise", kImageBarEmpty, @"icon_transform_anticlockwise.png", @"onTransformRotateAntiClockWise:", NULL},
		{2, @"Flip", kImageBarEmpty, @"icon_transform_vert.png", @"onTransformMirrorVertical:", NULL},
		{3, @"Mirror", kImageBarEmpty, @"icon_transform_hor.png", @"onTransformMirrorHorisontal:", NULL},
	}
};

const MenuDef _menuFlag = 
{
	4,
	nil,
	nil,
	{
		{0, @"Mark Red", kImageBarEmpty, @"menu_flag_red.png", @"onMarkFlagRed:", NULL},
		{1, @"Mark Green", kImageBarEmpty, @"menu_flag_green.png", @"onMarkFlagGreen:", NULL},
		{2, @"Mark Blue", kImageBarEmpty, @"menu_flag_blue.png", @"onMarkFlagBlue:", NULL},
		{3, @"Mark Orange", kImageBarEmpty, @"menu_flag_orange.png", @"onMarkFlagOrange:", NULL}
	}
};
