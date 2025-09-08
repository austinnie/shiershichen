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
