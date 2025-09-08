// utils/lunar.js
const { getGanzhiYear, getGanzhiMonth, getGanzhiDay, getGanzhiHour, getHourName } = require('./ganzhi');

// 简化版农历日期类（模拟Python的ZhDate）
class ZhDate {
  constructor(year, month, day) {
    this.lunarYear = year;
    this.lunarMonth = month;
    this.lunarDay = day;
  }

  to_datetime() {
    // 简化处理：假设农历和公历相同
    return new Date(this.lunarYear, this.lunarMonth - 1, this.lunarDay);
  }

  toString() {
    return `${this.lunarYear}年${this.lunarMonth}月${this.lunarDay}日`;
  }

  static from_datetime(date) {
    // 简化处理：假设农历和公历相同
    return new ZhDate(date.getFullYear(), date.getMonth() + 1, date.getDate());
  }
}

function getLunarDateInfo(year, month, day, hour = 0, isLunar = false) {
  let solarDate, lunarDate, lunarYear;

  if (isLunar) {
    // 农历日期直接使用
    lunarDate = new ZhDate(year, month, day);
    solarDate = lunarDate.to_datetime();
    lunarYear = year;
  } else {
    // 阳历日期转换为农历
    solarDate = new Date(year, month - 1, day);
    lunarDate = ZhDate.from_datetime(solarDate);
    lunarYear = lunarDate.lunarYear;
  }

  // 计算干支
  const yearGanzhi = getGanzhiYear(lunarYear);
  const monthGanzhi = getGanzhiMonth(lunarYear, lunarDate.lunarMonth);
  const dayGanzhi = getGanzhiDay(solarDate);
  const hourGanzhi = getGanzhiHour(hour, dayGanzhi);
  
  // 获取时辰名称
  const hourName = getHourName(hour);

  return {
    dateType: isLunar ? "农历" : "公历",
    inputDate: `${year}年${month}月${day}日${hour}时`,
    lunarDate: lunarDate.toString(),
    yearGanzhi: yearGanzhi,
    monthGanzhi: monthGanzhi,
    dayGanzhi: dayGanzhi,
    hourGanzhi: hourGanzhi,
    hourName: hourName
  };
}

// 单独导出的getLunarDate函数（与原Python函数接口一致）
function getLunarDate(solarDate) {
  const year = solarDate.getFullYear();
  const month = solarDate.getMonth() + 1;
  const day = solarDate.getDate();
  
  const lunarInfo = getLunarDateInfo(year, month, day);
  return {
    lunarYear: lunarInfo.lunarDate.split('年')[0],
    lunarMonth: parseInt(lunarInfo.lunarDate.split('年')[1].split('月')[0]),
    lunarDay: parseInt(lunarInfo.lunarDate.split('月')[1].split('日')[0]),
    lunarStr: lunarInfo.lunarDate
  };
}

module.exports = {
  ZhDate,
  getLunarDateInfo,
  getLunarDate
};