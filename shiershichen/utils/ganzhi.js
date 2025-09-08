// 天干地支对应表
const TIANGAN = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"];
const DIZHI = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"];

// 五虎遁月干支表
const WU_HU_DUN_TABLE = {
  "甲": ["丙寅", "丁卯", "戊辰", "己巳", "庚午", "辛未", "壬申", "癸酉", "甲戌", "乙亥", "丙子", "丁丑"],
  "己": ["丙寅", "丁卯", "戊辰", "己巳", "庚午", "辛未", "壬申", "癸酉", "甲戌", "乙亥", "丙子", "丁丑"],
  "乙": ["戊寅", "己卯", "庚辰", "辛巳", "壬午", "癸未", "甲申", "乙酉", "丙戌", "丁亥", "戊子", "己丑"],
  "庚": ["戊寅", "己卯", "庚辰", "辛巳", "壬午", "癸未", "甲申", "乙酉", "丙戌", "丁亥", "戊子", "己丑"],
  "丙": ["庚寅", "辛卯", "壬辰", "癸巳", "甲午", "乙未", "丙申", "丁酉", "戊戌", "己亥", "庚子", "辛丑"],
  "辛": ["庚寅", "辛卯", "壬辰", "癸巳", "甲午", "乙未", "丙申", "丁酉", "戊戌", "己亥", "庚子", "辛丑"],
  "丁": ["壬寅", "癸卯", "甲辰", "乙巳", "丙午", "丁未", "戊申", "己酉", "庚戌", "辛亥", "壬子", "癸丑"],
  "壬": ["壬寅", "癸卯", "甲辰", "乙巳", "丙午", "丁未", "戊申", "己酉", "庚戌", "辛亥", "壬子", "癸丑"],
  "戊": ["甲寅", "乙卯", "丙辰", "丁巳", "戊午", "己未", "庚申", "辛酉", "壬戌", "癸亥", "甲子", "乙丑"],
  "癸": ["甲寅", "乙卯", "丙辰", "丁巳", "戊午", "己未", "庚申", "辛酉", "壬戌", "癸亥", "甲子", "乙丑"]
};

// 五鼠遁时干支表
const WU_SHU_DUN_TABLE = {
  "甲": ["甲子", "乙丑", "丙寅", "丁卯", "戊辰", "己巳", "庚午", "辛未", "壬申", "癸酉", "甲戌", "乙亥"],
  "己": ["甲子", "乙丑", "丙寅", "丁卯", "戊辰", "己巳", "庚午", "辛未", "壬申", "癸酉", "甲戌", "乙亥"],
  "乙": ["丙子", "丁丑", "戊寅", "己卯", "庚辰", "辛巳", "壬午", "癸未", "甲申", "乙酉", "丙戌", "丁亥"],
  "庚": ["丙子", "丁丑", "戊寅", "己卯", "庚辰", "辛巳", "壬午", "癸未", "甲申", "乙酉", "丙戌", "丁亥"],
  "丙": ["戊子", "己丑", "庚寅", "辛卯", "壬辰", "癸巳", "甲午", "乙未", "丙申", "丁酉", "戊戌", "己亥"],
  "辛": ["戊子", "己丑", "庚寅", "辛卯", "壬辰", "癸巳", "甲午", "乙未", "丙申", "丁酉", "戊戌", "己亥"],
  "丁": ["庚子", "辛丑", "壬寅", "癸卯", "甲辰", "乙巳", "丙午", "丁未", "戊申", "己酉", "庚戌", "辛亥"],
  "壬": ["庚子", "辛丑", "壬寅", "癸卯", "甲辰", "乙巳", "丙午", "丁未", "戊申", "己酉", "庚戌", "辛亥"],
  "戊": ["壬子", "癸丑", "甲寅", "乙卯", "丙辰", "丁巳", "戊午", "己未", "庚申", "辛酉", "壬戌", "癸亥"],
  "癸": ["壬子", "癸丑", "甲寅", "乙卯", "丙辰", "丁巳", "戊午", "己未", "庚申", "辛酉", "壬戌", "癸亥"]
};

// 获取年份干支
function getGanzhiYear(year) {
  const lastDigit = year % 10;
  const remainder = year % 12;
  
  const tianganMap = {
    4: "甲", 5: "乙", 6: "丙", 7: "丁", 8: "戊",
    9: "己", 0: "庚", 1: "辛", 2: "壬", 3: "癸"
  };
  
  const dizhiMap = {
    4: "子", 5: "丑", 6: "寅", 7: "卯", 8: "辰",
    9: "巳", 10: "午", 11: "未", 0: "申", 
    1: "酉", 2: "戌", 3: "亥"
  };
  
  return tianganMap[lastDigit] + dizhiMap[remainder];
}

// 获取月份干支
function getGanzhiMonth(year, month) {
  const yearGz = getGanzhiYear(year);
  const yearTiangan = yearGz[0];
  return WU_HU_DUN_TABLE[yearTiangan][month - 1];
}

// 获取日干支
function getGanzhiDay(date) {
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  
  // 计算当年日数
  const daysInMonth = [31, ((year % 4 === 0 && year % 100 !== 0) || year % 400 === 0) ? 29 : 28, 
                      31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  let totalDays = 0;
  for (let i = 0; i < month - 1; i++) {
    totalDays += daysInMonth[i];
  }
  totalDays += day;
  
  // 计算公式
  const C = (year - 1) * 5 + Math.floor((year - 1) / 4) + totalDays;
  const remainder = C % 60;
  
  // 计算天干地支
  const tianganIndex = (remainder === 0 ? 60 : remainder - 1) % 10;
  const dizhiIndex = (remainder === 0 ? 60 : remainder - 1) % 12;
  
  return TIANGAN[tianganIndex] + DIZHI[dizhiIndex];
}

// 获取时辰干支
function getGanzhiHour(hour, dayGanzhi) {
  const dayTiangan = dayGanzhi[0];
  const hourIndex = Math.floor((hour + 1) / 2) % 12;
  return WU_SHU_DUN_TABLE[dayTiangan][hourIndex];
}

// 获取时辰名称
function getHourName(hour) {
  const hourIndex = Math.floor((hour + 1) / 2) % 12;
  return DIZHI[hourIndex] + "时";
}

module.exports = {
  getGanzhiYear,
  getGanzhiMonth,
  getGanzhiDay,
  getGanzhiHour,
  getHourName
};
