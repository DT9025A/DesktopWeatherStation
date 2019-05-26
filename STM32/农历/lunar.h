/*************
 	lunar.h
	
	Description:
	Header file of lunar.c
	
	Creator:
	DT9025A
	
	Modifier:
	
	Functions:
	See in lunar.c
	
	Reference:
	https://blog.csdn.net/syrchina/article/details/8538516
	
	Encode:
	This file should be encoded in GB2312
*************/

#ifndef __LUNAR_H
#define __LUNAR_H

#include "sys.h"

const char *tianGan[] = {"庚", "辛", "壬", "癸", "甲", "乙", "丙", "丁", "戊", "己"};
const char *diZhi[] = {"申", "酉", "戌", "亥", "子", "丑", "寅", "卯", "辰", "巳", "午", "未"};
const char *ChDay[] = {"", "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
							"十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
							"廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"};
const char *ChMonth[] = {"", "正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "腊"};

const u32 lunarCalendarTable[] = {
    0x0B4A43, 0x4B5537, 0x0AD54A, 0x955ABF, 0x04BA53, 0x0A5B48, 0x652BBC, 0x052B50, 0x0A9345, 0x474AB9, /*2011-2020*/
    0x06AA4C, 0x0AD541, 0x24DAB6, 0x04B64A, 0x69573D, 0x0A4E51, 0x0D2646, 0x5E933A, 0x0D534D, 0x05AA43, /*2021-2030*/
    0x36B537, 0x096D4B, 0xB4AEBF, 0x04AD53, 0x0A4D48, 0x6D25BC, 0x0D254F, 0x0D5244, 0x5DAA38, 0x0B5A4C, /*2031-2040*/
    0x056D41, 0x24ADB6, 0x049B4A, 0x7A4BBE, 0x0A4B51, 0x0AA546, 0x5B52BA, 0x06D24E, 0x0ADA42, 0x355B37, /*2041-2050*/
    0x09374B, 0x8497C1, 0x049753, 0x064B48, 0x66A53C, 0x0EA54F, 0x06B244, 0x4AB638, 0x0AAE4C, 0x092E42, /*2051-2060*/
    0x3C9735, 0x0C9649, 0x7D4ABD, 0x0D4A51, 0x0DA545, 0x55AABA, 0x056A4E, 0x0A6D43, 0x452EB7, 0x052D4B, /*2061-2070*/
    0x8A95BF, 0x0A9553, 0x0B4A47, 0x6B553B, 0x0AD54F, 0x055A45, 0x4A5D38, 0x0A5B4C, 0x052B42, 0x3A93B6, /*2071-2080*/
    0x069349, 0x7729BD, 0x06AA51, 0x0AD546, 0x54DABA, 0x04B64E, 0x0A5743, 0x452738, 0x0D264A, 0x8E933E, /*2081-2090*/
    0x0D5252, 0x0DAA47, 0x66B53B, 0x056D4F, 0x04AE45, 0x4A4EB9, 0x0A4D4C, 0x0D1541, 0x2D92B5 /*2091-2099*/
};

const u16 MonthAdd[12] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};

//参数:[I]年,[I]月,[I]日,[O]天干,[O]地支,[O]农历日,[O]农历月
u8 lunarCalendar (u16, u8, u8, u8, u8, u8, u8);

#endif
