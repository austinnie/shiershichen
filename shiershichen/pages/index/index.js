Page({
  onLoad() {
    console.log('首页加载完成');
  },
  
  // 跳转到当前时间查询页
  goToCurrent() {
    wx.navigateTo({
      url: '/pages/current/current'
    });
  },
  
  // 跳转到自定义查询页  
  goToCustom() {
    wx.navigateTo({
      url: '/pages/custom/custom'
    });
  }
})