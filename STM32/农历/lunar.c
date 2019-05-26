/*************
 	lunar.c
	
	Description:
	Chinese lunar caleander
	
	Creator:
	DT9025A
	
	Modifier:
	
	Functions:
	u8 lunarCalendar(u16 year, u8 month, u8 day, u8 *iTianGan, u8 *iDiZhi, u8 *iChDay, u8 *iChMonth)
	return: 1=leap year
	year,month,day: date to calculate
	*iTianGan,*iDiZhi: index of tiangan&dizhi
	*iChDay,*iChMonth: lunar caleander day&month
	
	Reference:
	https://blog.csdn.net/syrchina/article/details/8538516
*************/

#include "lunar.h"

u8 lunarCalendar (u16 year, u8 month, u8 day, u8 *iTianGan, u8 *iDiZhi, u8 *iChDay, u8 *iChMonth) {
    long Spring_NY, Sun_NY;
    int index, flag, StaticDayCount;
    *iTianGan = year % 10;
    *iDiZhi = year % 12;
    //Spring_NY 记录春节离当年元旦的天数。
    //Sun_NY 记录阳历日离当年元旦的天数。
    if (((lunarCalendarTable[year - 2011] & 0x0060) >> 5) == 1)
        Spring_NY = (lunarCalendarTable[year - 2011] & 0x001F) - 1;
    else
        Spring_NY = (lunarCalendarTable[year - 2011] & 0x001F) - 1 + 31;
    Sun_NY = MonthAdd[month - 1] + day - 1;
    if ( (! (year % 4)) && (month > 2))
        Sun_NY++;
    //StaticDayCount记录大小月的天数 29 或30
    //index 记录从哪个月开始来计算。
    //flag 是用来对闰月的特殊处理。
    //判断阳历日在春节前还是春节后
    if (Sun_NY >= Spring_NY) { //阳历日在春节后（含春节那天）
        Sun_NY -= Spring_NY;
        month = 1;
        index = 1;
        flag = 0;
        if ((lunarCalendarTable[year - 2011] & (0x80000 >> (index - 1)) ) == 0)
            StaticDayCount = 29;
        else
            StaticDayCount = 30;
        while (Sun_NY >= StaticDayCount) {
            Sun_NY -= StaticDayCount;
            index++;
            if (month == ((lunarCalendarTable[year - 2011] & 0xF00000) >> 20) ) {
                flag = ~flag;
                if (flag == 0)
                    month++;
            } else
                month++;
            if ((lunarCalendarTable[year - 2011] & (0x80000 >> (index - 1)) ) == 0)
                StaticDayCount = 29;
            else
                StaticDayCount = 30;
        }
        day = Sun_NY + 1;
    } else { //阳历日在春节前
        Spring_NY -= Sun_NY;
        year--;
        month = 12;
        if ( ((lunarCalendarTable[year - 2011] & 0xF00000) >> 20) == 0)
            index = 12;
        else
            index = 13;
        flag = 0;
        if ( ( lunarCalendarTable[year - 2011] & (0x80000 >> (index - 1)) ) == 0)
            StaticDayCount = 29;
        else
            StaticDayCount = 30;
        while (Spring_NY > StaticDayCount) {
            Spring_NY -= StaticDayCount;
            index--;
            if (flag == 0)
                month--;
            if (month == ((lunarCalendarTable[year - 2011] & 0xF00000) >> 20))
                flag = ~flag;
            if ( ( lunarCalendarTable[year - 2011] & (0x80000 >> (index - 1)) ) == 0)
                StaticDayCount = 29;
            else
                StaticDayCount = 30;
        }
        day = StaticDayCount - Spring_NY + 1;
    }
    *iChDay = day;
    *iChMonth = month;
    if (month == ((lunarCalendarTable[year - 2011] & 0xF00000) >> 20))
        return 1; //闰年
    else
        return 0;
}
