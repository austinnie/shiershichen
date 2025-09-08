from colorama import init, Fore, Back, Style
import datetime
from zhdate import ZhDate

# 初始化colorama
init(autoreset=True)

# 颜色定义
TITLE_COLOR = Fore.CYAN + Style.BRIGHT
HEADER_COLOR = Fore.YELLOW + Style.BRIGHT
INFO_COLOR = Fore.GREEN
RESULT_COLOR = Fore.MAGENTA + Style.BRIGHT
MENU_COLOR = Fore.BLUE
PROMPT_COLOR = Fore.WHITE + Style.BRIGHT
ERROR_COLOR = Fore.RED + Style.BRIGHT
SEPARATOR_COLOR = Fore.LIGHTBLACK_EX

# 天干地支对应表
TIANGAN = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
DIZHI = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]

# 月份地支固定
MONTH_DIZHI = ["寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥", "子", "丑"]

# 五虎遁月干支表（根据年干确定各月干支）
WU_HU_DUN_TABLE = {
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
}

# 五鼠遁时干支表（根据日干确定各时辰干支）
WU_SHU_DUN_TABLE = {
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
}

# 十二时辰预兆解释数据
OMEN_DATA = {
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
    "占面热法": {
        "子时": "主喜庆事，又主得财",
        "丑时": "主有烦恼，忧虑之事",
        "寅时": "主有客来，聚会大吉",
        "卯时": "主有酒食及外人至",
        "辰时": "主有远客，喜相逢吉",
        "巳时": "主有急事，人来相见",
        "午时": "主亲来相见，命同坐",
        "未时": "主有词讼，口舌是非",
        "申时": "主有高人，会道相见",
        "酉时": "主有高人来相见",
        "戌时": "主有酒食，不叫自来",
        "亥时": "主官讼及不宁之事"
    },
    "占眼跳法": {
        "子时": {"左": "有贵人", "右": "有酒食"},
        "丑时": {"左": "有忧疑", "右": "有人悲"},
        "寅时": {"左": "远人来", "右": "喜庆事"},
        "卯时": {"左": "贵人来", "右": "平和吉"},
        "辰时": {"左": "客从来", "右": "损害事"},
        "巳时": {"左": "主酒事", "右": "主凶事"},
        "午时": {"左": "主饮食", "右": "主凶事"},
        "未时": {"左": "主有吉昌", "右": "主小喜"},
        "申时": {"左": "有财利", "右": "有友思"},
        "酉时": {"左": "有客至", "右": "主亲来"},
        "戌时": {"左": "主酒食", "右": "主聚财"},
        "亥时": {"左": "主有客", "右": "主官事"}
    },
    "占眼润法": {
        "子时": {"左": "主财喜", "右": "生烦恼"},
        "丑时": {"左": "主得财", "右": "主人思"},
        "寅时": {"left": "奴婢事", "right": "有喜事"},
        "卯时": {"left": "有惊事", "right": "有相骂"},
        "辰时": {"left": "有喜事", "right": "得财物"},
        "巳时": {"left": "贵客至", "right": "口舌事"},
        "午时": {"left": "有酒食", "right": "有恶事"},
        "未时": {"left": "有饮食", "right": "大吉事"},
        "申时": {"left": "远行事", "right": "有客来"},
        "酉时": {"left": "有饮食", "right": "有相争"},
        "戌时": {"left": "有口舌", "right": "有喜庆"},
        "亥时": {"left": "有远行", "right": "有女灾"}
    },
    "占耳热法": {
        "子时": "主有僧道来相议事",
        "丑时": "主有喜事临身，大吉",
        "寅时": "主有酒食相会，大吉",
        "卯时": "主有远人来相见，吉",
        "辰时": "主有财吉，人通达吉",
        "巳时": "主失财物之事，不利",
        "午时": "主有喜气事来，大吉",
        "未时": "主有客至相求之事",
        "申时": "主有酒食宴乐事，吉",
        "酉时": "主有女子至，婚姻事",
        "戌时": "主争讼口舌之事",
        "亥时": "主有口舌词讼之事"
    },
    "占耳鸣法": {
        "子时": {"left": "主友思", "right": "主失财"},
        "丑时": {"left": "主口舌", "right": "主争讼"},
        "寅时": {"left": "主失财", "right": "主心急"},
        "卯时": {"left": "主坎坷", "right": "主客至"},
        "辰时": {"left": "主远行", "right": "主客至"},
        "巳时": {"left": "主凶事", "right": "主大吉"},
        "午时": {"left": "主远信", "right": "主亲来"},
        "未时": {"left": "主饮食", "right": "主人来"},
        "申时": {"left": "主行人", "right": "主大吉"},
        "酉时": {"left": "主失财", "right": "主大吉"},
        "戌时": {"left": "主酒食", "right": "主客至"},
        "亥时": {"left": "主大吉", "right": "主酒食"}
    },
    "占耳痒法": {
        "子时": {"left": "主友思", "right": "主失财"},
        "丑时": {"left": "主口舌", "right": "主争讼"},
        "寅时": {"left": "主失财", "right": "主心急"},
        "卯时": {"left": "主坎坷", "right": "主客至"},
        "辰时": {"left": "主远行", "right": "主客至"},
        "巳时": {"left": "主凶事", "right": "主大吉"},
        "午时": {"left": "主远信", "right": "主亲来"},
        "未时": {"left": "主饮食", "right": "主人来"},
        "申时": {"left": "主行人", "right": "主大吉"},
        "酉时": {"left": "主失财", "right": "主大吉"},
        "戌时": {"left": "主酒食", "right": "主客至"},
        "亥时": {"left": "主大吉", "right": "主酒食"}
    },
    "占喷嚏法": {
        "子时": "主逢吉人，酒食相会",
        "丑时": "情人默思，客人求事",
        "寅时": "主男女相遇，有酒食",
        "卯时": "主财喜有客来，同事",
        "辰时": "主人有酒食，大吉利",
        "巳时": "主有吉人来求财，喜",
        "午时": "主有客旅，酒会宴饮",
        "未时": "主酒食相会合之事",
        "申时": "夜梦惊恐，酒食不利",
        "酉时": "主阴人来求请问事",
        "戌时": "主情人思会和合事",
        "亥时": "主有虚惊，反得吉利"
    },
    "占心惊法": {
        "子时": "主有情子思喜事至",
        "丑时": "主有恶事临门则凶",
        "寅时": "主有客来，饮食大吉",
        "卯时": "主有酒食事，外人来",
        "辰时": "主成名喜事，大吉利",
        "巳时": "主情人思，多喜事至",
        "午时": "主有酒食自来，大吉",
        "未时": "主有情人思念，大吉",
        "申时": "主有大喜之事，吉利",
        "酉时": "主有喜信至，大吉庆",
        "戌时": "主有贵人即至，大吉",
        "亥时": "主有恶人，占身大凶"
    },
    "占肉颤法": {
        "子时": "主有尊长人来，大吉",
        "丑时": "主有吉祥临身，大吉",
        "寅时": "主有凶事，化凶为吉",
        "卯时": "主有得财事，大吉利",
        "辰时": "主凶恶临身，大凶",
        "巳时": "主宾友相见，大吉利",
        "午时": "主有忧疑事，自身吉",
        "未时": "主有喜事，占身大吉",
        "申时": "主有口舌，解之则吉",
        "酉时": "主因财起祸事，大凶",
        "戌时": "主有行人远来，大吉",
        "亥时": "主有大吉利，喜庆之事"
    },
    "占手痒法": {
        "子时": "得饮食，酒会之事吉",
        "丑时": "有贵人来，情人相思",
        "寅时": "有忧思之事，烦恼",
        "卯时": "君子来回之事，吉",
        "辰时": "有客来，合作事大利",
        "巳时": "有思念儿子消息事",
        "午时": "有妻之事，相请之事",
        "未时": "有爱念相思之事，财吉",
        "申时": "有远行这事，有财来",
        "酉时": "有进退事，小心则吉",
        "戌时": "有县官口舌之事",
        "亥时": "有远行这事，忧愁"
    },
    "占足痒法": {
        "子时": "有远客来，恶事将至",
        "丑时": "有市贾事，财利顺吉",
        "寅时": "有人骂之口舌是非",
        "卯时": "有贵之事，求财大吉",
        "辰时": "有恨之意，或有恶事",
        "巳时": "有喜事，情人相思事",
        "午时": "有人呼情之事，顺吉",
        "未时": "有好事酒食相顾之",
        "申时": "有远行事，烦累苦心",
        "酉时": "有男女事，合之吉祥",
        "戌时": "有酒肉事，对坐争强",
        "亥时": "有酒肉事，对坐而吉"
    },
    "占踢足法": {
        "子时": {"left": "异性相思，是非口舌", "right": "有酒食事，有亲相问"},
        "丑时": {"left": "损害伤财，争讼不吉", "right": "伤害之事，吉事平和"},
        "寅时": {"left": "远客至，一日白忙", "right": "饮食之事，有女相思"},
        "卯时": {"left": "有掌权事，口舌烦恼", "right": "不客远至，口舌是非"},
        "辰时": {"left": "有忧愁事，得财之喜", "right": "遇小人害，开心聚财"},
        "巳时": {"left": "贵人相及，合会之喜", "right": "得财相投，好事成双"}
    },
    "占衣留法": {
        "子时": {"男": "酒食", "女": "亲事"},
        "丑时": "主有忧思破财之事",
        "寅时": "望夫进财昌，大吉利",
        "卯时": "主酒食、交友、同会吉",
        "辰时": "主自失财、忧灾、疾病",
        "巳时": {"女": "外心", "男": "无凶事"},
        "午时": "主远人至，得利、大吉",
        "未时": "血光之灾，化凶为吉",
        "申时": "主得外财，出入大吉",
        "酉时": "主有客至，破财、不利",
        "戌时": "主词讼，得财、大吉",
        "亥时": "主有喜事，得财、大吉"
    },
    "占火逸法": {
        "子时": "妻有外心，烦闷之事",
        "丑时": "女心向外，大不吉利",
        "寅时": "得小喜、平安大吉利",
        "卯时": "主得财帛，享通之兆",
        "辰时": "主忧心，损男小口，灾",
        "巳时": "主有喜事，酒食相逢",
        "午时": "有相争见官、火灾事",
        "未时": "主得财喜昌盛之兆",
        "申时": "主得财帛，会合事，吉",
        "酉时": "主有凶事，豹变之兆",
        "戌时": "主忧心，见得理之兆",
        "亥时": "主身疾病，妨害之兆"
    },
    "占斧鸣法": {
        "子时": "主六畜平安，大吉利",
        "丑时": "主家宅定，富贵，大吉",
        "寅时": "主家宅凶，怪事，大凶",
        "卯时": "主家们祸事至，大凶",
        "辰时": "主宜田蚕，有利，大吉",
        "巳时": "有福至财来，大吉",
        "午时": "主官事消散，大吉昌",
        "未时": "主有凶祸之事，不利",
        "申时": "主远人来，昌盛，大吉",
        "酉时": "主远行人来，大吉利",
        "戌时": "主有小喜，享通，大吉",
        "亥时": "主官事有理，大吉昌"
    },
    "占断甲法": {
        "子时": "有不尽意事，财上吉祥",
        "丑时": "有合作事，喜事临身",
        "寅时": "有耗财之事，音信吉",
        "卯时": "有酒食事，远客至",
        "辰时": "老情人相思，又主音信",
        "巳时": "有朋友相托事，主吉",
        "午时": "事有虚惊，会朋友吉",
        "未时": "有不如意事，吉庆祥和",
        "申时": "有欢喜事，有小人碍障",
        "酉时": "有和合事，则上见喜",
        "戌时": "有忧疑事，解之则吉",
        "亥时": "事有不吉，财上有失"
    },
    "占鹊噪法": {
        "子时": "主有远亲人至，大吉",
        "丑时": "主有喜庆之事，大吉",
        "寅时": "主有词讼之事，小吉",
        "卯时": "主有酒食财喜，大吉",
        "辰时": "主有远行人至家，吉",
        "巳时": "主有喜事降临，大吉",
        "午时": "主有疾病，求神安，吉",
        "未时": "主有六畜不见之事",
        "申时": "主有喜庆事，大吉昌",
        "酉时": "主有坎坷，不宁之事",
        "戌时": "主有财帛享通，大吉",
        "亥时": "主有口舌争斗之事"
    },
    "占犬嚎法": {
        "子时": "主有妇人不时之争",
        "丑时": "主有忧闷忧心之事",
        "寅时": "在上进财，昌，大吉利",
        "卯时": "在上必得财，大吉",
        "辰时": "主喜事至，大享通，吉",
        "巳时": "主有亲人相会，信至",
        "午时": "主逢酒食宴会，大吉",
        "未时": "主有家中内外破财",
        "申时": "主家宅有小口之忧",
        "酉时": "加官进禄，必定得财",
        "戌时": "主有口舌之事，大凶",
        "亥时": "主有官非词讼之事"
    }
}

