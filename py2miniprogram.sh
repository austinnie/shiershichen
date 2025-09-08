#!/bin/bash

# 创建项目目录结构
mkdir -p shiershichen/{pages/{index,current,custom},utils,assets/{icons,images}}

# 创建根目录文件
cat > shiershichen/app.js << 'EOF'
App({
  onLaunch: function() {
    // 小程序初始化
  },
  globalData: {
    userInfo: null
  }
})
EOF

cat > shiershichen/app.json << 'EOF'
{
  "pages": [
    "pages/index/index",
    "pages/current/current",
    "pages/custom/custom"
  ],
  "window": {
    "backgroundTextStyle": "light",
    "navigationBarBackgroundColor": "#8B4513",
    "navigationBarTitleText": "十二时辰预兆",
    "navigationBarTextStyle": "white"
  },
  "style": "v2",
  "sitemapLocation": "sitemap.json"
}
EOF

cat > shiershichen/app.wxss << 'EOF'
/* 全局样式 */
page {
  background-color: #f8f8f8;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
}

.container {
  padding: 20px;
}

.header {
  margin-bottom: 30px;
  text-align: center;
}

.title {
  font-size: 24px;
  font-weight: bold;
  color: #333;
}

.menu-item {
  display: block;
  padding: 15px;
  margin: 10px 0;
  background-color: #fff;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.footer {
  margin-top: 30px;
  text-align: center;
  color: #999;
  font-size: 12px;
}
EOF

cat > shiershichen/project.config.json << 'EOF'
{
  "description": "项目配置文件",
  "setting": {
    "urlCheck": true,
    "es6": true,
    "postcss": true,
    "minified": true,
    "newFeature": true
  },
  "compileType": "miniprogram",
  "libVersion": "2.15.0",
  "appid": "your-appid",
  "projectname": "shiershichen",
  "condition": {
    "searchCondition": {
      "current": -1,
      "list": []
    },
    "conversationCondition": {
      "current": -1,
      "list": []
    },
    "miniprogram": {
      "current": -1,
      "list": []
    }
  }
}
EOF

cat > shiershichen/sitemap.json << 'EOF'
{
  "rules": [{
    "action": "allow",
    "page": "*"
  }]
}
EOF

# 创建首页文件
cat > shiershichen/pages/index/index.wxml << 'EOF'
<view class="container">
  <view class="header">
    <text class="title">十二时辰临身预兆查询系统</text>
  </view>
  
  <view class="menu">
    <navigator url="/pages/current/current" class="menu-item" hover-class="none">
      <text>查询当前时间的预兆</text>
    </navigator>
    
    <navigator url="/pages/custom/custom" class="menu-item" hover-class="none">
      <text>查询指定时间的预兆</text>
    </navigator>
  </view>
  
  <view class="footer">
    <text>传统文化研究工具</text>
  </view>
</view>
EOF

cat > shiershichen/pages/index/index.js << 'EOF'
Page({
  data: {},
  onLoad: function(options) {
    // 页面创建时执行
  }
})
EOF

cat > shiershichen/pages/index/index.json << 'EOF'
{
  "navigationBarTitleText": "首页"
}
EOF

touch shiershichen/pages/index/index.wxss

