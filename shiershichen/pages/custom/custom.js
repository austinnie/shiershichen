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