def print_separator(length=40, char='-'):
    """打印彩色分隔线"""
    print(SEPARATOR_COLOR + char * length)

def print_title(title):
    """打印彩色标题"""
    print("\n" + TITLE_COLOR + "=" * 40)
    print(TITLE_COLOR + title.center(40))
    print(TITLE_COLOR + "=" * 40)

def print_header(header):
    """打印彩色小标题"""
    print("\n" + HEADER_COLOR + header)
    print_separator()

def print_info(label, value):
    """打印彩色信息"""
    print(INFO_COLOR + f"{label}: {RESULT_COLOR}{value}")

def print_result(label, value):
    """打印彩色结果"""
    print("\n" + RESULT_COLOR + f"{label}: {value}")
    print_separator()
    
def get_ganzhi_year(year):
    """获取年份干支（优化版）"""
    last_digit = year % 10  # 获取年份最后一位数字
    remainder = year % 12   # 计算除以12的余数
    
    # 天干映射
    tiangan_map = {
        4: "甲", 5: "乙", 6: "丙", 7: "丁", 8: "戊",
        9: "己", 0: "庚", 1: "辛", 2: "壬", 3: "癸"
    }
    
    # 地支映射
    dizhi_map = {
        4: "子", 5: "丑", 6: "寅", 7: "卯", 8: "辰",
        9: "巳", 10: "午", 11: "未", 0: "申", 
        1: "酉", 2: "戌", 3: "亥"
    }
    
    return tiangan_map[last_digit] + dizhi_map[remainder]