# 创建当前时间查询页
cat > shiershichen/pages/current/current.wxml << 'EOF'
<view class="container">
  <view class="header">
    <text class="title">当前时间预兆查询</text>
  </view>
  
  <view class="time-info">
    <text>当前时间: {{currentTime}}</text>
    <text>农历日期: {{lunarDate}}</text>
    <text>年柱: {{yearGanzhi}}</text>
    <text>月柱: {{monthGanzhi}}</text>
    <text>日柱: {{dayGanzhi}}</text>
    <text>时柱: {{hourGanzhi}}</text>
    <text>时辰: {{hourName}}</text>
  </view>
  
  <picker mode="selector" range="{{omenTypes}}" range-key="name" bindchange="selectOmenType">
    <view class="picker">选择预兆类型: {{selectedOmenType}}</view>
  </picker>
  
  <view wx:if="{{showSidePicker}}">
    <picker mode="selector" range="{{['左', '右']}}" bindchange="selectSide">
      <view class="picker">选择侧别: {{selectedSide}}</view>
    </picker>
  </view>
  
  <view wx:if="{{showGenderPicker}}">
    <picker mode="selector" range="{{['男', '女']}}" bindchange="selectGender">
      <view class="picker">选择性别: {{selectedGender}}</view>
    </picker>
  </view>
  
  <button bindtap="queryOmen" type="primary">查询预兆</button>
  
  <view wx:if="{{omenResult}}" class="result">
    <text class="result-title">预兆解释</text>
    <text class="result-content">{{omenResult}}</text>
  </view>
  
  <navigator url="/pages/index/index" class="back-link">
    <text>返回首页</text>
  </navigator>
</view>
EOF

cat > shiershichen/pages/current/current.js << 'EOF'
const { getGanzhiYear, getGanzhiMonth, getGanzhiDay, getGanzhiHour, getHourName } = require('../../utils/ganzhi');
const { getOmenInfo, getOmenTypes } = require('../../utils/omen');
const { getLunarDate } = require('../../utils/lunar');

Page({
  data: {
    currentTime: '',
    lunarDate: '',
    yearGanzhi: '',
    monthGanzhi: '',
    dayGanzhi: '',
    hourGanzhi: '',
    hourName: '',
    omenTypes: [],
    selectedOmenType: '',
    selectedSide: '',
    selectedGender: '',
    showSidePicker: false,
    showGenderPicker: false,
    omenResult: ''
  },

  onLoad: function() {
    this.setCurrentTimeInfo();
    this.setData({
      omenTypes: getOmenTypes()
    });
  },

  setCurrentTimeInfo: function() {
    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth() + 1;
    const day = now.getDate();
    const hour = now.getHours();
    
    const lunarInfo = getLunarDate(now);
    
    this.setData({
      currentTime: `${year}年${month}月${day}日 ${hour}时`,
      lunarDate: lunarInfo.lunarStr,
      yearGanzhi: getGanzhiYear(year),
      monthGanzhi: getGanzhiMonth(year, month),
      dayGanzhi: getGanzhiDay(now),
      hourGanzhi: getGanzhiHour(hour, getGanzhiDay(now)),
      hourName: getHourName(hour)
    });
  },

  selectOmenType: function(e) {
    const index = e.detail.value;
    const omenType = this.data.omenTypes[index].name;
    
    this.setData({
      selectedOmenType: omenType,
      showSidePicker: ['占眼跳法', '占眼润法', '占耳鸣法', '占耳痒法', '占踢足法'].includes(omenType),
      showGenderPicker: omenType === '占衣留法'
    });
  },

  selectSide: function(e) {
    this.setData({
      selectedSide: ['左', '右'][e.detail.value]
    });
  },

  selectGender: function(e) {
    this.setData({
      selectedGender: ['男', '女'][e.detail.value]
    });
  },

  queryOmen: function() {
    if (!this.data.selectedOmenType) {
      wx.showToast({
        title: '请选择预兆类型',
        icon: 'none'
      });
      return;
    }
    
    const result = getOmenInfo(
      this.data.selectedOmenType,
      this.data.hourName.replace('时', '') + '时',
      this.data.selectedSide,
      this.data.selectedGender
    );
    
    this.setData({
      omenResult: result
    });
  }
});
EOF

cat > shiershichen/pages/current/current.json << 'EOF'
{
  "navigationBarTitleText": "当前时间查询"
}
EOF

cat > shiershichen/pages/current/current.wxss << 'EOF'
.time-info {
  background-color: #fff;
  padding: 15px;
  margin-bottom: 20px;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.time-info text {
  display: block;
  margin-bottom: 8px;
}

.picker {
  background-color: #fff;
  padding: 15px;
  margin-bottom: 10px;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.result {
  margin-top: 20px;
  background-color: #fff;
  padding: 15px;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.result-title {
  font-weight: bold;
  display: block;
  margin-bottom: 10px;
}

.back-link {
  display: block;
  margin-top: 20px;
  text-align: center;
  color: #8B4513;
}
EOF

# 创建自定义时间查询页
cat > shiershichen/pages/custom/custom.wxml << 'EOF'
<view class="container">
  <view class="header">
    <text class="title">指定时间预兆查询</text>
  </view>
  
  <view class="date-type">
    <radio-group bindchange="changeDateType">
      <label><radio value="solar" checked/>公历日期</label>
      <label><radio value="lunar"/>农历日期</label>
    </radio-group>
  </view>
  
  <picker mode="date" fields="year" bindchange="changeYear">
    <view class="picker">选择年份: {{selectedYear}}</view>
  </picker>
  
  <picker mode="date" fields="month" bindchange="changeMonth">
    <view class="picker">选择月份: {{selectedMonth}}</view>
  </picker>
  
  <picker mode="date" fields="day" bindchange="changeDay">
    <view class="picker">选择日期: {{selectedDay}}</view>
  </picker>
  
  <picker mode="time" bindchange="changeHour">
    <view class="picker">选择时间: {{selectedHour}}</view>
  </picker>
  
  <picker mode="selector" range="{{omenTypes}}" range-key="name" bindchange="selectOmenType">
    <view class="picker">选择预兆类型: {{selectedOmenType}}</view>
  </picker>
  
  <view wx:if="{{showSidePicker}}">
    <picker mode="selector" range="{{['左', '右']}}" bindchange="selectSide">
      <view class="picker">选择侧别: {{selectedSide}}</view>
    </picker>
  </view>
  
  <view wx:if="{{showGenderPicker}}">
    <picker mode="selector" range="{{['男', '女']}}" bindchange="selectGender">
      <view class="picker">选择性别: {{selectedGender}}</view>
    </picker>
  </view>
  
  <button bindtap="queryOmen" type="primary">查询预兆</button>
  
  <view wx:if="{{omenResult}}" class="result">
    <text class="result-title">预兆解释</text>
    <text class="result-content">{{omenResult}}</text>
  </view>
  
  <navigator url="/pages/index/index" class="back-link">
    <text>返回首页</text>
  </navigator>
</view>
EOF

cat > shiershichen/pages/custom/custom.js << 'EOF'
const { getGanzhiYear, getGanzhiMonth, getGanzhiDay, getGanzhiHour, getHourName } = require('../../utils/ganzhi');
const { getOmenInfo, getOmenTypes } = require('../../utils/omen');
const { getLunarDate } = require('../../utils/lunar');

Page({
  data: {
    dateType: 'solar',
    selectedYear: '请选择年份',
    selectedMonth: '请选择月份',
    selectedDay: '请选择日期',
    selectedHour: '请选择时间',
    lunarDate: '',
    yearGanzhi: '',
    monthGanzhi: '',
    dayGanzhi: '',
    hourGanzhi: '',
    hourName: '',
    omenTypes: [],
    selectedOmenType: '',
    selectedSide: '',
    selectedGender: '',
    showSidePicker: false,
    showGenderPicker: false,
    omenResult: ''
  },

  onLoad: function() {
    this.setData({
      omenTypes: getOmenTypes()
    });
  },

  changeDateType: function(e) {
    this.setData({
      dateType: e.detail.value
    });
  },

  changeYear: function(e) {
    this.setData({
      selectedYear: e.detail.value
    });
  },

  changeMonth: function(e) {
    this.setData({
      selectedMonth: e.detail.value
    });
  },

  changeDay: function(e) {
    this.setData({
      selectedDay: e.detail.value
    });
  },

  changeHour: function(e) {
    this.setData({
      selectedHour: e.detail.value
    });
  },

  selectOmenType: function(e) {
    const index = e.detail.value;
    const omenType = this.data.omenTypes[index].name;
    
    this.setData({
      selectedOmenType: omenType,
      showSidePicker: ['占眼跳法', '占眼润法', '占耳鸣法', '占耳痒法', '占踢足法'].includes(omenType),
      showGenderPicker: omenType === '占衣留法'
    });
  },

  selectSide: function(e) {
    this.setData({
      selectedSide: ['左', '右'][e.detail.value]
    });
  },

  selectGender: function(e) {
    this.setData({
      selectedGender: ['男', '女'][e.detail.value]
    });
  },

  queryOmen: function() {
    if (!this.data.selectedYear || !this.data.selectedMonth || !this.data.selectedDay || !this.data.selectedHour) {
      wx.showToast({
        title: '请完整选择时间',
        icon: 'none'
      });
      return;
    }
    
    if (!this.data.selectedOmenType) {
      wx.showToast({
        title: '请选择预兆类型',
        icon: 'none'
      });
      return;
    }
    
    const year = parseInt(this.data.selectedYear);
    const month = parseInt(this.data.selectedMonth);
    const day = parseInt(this.data.selectedDay);
    const hour = parseInt(this.data.selectedHour.split(':')[0]);
    
    let date;
    if (this.data.dateType === 'solar') {
      date = new Date(year, month - 1, day);
    } else {
      // 农历处理逻辑
      date = new Date(year, month - 1, day); // 简化处理，实际应使用农历转换
    }
    
    const lunarInfo = getLunarDate(date);
    const dayGanzhi = getGanzhiDay(date);
    
    this.setData({
      lunarDate: lunarInfo.lunarStr,
      yearGanzhi: getGanzhiYear(year),
      monthGanzhi: getGanzhiMonth(year, month),
      dayGanzhi: dayGanzhi,
      hourGanzhi: getGanzhiHour(hour, dayGanzhi),
      hourName: getHourName(hour)
    });
    
    const result = getOmenInfo(
      this.data.selectedOmenType,
      this.data.hourName.replace('时', '') + '时',
      this.data.selectedSide,
      this.data.selectedGender
    );
    
    this.setData({
      omenResult: result
    });
  }
});
EOF

cat > shiershichen/pages/custom/custom.json << 'EOF'
{
  "navigationBarTitleText": "自定义时间查询"
}
EOF

cat > shiershichen/pages/custom/custom.wxss << 'EOF'
.date-type {
  background-color: #fff;
  padding: 15px;
  margin-bottom: 20px;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.date-type label {
  margin-right: 20px;
}

.picker {
  background-color: #fff;
  padding: 15px;
  margin-bottom: 10px;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.result {
  margin-top: 20px;
  background-color: #fff;
  padding: 15px;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.result-title {
  font-weight: bold;
  display: block;
  margin-bottom: 10px;
}

.back-link {
  display: block;
  margin-top: 20px;
  text-align: center;
  color: #8B4513;
}
EOF

# 创建工具类文件
cat > shiershichen/utils/ganzhi.js << 'EOF'
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
EOF

cat > shiershichen/utils/omen.js << 'EOF'
// 十二时辰预兆解释数据
const OMEN_DATA = {
  "占焚炉法": {
    "子时": "祖师临坛，求卜大吉",
    "丑时": "口舌是非，烦闷之事",
    "寅时": "主得大财，阴人大吉",
    "卯时": "有远客至，交会事吉",
    "辰时": "有争讼事，失财不利",
    "巳时": "音讯远至，财利大吉",
    "午时": "不顺心事，耗财烦恼",
    "未时": "贵人青睐，竭大吉昌",
    "申时": "有得官事，财帛大吉",
    "酉时": "有争执事，疾病怪事",
    "戌时": "钱物耗失，祸事临身",
    "亥时": "凡事不顺，伤灾火灾"
  },
  "占眼跳法": {
    "子时": {
      "左": "有贵人至",
      "右": "有酒食"
    },
    "丑时": {
      "左": "有忧疑",
      "右": "有人思"
    },
    "寅时": {
      "左": "有远人来",
      "右": "喜庆事"
    },
    "卯时": {
      "左": "有贵人至",
      "右": "平安吉"
    },
    "辰时": {
      "左": "有远人来",
      "右": "有损害"
    },
    "巳时": {
      "左": "有饮食",
      "右": "有凶恶"
    },
    "午时": {
      "左": "有饮食",
      "右": "有凶事"
    },
    "未时": {
      "左": "有吉事",
      "右": "有小喜"
    },
    "申时": {
      "左": "有损财",
      "右": "有女思"
    },
    "酉时": {
      "左": "有远行",
      "右": "有客至"
    },
    "戌时": {
      "左": "有客至",
      "右": "有聚会"
    },
    "亥时": {
      "左": "有客至",
      "右": "有官非"
    }
  },
  "占耳鸣法": {
    "子时": {
      "左": "有六畜吉",
      "右": "有妇思"
    },
    "丑时": {
      "左": "有口舌",
      "右": "有口舌"
    },
    "寅时": {
      "左": "有远行",
      "右": "有吉事"
    },
    "卯时": {
      "左": "有远客来",
      "右": "有远信"
    },
    "辰时": {
      "左": "有财喜",
      "右": "有行人"
    },
    "巳时": {
      "左": "有凶事",
      "右": "有大吉"
    },
    "午时": {
      "左": "有饮食",
      "右": "有凶事"
    },
    "未时": {
      "左": "有远行",
      "右": "有远信"
    },
    "申时": {
      "左": "有行人",
      "右": "有喜事"
    },
    "酉时": {
      "左": "有失财",
      "右": "有吉事"
    },
    "戌时": {
      "左": "有远行",
      "右": "有酒食"
    },
    "亥时": {
      "左": "有吉事",
      "右": "有官非"
    }
  }
};

// 获取预兆信息
function getOmenInfo(omenType, timePeriod, side = null, gender = null) {
  if (!OMEN_DATA[omenType]) {
    return "未知的预兆类型";
  }
  
  const omenData = OMEN_DATA[omenType];
  
  if (!omenData[timePeriod]) {
    return "未知的时辰";
  }
  
  const timeData = omenData[timePeriod];
  
  if (typeof timeData === 'object') {
    if (side && timeData[side]) {
      return timeData[side];
    } else if (gender && timeData[gender]) {
      return timeData[gender];
    } else {
      return "需要指定左右侧或性别";
    }
  } else {
    return timeData;
  }
}

// 获取所有预兆类型
function getOmenTypes() {
  return Object.keys(OMEN_DATA).map((key, index) => ({
    id: index + 1,
    name: key
  }));
}

module.exports = {
  getOmenInfo,
  getOmenTypes
};
EOF

cat > shiershichen/utils/lunar.js << 'EOF'
// 简化版农历计算
// 实际应用中应使用完整的农历计算库
function getLunarDate(solarDate) {
  const year = solarDate.getFullYear();
  const month = solarDate.getMonth() + 1;
  const day = solarDate.getDate();
  
  // 这里应该是完整的农历计算逻辑
  // 简化版仅返回示例数据
  return {
    lunarYear: year,
    lunarMonth: month,
    lunarDay: day,
    lunarStr: `${year}年${month}月${day}日`
  };
}

module.exports = {
  getLunarDate
};
EOF

# 创建空资源目录
touch shiershichen/assets/icons/.gitkeep
touch shiershichen/assets/images/.gitkeep

echo "十二时辰小程序项目结构已生成完毕！"
echo "请将生成的 shiershichen 目录导入微信开发者工具中运行。"