def get_ganzhi_month(year, month):
    """获取月份干支（速查表优化版）"""
    year_gz = get_ganzhi_year(year)
    year_tiangan = year_gz[0]
    return WU_HU_DUN_TABLE[year_tiangan][month - 1]

def get_ganzhi_day(date):
    """
    根据公历日期计算当日干支（按照图片中的方法）
    参数:
        date: datetime.date对象
    返回:
        干支字符串(如"甲子")
    """
    year = date.year
    month = date.month
    day = date.day
    
    # 计算当年日数
    days_in_month = [31, 28 if year % 4 != 0 or (year % 100 == 0 and year % 400 != 0) else 29, 
                     31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    total_days = sum(days_in_month[:month-1]) + day
    
    # 计算公式
    C = (year - 1) * 5 + (year - 1) // 4 + total_days
    remainder = C % 60
    
    # 计算天干地支（注意余数为0时特殊处理）
    if remainder == 0:
        remainder = 60
    
    tiangan_index = (remainder - 1) % 10
    dizhi_index = (remainder - 1) % 12
    
    return TIANGAN[tiangan_index] + DIZHI[dizhi_index]

def get_ganzhi_hour(hour, day_ganzhi):
    """获取时辰干支（速查表优化版）"""
    day_tiangan = day_ganzhi[0]
    hour_index = (hour + 1) // 2 % 12
    return WU_SHU_DUN_TABLE[day_tiangan][hour_index]

def get_lunar_date_info(year, month, day, hour=0, is_lunar=False):
    """
    获取完整的干支信息
    :param year: 年
    :param month: 月
    :param day: 日
    :param hour: 时（0-23）
    :param is_lunar: 是否为农历日期
    :return: 干支信息字典
    """
    if is_lunar:
        # 农历日期直接使用
        lunar_date = ZhDate(year, month, day)
        solar_date = lunar_date.to_datetime()
        lunar_year = year
    else:
        # 阳历日期转换为农历
        solar_date = datetime.datetime(year, month, day)
        lunar_date = ZhDate.from_datetime(solar_date)
        lunar_year = lunar_date.lunar_year
    
    # 计算干支
    year_ganzhi = get_ganzhi_year(lunar_year)
    month_ganzhi = get_ganzhi_month(lunar_year, lunar_date.lunar_month)
    day_ganzhi = get_ganzhi_day(solar_date)
    hour_ganzhi = get_ganzhi_hour(hour, day_ganzhi)
    
    # 获取时辰名称
    hour_name = DIZHI[(hour + 1) // 2 % 12] + "时"
    
    return {
        "日期类型": "农历" if is_lunar else "公历",
        "输入日期": f"{year}年{month}月{day}日{hour}时",
        "农历日期": str(lunar_date),
        "年柱": year_ganzhi,
        "月柱": month_ganzhi,
        "日柱": day_ganzhi,
        "时柱": hour_ganzhi,
        "时辰": hour_name
    }
    
def get_omen_info(omen_type, time_period, side=None, gender=None):
    """
    获取预兆信息
    :param omen_type: 预兆类型
    :param time_period: 时辰
    :param side: 左右侧（可选）
    :param gender: 性别（可选）
    :return: 预兆解释
    """
    if omen_type not in OMEN_DATA:
        return "未知的预兆类型"
    
    omen_data = OMEN_DATA[omen_type]
    
    if time_period not in omen_data:
        return "未知的时辰"
    
    time_data = omen_data[time_period]
    
    if isinstance(time_data, dict):
        if side and side in time_data:
            return time_data[side]
        elif gender and gender in time_data:
            return time_data[gender]
        else:
            return "需要指定左右侧或性别"
    else:
        return time_data

def print_omen_info(omen_type, time_period, side=None, gender=None):
    """
    打印彩色预兆信息
    """
    omen_text = get_omen_info(omen_type, time_period, side, gender)
    
    print("\n" + HEADER_COLOR + "预兆详情")
    print_separator()
    print_info("预兆类型", omen_type)
    print_info("时辰", time_period)
    if side:
        print_info("侧别", side)
    if gender:
        print_info("性别", gender)
    print_separator()
    print_result("解释", omen_text)
    print_separator()



def get_current_time_info():
    """获取当前时间的干支和预兆信息"""
    now = datetime.datetime.now()
    year = now.year
    month = now.month
    day = now.day
    hour = now.hour
    return get_lunar_date_info(year, month, day, hour)

def test_sneeze_omen():
    """测试喷嚏预兆查询"""
    test_date = datetime.datetime(2025, 8, 5, 9, 17)
    info = get_lunar_date_info(test_date.year, test_date.month, test_date.day, test_date.hour)
    
    print_title("测试2025年8月5日上午9:17分喷嚏的含义")
    print_info("公历日期", info["输入日期"])
    print_info("农历日期", info["农历日期"])
    print_info("时辰", info["时辰"])
    print_separator()
    print_result("喷嚏含义", get_omen_info("占喷嚏法", info["时辰"]))
    print_separator()

from colorama import Fore, Back, Style

def print_omen_types():
    """按照图片样式打印19个彩色预兆类型列表"""
    # 初始化黑色背景
    print(Back.BLACK + Style.BRIGHT, end="")
    
    # 白色标题（图片样式）
    print(Fore.WHITE + "预兆类型列表\n" + "‾‾‾‾‾‾‾‾‾‾‾‾")
    
    # 预兆类型与颜色映射（19种不同颜色）
    omen_colors = [
        Fore.RED,    Fore.GREEN,  Fore.YELLOW, Fore.BLUE,   Fore.MAGENTA,
        Fore.CYAN,   Fore.LIGHTRED_EX, Fore.LIGHTGREEN_EX, Fore.LIGHTYELLOW_EX,
        Fore.LIGHTBLUE_EX, Fore.LIGHTMAGENTA_EX, Fore.LIGHTCYAN_EX, Fore.WHITE,
        Fore.LIGHTBLACK_EX, Fore.RED, Fore.GREEN, Fore.YELLOW, Fore.BLUE, Fore.MAGENTA
    ]
    
    # 按图片中的顺序和分组排列（左列1-10，右列11-19）
    omen_types = [
        (" 1.占焚炉法", "11.占手痒法"),
        (" 2.占面热法", "12.占足痒法"),
        (" 3.占眼跳法", "13.占踢足法"),
        (" 4.占眼润法", "14.占衣留法"),
        (" 5.占耳热法", "15.占火逸法"),
        (" 6.占耳鸣法", "16.占斧鸣法"),
        (" 7.占耳痒法", "17.占断甲法"),
        (" 8.占喷嚏法", "18.占鹊噪法"),
        (" 9.占心惊法", "19.占犬嚎法"),
        ("10.占肉颤法", "")  # 最后一行只有左列
    ]
    
    # 打印彩色列表
    for i, (left, right) in enumerate(omen_types):
        # 左列（1-10）
        if i < len(omen_colors):
            print(omen_colors[i] + left.ljust(16), end="")
        
        # 右列（11-19）
        if right and (i+10) < len(omen_colors):
            print(omen_colors[i+10] + right, end="")
        
        print()  # 换行
    
    # 重置颜色
    print(Style.RESET_ALL, end="")

    
def query_by_current_time():
    """查询当前时间的预兆（优化版）"""
    info = get_current_time_info()
    
    print_header("当前时间信息")
    print_info("公历日期", info['输入日期'])
    print_info("农历日期", info['农历日期'])
    print_info("年柱", info['年柱'])
    print_info("月柱", info['月柱'])
    print_info("日柱", info['日柱'])
    print_info("时柱", info['时柱'])
    print_info("时辰", info['时辰'])
    print_separator()
    
    # 打印彩色对齐的预兆类型列表
    print_omen_types()
    
    # 获取用户选择
    omen_choice = input(PROMPT_COLOR + "请选择要查询的预兆类型(输入编号或名称): ")
    
    try:
        # 尝试按编号选择
        omen_index = int(omen_choice) - 1
        omen_type = list(OMEN_DATA.keys())[omen_index]
    except (ValueError, IndexError):
        # 按名称选择
        omen_type = omen_choice
    
    if omen_type not in OMEN_DATA:
        print("无效的预兆类型!")
        return
    
    # 处理需要额外参数的预兆
    side = None
    gender = None
    
    if omen_type in ["占眼跳法", "占眼润法", "占耳鸣、耳痒法", "占踢足法"]:
        side = input("请选择侧别(左/右): ").strip()
    elif omen_type == "占衣留法":
        gender = input("请选择性别(男/女): ").strip()
    
    print_omen_info(omen_type, info['时辰'], side, gender)

def query_by_specified_time():
    """查询指定时间的预兆"""
    print("\n请选择输入日期类型:")
    print("1. 公历日期")
    print("2. 农历日期")
    
    choice = input("请选择(1/2): ")
    
    if choice == "1":
        # 输入公历日期
        year = int(input("请输入年份(如2023): "))
        month = int(input("请输入月份(1-12): "))
        day = int(input("请输入日期(1-31): "))
        hour = int(input("请输入小时(0-23): "))
        info = get_lunar_date_info(year, month, day, hour, is_lunar=False)
    elif choice == "2":
        # 输入农历日期
        year = int(input("请输入农历年份(如2023): "))
        month = int(input("请输入农历月份(1-12): "))
        day = int(input("请输入农历日期(1-30): "))
        hour = int(input("请输入小时(0-23): "))
        info = get_lunar_date_info(year, month, day, hour, is_lunar=True)
    else:
        print("无效选择!")
        return
    
    print("\n" + "="*40)
    print("指定时间信息:")
    print("-"*40)
    print(f"输入日期: {info['输入日期']} ({info['日期类型']})")
    print(f"农历日期: {info['农历日期']}")
    print(f"年柱: {info['年干支']}")
    print(f"月柱: {info['月干支']}")
    print(f"日柱: {info['日干支']}")
    print(f"时柱: {info['时干支']}")
    print(f"时辰: {info['时辰']}")
    print("="*40)
    
    # 显示所有预兆类型
    print("\n预兆类型列表:")
    for i, omen_type in enumerate(OMEN_DATA.keys(), 1):
        print(f"{i}. {omen_type}")
    
    omen_choice = input("\n请选择要查询的预兆类型(输入编号或名称): ")
    
    try:
        # 尝试按编号选择
        omen_index = int(omen_choice) - 1
        omen_type = list(OMEN_DATA.keys())[omen_index]
    except (ValueError, IndexError):
        # 按名称选择
        omen_type = omen_choice
    
    if omen_type not in OMEN_DATA:
        print("无效的预兆类型!")
        return
    
    # 处理需要额外参数的预兆
    side = None
    gender = None
    
    if omen_type in ["占眼跳法", "占眼润法", "占耳鸣、耳痒法", "占踢足法"]:
        side = input("请选择侧别(左/右): ").strip()
    elif omen_type == "占衣留法":
        gender = input("请选择性别(男/女): ").strip()
    
    print_omen_info(omen_type, info['时辰'], side, gender)


def main_menu():
    """彩色主菜单"""
    print_title("十二时辰临身预兆查询系统")
    print(MENU_COLOR + "1. 查询当前时间的预兆")
    print(MENU_COLOR + "2. 查询指定时间的预兆")
    print(MENU_COLOR + "3. 退出系统")
    choice = input(PROMPT_COLOR + "请选择(1-3): ")
    return choice

def main():
    """主程序"""
    test_sneeze_omen()  # 显示测试案例
    
    while True:
        choice = main_menu()
        
        if choice == "1":
            query_by_current_time()
        elif choice == "2":
            query_by_specified_time()
        elif choice == "3":
            print("\n" + TITLE_COLOR + "感谢使用，再见！")
            break
        else:
            print(ERROR_COLOR + "无效选择，请重新输入!")
        
        input(PROMPT_COLOR + "\n按Enter键继续...")

if __name__ == "__main__":
    main()


