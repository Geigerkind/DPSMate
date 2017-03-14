-- Translated by Chargemiao & Timolol from Covenant

if (GetLocale() == "zhCN") then
	DPSMate.L["name"] = "DPSMate输出助手"
	DPSMate.L["popup"] = "你需要重置DPSMate数据吗?"
	DPSMate.L["memory"] = "DPSMate收集了大量数据，储存数据的过程可能会让您屏幕卡帧。请问您是否需要重置DPSMate?"
	DPSMate.L["accept"] = "接受"
	DPSMate.L["decline"] = "拒绝"
	DPSMate.L["total"] = "总体"
	DPSMate.L["current"] = "当前"
	DPSMate.L["cancel"] = "取消"
	DPSMate.L["report"] = "报告"
	DPSMate.L["reportfor"] = "报告 "
	 
	-- Abilities
	DPSMate.L["vanish"] = "消失"
	DPSMate.L["feigndeath"] = "假死"
	DPSMate.L["divineintervention"] = "神圣干涉"
	DPSMate.L["stealth"] = "潜行"
	 
	-- Evaluation frame
	DPSMate.L["procs"] = "触发"
	DPSMate.L["procstooltip"] = "选择需要在线形图中显示的触发效果."
	DPSMate.L["absorbsby"] = "吸收--"
	DPSMate.L["absorbstakenby"] = "被吸收--"
	DPSMate.L["aurasof"] = "光环-"
	DPSMate.L["BUDEBU"] = {"Buffs", "Debuffs"}
	DPSMate.L["castsof"] = "施法来自--"
	DPSMate.L["bname"] = "姓名"
	DPSMate.L["count"] = "倒数"
	DPSMate.L["uptime"] = "持续时间"
	DPSMate.L["chance"] = "机会"
	DPSMate.L["ccbreakerof"] = "控制失效--"
	DPSMate.L["time"] = "时间"
	DPSMate.L["cbt"] = "Beta测试关闭"
	DPSMate.L["ability"] = "技能"
	DPSMate.L["target"] = "目标"
	DPSMate.L["diseasecuredby"] = "解除疾病施法来自--"
	DPSMate.L["diseasecuredof"] = "疾病被解除--"
	DPSMate.L["poisoncuredby"] = "解除中毒施法来自--"
	DPSMate.L["poisoncuredof"] = "中毒被解除--"
	DPSMate.L["dmgdoneby"] = "造成伤害--"
	DPSMate.L["dmgtakenby"] = "受到伤害--"
	DPSMate.L["dmgtakensum"] = "造成伤害总量"
	DPSMate.L["dmgdonesum"] = "受到伤害总量"
	DPSMate.L["deathsof"] = "死亡--"
	DPSMate.L["cause"] = "诅咒"
	DPSMate.L["type"] = "种类"
	DPSMate.L["healin"] = "治疗在未来--"
	DPSMate.L["damagein"] = "伤害在未来--"
	DPSMate.L["decursesby"] = "解除诅咒施法来自--"
	DPSMate.L["decursesreceivedby"] = "诅咒被解除--"
	DPSMate.L["dispelsby"] = "驱散魔法施法来自--"
	DPSMate.L["dispelsreceivedby"] = "魔法被驱散--"
	DPSMate.L["block"] = "格挡"
	DPSMate.L["crush"] = "碾压"
	DPSMate.L["hit"] = "命中"
	DPSMate.L["average"] = "平均"
	DPSMate.L["min"] = "最小值"
	DPSMate.L["max"] = "最大值"
	DPSMate.L["crit"] = "暴击"
	DPSMate.L["miss"] = "未命中"
	DPSMate.L["parry"] = "招架"
	DPSMate.L["dodge"] = "闪避"
	DPSMate.L["resist"] = "抵抗"
	DPSMate.L["glance"] = "偏斜"
	DPSMate.L["effhealdoneby"] = "有效治疗来自--"
	DPSMate.L["effhealtakenby"] = "受到有效治疗--"
	DPSMate.L["failsof"] = "失误--"
	DPSMate.L["victim"] = "击杀"
	DPSMate.L["ffby"] = "队友误伤来自--"
	DPSMate.L["healdoneby"] = "治疗来自--"
	DPSMate.L["habby"] = "治疗和吸收来自--"
	DPSMate.L["healtakenby"] = "受到治疗--"
	DPSMate.L["interruptsby"] = "打断来自"
	DPSMate.L["magicliftby"] = "魔法施加来自--"
	DPSMate.L["magicliftof"] = "受到魔法施加--"
	DPSMate.L["overhealby"] = "过量治疗来自--"
	DPSMate.L["procsof"] = "触发--"
	 
	-- Menu
	DPSMate.L["mdps"] = "显示DPS统计."
	DPSMate.L["mdmg"] = "显示伤害统计."
	DPSMate.L["mdmgtaken"] = "显示受到伤害统计."
	DPSMate.L["medd"] = "显示敌人伤害统计."
	DPSMate.L["medt"] = "显示敌人受到伤害统计."
	DPSMate.L["mhealing"] = "显示有效治疗统计."
	DPSMate.L["mhab"] = "显示吸收造成有效治疗统计."
	DPSMate.L["mhealingtaken"] = "显示受到治疗统计."
	DPSMate.L["moverhealing"] = "显示过量治疗统计."
	DPSMate.L["minterrupts"] = "显示打断统计."
	DPSMate.L["mdeaths"] = "显示死亡统计."
	DPSMate.L["mdispels"] = "显示驱散统计."
	DPSMate.L["totalmode"] = "设置为总计模式."
	DPSMate.L["currentmode"] = "设置为当前模式."
	DPSMate.L["reportsegment"] = "报告这段数据."
	DPSMate.L["resetdesc"] = "重置DPSMate."
	DPSMate.L["newsegment"] = "新段数据"
	DPSMate.L["newsegmentdesc"] = "开始新段数据."
	DPSMate.L["removesegment"] = "删除数据段"
	DPSMate.L["removesegmentdesc"] = "删除一条数据段."
	DPSMate.L["lockdesc"] = "锁定DPSMate界面."
	DPSMate.L["hidewindowdesc"] = "隐藏DPSMate界面."
	DPSMate.L["showwindowdesc"] = "显示DPSMate界面."
	DPSMate.L["configframe"] = "打开配置界面."
	DPSMate.L["testmodedesc"] = "切换测试模式."
	DPSMate.L["filterdesc"] = "筛选选项."
	DPSMate.L["switchdesc"] = "切换模式"
	DPSMate.L["mcurrent"] = "当前战斗"
	DPSMate.L["mrealtime"] = "创建实时图表"
	DPSMate.L["mrealtimedesc"] = '创建实时图表，此功能占用大量系统资源.'
	DPSMate.L["damagedone"] = "造成伤害"
	DPSMate.L["realtimedmgdone"] = '选择此界面中相应的造成伤害.'
	DPSMate.L["realtimedmgtaken"] = '选择此界面中相应的受到伤害.'
	DPSMate.L["realtimehealing"] = '选择此界面中相应的总治疗.'
	DPSMate.L["realtimeehealing"] = '选择此界面中相应的有效治疗.'
	DPSMate.L["showAll"] = "显示全部"
	DPSMate.L["showAllDesc"] = '点击，显示所有界面'
	DPSMate.L["hideAll"] = "隐藏全部"
	DPSMate.L["hideAllDesc"] = '点击，隐藏所有界面'
	DPSMate.L["showwindow"] = "显示窗口"
	DPSMate.L["hidewindow"] = "隐藏窗口"
	DPSMate.L["unlock"] = "解锁窗口"
	DPSMate.L["config"] = "配置"
	DPSMate.L["reportdesc"] = "报告细节"
	DPSMate.L["whisper"] = "密语"
	DPSMate.L["whisperdesc"] = "对某人密语"
	DPSMate.L["classes"] = "职业"
	DPSMate.L["classesdesc"] = "选择职业"
	DPSMate.L["warrior"] = "战士"
	DPSMate.L["rogue"] = "盗贼"
	DPSMate.L["warlock"] = "术士"
	DPSMate.L["mage"] = "法师"
	DPSMate.L["paladin"] = "圣骑士"
	DPSMate.L["shaman"] = "萨满"
	DPSMate.L["priest"] = "牧师"
	DPSMate.L["druid"] = "德鲁伊"
	DPSMate.L["hunter"] = "猎人"
	DPSMate.L["warriordesc"] = "显示战士"
	DPSMate.L["roguedesc"] = "显示盗贼"
	DPSMate.L["warlockdesc"] = "显示术士"
	DPSMate.L["magedesc"] = "显示法师"
	DPSMate.L["paladindesc"] = "显示圣骑士"
	DPSMate.L["shamandesc"] = "显示萨满"
	DPSMate.L["priestdesc"] = "显示牧师"
	DPSMate.L["druiddesc"] = "显示德鲁伊"
	DPSMate.L["hunterdesc"] = "显示猎人"
	DPSMate.L["certainnames"] = "几个名字"
	DPSMate.L["certainnamesdesc"] = '分离-- "," 例如: Shino,'
	DPSMate.L["grouponly"] = "仅小队"
	DPSMate.L["grouponlydesc"] = "只显示小队"
	 
	-- Config menu
	DPSMate.L["slider"] = "条数"
	DPSMate.L["slidertooltip"] = "移动来设定报告条数."
	DPSMate.L["editboxtitle"] = "密语目标"
	DPSMate.L["editboxtooltip"] = "输入需要报告目标的名字."
	DPSMate.L["channel"] = "频道"
	DPSMate.L["channeltooltip"] = "选择你需要报告的频道."
	DPSMate.L["close"] = "关闭"
	DPSMate.L["minimapleft"] = "左键拖动来移动图标."
	DPSMate.L["minimapright"] = "右键打开菜单."
	DPSMate.L["window"] = "窗口"
	DPSMate.L["bars"] = "数据条"
	DPSMate.L["titlebar"] = "数据条题目"
	DPSMate.L["content"] = "内容"
	DPSMate.L["modeswitching"] = "正在切换模式"
	DPSMate.L["dataresets"] = "数据重置"
	DPSMate.L["generaloptions"] = "通用选项"
	DPSMate.L["columns"] = "列"
	DPSMate.L["tooltips"] = "标题"
	DPSMate.L["broadcasting"] = "广播选项"
	DPSMate.L["about"] = "关于"
	DPSMate.L["createwindow"] = "创建窗口"
	DPSMate.L["createwindowtooltip"] = "输入窗口名字."
	DPSMate.L["submit"] = "发送"
	DPSMate.L["submitTooltip"] = "点击创建窗口."
	DPSMate.L["availwindows"] = "可用窗口"
	DPSMate.L["availwindowsTooltip"] = "选择一个窗口."
	DPSMate.L["lock"] = "锁定窗口"
	DPSMate.L["testmode"] = "测试模式"
	DPSMate.L["barfont"] = "数据条字体"
	DPSMate.L["barfontTooltip"] = "选择数据条字体."
	DPSMate.L["barfontsize"] = "数据条字号"
	DPSMate.L["barfontsizeTooltip"] = "移动来修改字号."
	DPSMate.L["barfontflags"] = "字体招贴"
	DPSMate.L["barfontflagsTooltip"] = "选择字体招贴."
	DPSMate.L["bartexture"] = "数据条材质"
	DPSMate.L["bartextureTooltip"] = "选择数据条材质."
	DPSMate.L["barspacing"] = "数据条间隔"
	DPSMate.L["barspacingTooltip"] = "移动来修改数据条间隔."
	DPSMate.L["barheight"] = "数据条高度"
	DPSMate.L["barheightTooltip"] = "移动来修改数据条高度."
	DPSMate.L["classicons"] = "职业图标"
	DPSMate.L["ranks"] = "排名"
	DPSMate.L["mode"] = "模式"
	DPSMate.L["modes"] = "模式"
	DPSMate.L["reset"] = "重置"
	DPSMate.L["sync"] = "同步"
	DPSMate.L["bgcolor"] = "背景颜色"
	DPSMate.L["fontcolor"] = "字体颜色"
	DPSMate.L["fontcolorTooltip"] = "点击选择字体颜色."
	DPSMate.L["bgcolorTooltip"] = "点击选择背景颜色."
	DPSMate.L["scale"] = "比例"
	DPSMate.L["scaleTooltip"] = "移动来修改界面比例."
	DPSMate.L["opacity"] = "透明度"
	DPSMate.L["opacityTooltip"] = "移动来修改界面透明度."
	DPSMate.L["bgtex"] = "背景材质"
	DPSMate.L["bgtexTooltip"] = "修改界面材质."
	DPSMate.L["enterworldinstance"] = "世界/副本"
	DPSMate.L["enterworldinstanceTooltip"] = "当进入世界或副本时重置."
	DPSMate.L["joinparty"] = "加入小队"
	DPSMate.L["joinpartyTooltip"] = "当加入小队时重置."
	DPSMate.L["leavingparty"] = "离开队伍"
	DPSMate.L["leavingpartyTooltip"] = "当离开队伍时重置."
	DPSMate.L["partymemberchanged"] = "队伍成员改变"
	DPSMate.L["partymemberchangedTooltip"] = "当队伍成员改变时重置."
	DPSMate.L["minimap"] = "显示小地图图标"
	DPSMate.L["showtotal"] = "显示总计"
	DPSMate.L["solo"] = "不在队伍时隐藏"
	DPSMate.L["combat"] = "战斗时隐藏"
	DPSMate.L["bossfights"] = "仅保存Boss战数据"
	DPSMate.L["pvp"] = "PvP时隐藏"
	DPSMate.L["disable"] = "隐藏时禁用"
	DPSMate.L["mergepets"] = "融合宠物数据"
	DPSMate.L["numberformat"] = "数字格式"
	DPSMate.L["numberformatTooltip"] = "控制数字显示格式."
	DPSMate.L["segments"] = "数据段"
	DPSMate.L["segmentsTooltip"] = "移动来提高收集数据段，此操作会造成游戏延时!!!"
	DPSMate.L["enable"] = "启用"
	DPSMate.L["damage"] = "伤害"
	DPSMate.L["percent"] = "百分比"
	DPSMate.L["dps"] = "DPS每秒伤害"
	DPSMate.L["edps"] = "EDPS每秒有效伤害"
	DPSMate.L["dtps"] = "DTPS每秒承受伤害"
	DPSMate.L["edtps"] = "EDTPS每秒承受有效伤害"
	DPSMate.L["healing"] = "治疗"
	DPSMate.L["hps"] = "HPS每秒治疗"
	DPSMate.L["ehps"] = "EHPS每秒有效治疗"
	DPSMate.L["etps"] = "ETPS每秒有效仇恨"
	DPSMate.L["damagetaken"] = "受到伤害"
	DPSMate.L["enemydamagedone"] = "敌人造成伤害"
	DPSMate.L["enemydamagetaken"] = "敌人受到伤害"
	DPSMate.L["healing"] = "治疗"
	DPSMate.L["absorbs"] = "吸收"
	DPSMate.L["absorbstaken"] = "接受吸收量"
	DPSMate.L["amount"] = "量"
	DPSMate.L["dispelsreceived"] = "受到驱散"
	DPSMate.L["decurses"] = "解除诅咒"
	DPSMate.L["decursesreceived"] = "受到解除诅咒"
	DPSMate.L["curedisease"] = "疾病被解除"
	DPSMate.L["curepoison"] = "中毒被解除"
	DPSMate.L["liftmagic"] = "被施加魔法"
	DPSMate.L["aurasgained"] = "获得光环"
	DPSMate.L["auraslost"] = "失去光环"
	DPSMate.L["aurauptime"] = "光环持续时间"
	DPSMate.L["friendlyfire"] = "友方误伤"
	DPSMate.L["procs"] = "触发"
	DPSMate.L["liftmagicreceived"] = "受到增益魔法"
	DPSMate.L["curepoisonreceived"] = "受到解除中毒"
	DPSMate.L["curediseasereceived"] = "受到解除疾病"
	DPSMate.L["effectivehealing"] = "有效治疗"
	DPSMate.L["effectivehps"] = "有效HPS"
	DPSMate.L["effectivehealingtaken"] = "受到有效治疗"
	DPSMate.L["healingandabsorbs"] = "治疗和吸收"
	DPSMate.L["healingtaken"] = "受到治疗"
	DPSMate.L["overhealing"] = "过量治疗"
	DPSMate.L["interrupts"] = "打断"
	DPSMate.L["deaths"] = "死亡"
	DPSMate.L["dispels"] = "驱散"
	DPSMate.L["threat"] = "仇恨"
	DPSMate.L["tps"] = "TPS每秒仇恨"
	DPSMate.L["fails"] = "失误"
	DPSMate.L["cat"] = "种类"
	DPSMate.L["ccbreaker"] = "控制失效"
	DPSMate.L["subviewrows"] = "子视图行数"
	DPSMate.L["subviewrowsTooltip"] = "移动来修改显示子视图行数."
	DPSMate.L["TooltipPositionDropDown"] = "标题位置"
	DPSMate.L["TooltipPositionDropDownTooltip"] = "选择界面相关标题位置."
	DPSMate.L["whatisdpsmate"] = "DPSMate是什么?"
	DPSMate.L["whatisdpsmateText"] = "DPSMate是一款战斗分析插件.可以用详细的数据来评定玩家的游戏表现."
	DPSMate.L["whocreateddpsmate"] = "谁制作了DPSMate?"
	DPSMate.L["whocreateddpsmateText"] = "DPSMate由Shino (Albea) <Synced>制作, 来自Kronos (Twinstar.cz)服务器，K服论坛昵称Geigerkind."
	DPSMate.L["thanksto"] = "感谢以下贡献者:"
	--DPSMate.L["thankstoText"] = "Weasel - 参与Beta测试. \nBambustreppe - 德语本地化. \nDarkmiao - 中文本地化."
	DPSMate.L["remove"] = "删除"
	DPSMate.L["removeTooltip"] = "点击来删除选择窗口."
	DPSMate.L["copy"] = "复制"
	DPSMate.L["copyTooltip"] = "点击来复制配置到选择窗口."
	DPSMate.L["configto"] = "复制配置到:"
	DPSMate.L["configtoTooltip"] = "选择你要配置的窗口."
	DPSMate.L["configfrom"] = "复制配置由--:"
	DPSMate.L["configfromTooltip"] = "选择你想要复制配置到的窗口."
	DPSMate.L["reset"] = "重置"
	DPSMate.L["syncrequest"] = "同步重置请求"
	DPSMate.L["syncrequesttooltip"] = "同步重置请求出现时会发生什么？"
	DPSMate.L["dataresetslogout"] = "退出游戏重置请求"
	DPSMate.L["dataresetslogouttooltip"] = "退出游戏重置"
	DPSMate.L["enabledisable"] = "启用/禁用"
	DPSMate.L["bgbarcolor"] = "背景条颜色"
	DPSMate.L["bgbarcolorTooltip"] = "点击来选择背景条颜色."
	DPSMate.L["displayoptions"] = "显示选项"
	DPSMate.L["filter"] = "刷选选项"
	DPSMate.L["raidleader"] = "团长选项"
	DPSMate.L["bgOpacityTooltip"] = "调整背景透明度."
	DPSMate.L["bgOpacity"] = "背景透明度"
	DPSMate.L["casts"] = "施法"
	DPSMate.L["locktooltip"] = "选择此项来锁定界面."
	DPSMate.L["testmodetooltip"] = "选择此项来激活测试模式."
	DPSMate.L["classiconstooltip"] = "选择此项来显示职业图标在状态条上."
	DPSMate.L["rankstooltip"] = "选择此项来显示排名位置."
	DPSMate.L["enabletitlebartooltip"] = "选择此项来启用题目条."
	DPSMate.L["buttonshowtooltip"] = "选择此项来显示图标在题目条上."
	DPSMate.L["minimaptooltip"] = "选择此项来显示小地图图标."
	DPSMate.L["showtotaltooltip"] = "选择此项来获得一条额外的数据条来显示总计数据."
	DPSMate.L["solotooltip"] = "当你不在队伍的时候，选择此项来隐藏界面，."
	DPSMate.L["combattooltip"] = "当你进入战斗的时候，选择此项来隐藏界面，."
	DPSMate.L["bossfightstooltip"] = "选择此项来只保存Boss战数据."
	DPSMate.L["pvptooltip"] = "当你进入战场的时候，选择此项来隐藏界面."
	DPSMate.L["disabletooltip"] = "当界面隐藏的时候，选择此项来禁用数据收集."
	DPSMate.L["mergepetstooltip"] = "选择此项来融合宠物伤害."
	DPSMate.L["showtooltips"] = "显示标题"
	DPSMate.L["showtooltipsTooltip"] = "选择此项来显示标题."
	DPSMate.L["informativetooltips"] = "资料类标题"
	DPSMate.L["informativetooltipsTooltip"] = "选择此项来让标题显示更多细节."
	DPSMate.L["shownmodes"] = "显示模式"
	DPSMate.L["hiddenmodes"] = "隐藏模式"
	DPSMate.L["moveleftTooltip"] = "点击来显示模式."
	DPSMate.L["moverightTooltip"] = "点击来隐藏模式."
	DPSMate.L["helloworld"] = "Hello World!"
	DPSMate.L["helloworldTooltip"] = "返回同步频道的玩家列表."
	DPSMate.L["enablebroadcasting"] = "选择此项来启用以下广播选项."
	DPSMate.L["useraidwarning"] = "使用团队警示频道(RW)"
	DPSMate.L["useraidwarningTooltip"] = "选择此项来启用团队警示频道(RW)来代替团队频道."
	DPSMate.L["relevantcds"] = "相关技能CD"
	DPSMate.L["relevantcdsTooltip"] = "选择此项来广播相关技能CD，例如盾墙."
	DPSMate.L["ress"] = "复活"
	DPSMate.L["ressTooltip"] = "选择此项来广播玩家是否接受了复活."
	DPSMate.L["killingblows"] = "致命一击"
	DPSMate.L["killingblowsTooltip"] = "选择此项来广播玩家是否死于致命一击."
	DPSMate.L["failsTooltip"] = "选择此项来广播玩家是否失误(友方误伤/受到伤害/受到Debuff)."
	DPSMate.L["framesavailable"] = "以下的界面是可用的，如果没有显示请输入/config."
	DPSMate.L["slashabout"] = "|c3ffddd80About:|r 喵之战斗分析插件."
	DPSMate.L["slashusage"] = "|c3ffddd80Usage:|r /dps {lock|unlock|show|hide|config}"
	DPSMate.L["slashlock"] = "|c3ffddd80- lock:|r 锁定窗口."
	DPSMate.L["slashunlock"] = "|c3ffddd80- unlock:|r 解锁窗口."
	DPSMate.L["slashshowAll"] = "|c3ffddd80- showAll:|r 显示所有窗口."
	DPSMate.L["slashhideAll"] = "|c3ffddd80- hideAll:|r 隐藏所有窗口."
	DPSMate.L["slashshow"] = "|c3ffddd80- show {name}:|r 显示以下名字的窗口: {name}."
	DPSMate.L["slashhide"] = "|c3ffddd80- hide {name}:|r 隐藏以下名字的窗口: {name}."
	DPSMate.L["slashconfig"] = "|c3ffddd80- config:|r 打开配置菜单."
	DPSMate.L["bccdo"] = function(who, what) return who.." 获得 "..what end
	DPSMate.L["bccdt"] = function(who, what) return who.."s "..what.." 消失" end
	DPSMate.L["bcress"] = function(who, what) return what.." 被复活，来自-- "..who end
	DPSMate.L["bckb"] = function(who, what, with, value) return who.." 被击杀，来自-- "..what.."s "..with.." ("..value.." 伤害)" end
	DPSMate.L["bcfailo"] = function(what, who, value, with) return "失误: "..what.." 友方误伤 "..who.." "..value.." 伤害 "..with end
	DPSMate.L["bcfailt"] = function(who, with) return "失误: "..who.." 被折磨 "..with end
	DPSMate.L["bcfailth"] = function(who, value, with, what) return "失误: "..who.." 遭受 "..value.." 伤害来自 "..with.." 由 "..what end
	DPSMate.L["syncreseterror"] = "当同步模式启动时，DPSMate不能重置."
	DPSMate.L["resetnotofficererror"] = "你不是队长或者你没有A!"
	DPSMate.L["findusererror"] = "找不到这个用户!"
	DPSMate.L["yes"] = "是"
	DPSMate.L["no"] = "否"
	DPSMate.L["ask"] = "问"
	DPSMate.L["normal"] = "正常"
	DPSMate.L["condensed"] = "扼要的"
	DPSMate.L["default"] = "默认"
	DPSMate.L["topright"] = "右上"
	DPSMate.L["topleft"] = "左上"
	DPSMate.L["left"] = "左"
	DPSMate.L["top"] = "上"
	DPSMate.L["gchannel"] = {[1]="Raid",[2]="Party",[3]="Say",[4]="Officer",[5]="Guild"}
	DPSMate.L["nodetailserror"] = "没有可以报告的细节."
	DPSMate.L["reportof"] = "报告--"
	DPSMate.L["opendetails"] = "打开细节"
	DPSMate.L["reportdetails"] = "报告这名用户的细节."
	DPSMate.L["fdetailsfor"] = "战斗细节--"
	DPSMate.L["removesegmentof"] = "删除数据段"
	DPSMate.L["lockedallw"] = "锁定所有窗口."
	DPSMate.L["unlockedallw"] = "解锁所有窗口."
	DPSMate.L["leftclickopend"] = "左键点击来打开细节."
	DPSMate.L["rightclickopenm"] = "右键点击来打开菜单."
	DPSMate.L["hide"] = "隐藏"
	DPSMate.L["show"] = "显示"
	DPSMate.L["rcchangemode"] = "右键点击来切换统计模式."
	DPSMate.L["segment"] = "数据段"
	DPSMate.L["sync"] = "同步"
	DPSMate.L["alliance"] = "联盟"
	DPSMate.L["horde"] = "部落"
	DPSMate.L["unknown"] = "未知目标"
	DPSMate.L["votestartederror"] = "投票已经开始!"
	DPSMate.L["votefailederror"] = "重置投票失败!"
	DPSMate.L["votesuccess"] = "重置投票成功!DPSMate已经成功重置数据"
	DPSMate.L["disease"] = "疾病"
	DPSMate.L["magic"] = "魔法"
	DPSMate.L["curse"] = "诅咒"
	DPSMate.L["poison"] = "中毒"
	DPSMate.L["physical"] = "物理"
	DPSMate.L["debufftaken"] = "受到Debuff"
	DPSMate.L["buffs"] = "Buffs"
	DPSMate.L["debuffs"] = "Debuffs"
	 
	DPSMate.L["mc"] = "熔火之心"
	DPSMate.L["bwl"] = "黑翼之巢"
	DPSMate.L["ony"] = "奥妮克希亚的巢穴"
	DPSMate.L["zg"] = "祖尔格拉布"
	DPSMate.L["aq401"] = "安其拉废墟"
	DPSMate.L["aq20"] = "安其拉神庙"
	DPSMate.L["aq402"] = "安其拉"
	DPSMate.L["naxx"] = "纳克萨玛斯"
	DPSMate.L["azs"] = "艾萨拉"
	DPSMate.L["bl"] = "诅咒之地"
	DPSMate.L["dw"] = "暮色森林"
	DPSMate.L["hintl"] = "辛特兰"
	DPSMate.L["ash"] = "灰谷"
	DPSMate.L["fe"] = "菲拉斯"
	
	DPSMate.L["switchgraphsdesc"] = "切换图像"
	DPSMate.L["switchindividualsdesc"] = "个人/总计"
	DPSMate.L["OHPS"] = "OHPS每秒过量治疗"
	DPSMate.L["OHealingTaken"] = "受到过量治疗"
	DPSMate.L["eohps"] = "EOHPS"
	DPSMate.L["ohealtakenby"] = "受到过量治疗来自"
	DPSMate.L["friendlyfiretaken"] = "受到友方误伤"
	DPSMate.L["fftby"] = "受到友方误伤来自"
	DPSMate.L["poisoncleansingtotem"] = "清毒图腾"
	DPSMate.L["threatdoneby"] = "制造仇恨来自"
	DPSMate.L["periodic"] = "(周期的)"
	DPSMate.L["reportchannel"] = {[1]=DPSMate.L["whisper"],[2]="Raid",[3]="Party",[4]="Say",[5]="Officer",[6]="Guild"}
	DPSMate.L["raid"] = "团队"
	DPSMate.L["activity"] = "激活: "
	DPSMate.L["of"] = "--"
	DPSMate.L["comparewith"] = "对比和"
	DPSMate.L["comparewithdesc"] = "选择一个和此玩家对比的玩家."
	DPSMate.L["targetscale"] = "评定界面比例"
	DPSMate.L["targetscaleTooltip"] = "修改评定界面比例."
	DPSMate.L["eddsum"] = "敌人伤害总计"
	DPSMate.L["edtsum"] = "敌人受到伤害总计"
	DPSMate.L["ehpssum"] = "有效治疗总计"
	DPSMate.L["tehealing"] = "有效治疗"
	DPSMate.L["hpssum"] = "治疗总计"
	DPSMate.L["thealing"] = "治疗"
	DPSMate.L["ohpssum"] = "过量治疗总计"
	DPSMate.L["tohealing"] = "过量治疗"
	DPSMate.L["tehealingtaken"] = "受到有效治疗"
	DPSMate.L["ehpstsum"] = "受到有效治疗总计"
	DPSMate.L["thealingtaken"] = "受到治疗"
	DPSMate.L["hpstsum"] = "受到治疗总计"
	DPSMate.L["tohealingtaken"] = "受到过量治疗"
	DPSMate.L["ohpstsum"] = "受到过量治疗总计"
	DPSMate.L["habsum"] = "治疗和吸收总计"
	DPSMate.L["threatdone"] = "制造仇恨"
	DPSMate.L["threatsum"] = "制造仇恨总计"
	DPSMate.L["ffsum"] = "友方误伤总计"
	DPSMate.L["fftsum"] = "受到友方误伤总计"
	DPSMate.L["over"] = "超过"
	DPSMate.L["lastability"] = "最后三次命中"
	DPSMate.L["deathssum"] = "死亡总计"
	DPSMate.L["victim"] = "见证"
	DPSMate.L["deathhistory"] = "死亡历史"
	DPSMate.L["intersum"] = "打断总计"
	DPSMate.L["dispelssum"] = "驱散总计"
	DPSMate.L["dispels"] = "驱散"
	DPSMate.L["decursessum"] = "解除诅咒总计"
	DPSMate.L["ccbreakersum"] = "控制失效总计"
	DPSMate.L["failssum"] = "失误总计"
	DPSMate.L["AutoAttack"] = "自动攻击"
	DPSMate.L["AutoShot"] = "自动射击"
	DPSMate.L["castssum"] = "施法总计"
	DPSMate.L["procssum"] = "触发总计"
	DPSMate.L["aurassum"] = "光环总计"
	DPSMate.L["absorbssum"] = "吸收总计"
	DPSMate.L["absorbeddmg"] = "吸收"
	DPSMate.L["absorbstakensum"] = "受到吸收总计"
	DPSMate.L["activity"] = "激活"
	DPSMate.L["cbtdisplay"] = "禁用Beta测试显示"
	
	DPSMate.L["disablebarbg"] = "禁用背景"
	DPSMate.L["disablebarbgtooltip"] = "禁用所有未完成数据条的背景."
	DPSMate.L["totalbaropacity"] = "总数据条的透明度"
	DPSMate.L["totalbaropacitytooltip"] = "调整总数据条透明度."
	DPSMate.L["abortvote"] = "中止重置命令.团队和A有权中止重置命令，如果你操作够快的话."
	DPSMate.L["resetaborted"] = "重置命令被中止，重置命令将有20秒的冷却时间."
	
	DPSMate.L["vreset"] = "重置"
	DPSMate.L["vdreset"] = "不要重置"
	DPSMate.L["togglereportframe"] = "切换报告界面"
	DPSMate.L["toggleframes"] = "切换界面"
	DPSMate.L["resetdpsmate"] = "重置DPSMate"
	DPSMate.L["columnstooltip"] = "选择此项来显示更多信息."
	DPSMate.L["commas"] = "逗号"
	DPSMate.L["versionisold"] = "您的DPSMate版本过期，请更新！DPSMate只同步最新版本."
	DPSMate.L["rezz"] = "复活"
	DPSMate.L["rezzof"] = "复活--"
	DPSMate.L["rezzsum"] = "复活总计"
	DPSMate.L["activity"] = "激活"
	DPSMate.L["cbtdisplay"] = "禁用Beta测试显示"
	DPSMate.L["semicondensed"] = "半-扼要的"
	DPSMate.L["loginhide"] = "登入游戏是隐藏"
	DPSMate.L["borderOpacityTooltip"] = "调整边框透明度."
	DPSMate.L["borderOpacity"] = "边框透明度"
	DPSMate.L["bordertextureTooltip"] = "选择边框材质."
	DPSMate.L["bordertexture"] = "边框材质"
	DPSMate.L["borderstrataTooltip"] = "选择边框层，会让边框变成背景或者前景."
	DPSMate.L["borderstrata"] = "边框层"
	DPSMate.L["bordercolor"] = "边框颜色"
	DPSMate.L["bordercolorTooltip"] = "调整边框颜色."
	
	DPSMate.L["tttop"] = "顶部 "
	DPSMate.L["ttdamage"] = " 伤害"
	DPSMate.L["tthealing"] = " 治疗"
	DPSMate.L["ttpet"] = " 宠物"
	DPSMate.L["ttpet2"] = "宠物: "
	DPSMate.L["ttabilities"] = " 技能"
	DPSMate.L["ttattacked"] = " 被攻击"
	DPSMate.L["tthealed"] = " 被治疗"
	DPSMate.L["ttinterrupt"] = " 打断"
	DPSMate.L["ttinterrupted"] = " 被打断"
	DPSMate.L["ttdispelled"] = " 被驱散"
	DPSMate.L["ttabsorbed"] = " 被吸收"
	DPSMate.L["ttabsorb"] = " 吸收"
	DPSMate.L["ttthreat"] = " 仇恨"
	
	
	-- Updating preloaded configs
	local _G = getglobal
	local prestr = "DPSMate_ConfigMenu_"
	-- Menu
	local substr = "Menu_"
	_G(prestr..substr.."Button1"):SetText(DPSMate.L["window"])
	_G(prestr..substr.."Button2"):SetText(DPSMate.L["dataresets"])
	_G(prestr..substr.."Button3"):SetText(DPSMate.L["generaloptions"])
	_G(prestr..substr.."Button4"):SetText(DPSMate.L["columns"])
	_G(prestr..substr.."Button5"):SetText(DPSMate.L["tooltips"])
	_G(prestr..substr.."Button6"):SetText(DPSMate.L["modes"])
	_G(prestr..substr.."Button7"):SetText(DPSMate.L["raidleader"])
	_G(prestr..substr.."Button8"):SetText(DPSMate.L["broadcasting"])
	_G(prestr..substr.."Button9"):SetText(DPSMate.L["about"])
	
	-- Window
	substr = "Tab_Window_"
	_G(prestr..substr.."EditboxText"):SetText(DPSMate.L["createwindow"])
	_G(prestr..substr.."Editbox").aide = DPSMate.L["createwindowtooltip"]
	_G(prestr..substr.."SubmitText"):SetText(DPSMate.L["submit"])
	_G(prestr..substr.."Submit").aide = DPSMate.L["submitTooltip"]
	_G(prestr..substr.."Remove_Text"):SetText(DPSMate.L["availwindows"])
	_G(prestr..substr.."Remove").aide = DPSMate.L["availwindowsTooltip"]
	_G(prestr..substr.."ButtonRemoveText"):SetText(DPSMate.L["remove"])
	_G(prestr..substr.."ButtonRemove").aide = DPSMate.L["removeTooltip"]
	_G(prestr..substr.."ConfigFrom_Text"):SetText(DPSMate.L["configfrom"])
	_G(prestr..substr.."ConfigFrom").aide = DPSMate.L["configfromTooltip"]
	_G(prestr..substr.."ConfigTo_Text"):SetText(DPSMate.L["configto"])
	_G(prestr..substr.."ConfigTo").aide = DPSMate.L["configtoTooltip"]
	_G(prestr..substr.."ButtonCopyText"):SetText(DPSMate.L["copy"])
	_G(prestr..substr.."ButtonCopy").aide = DPSMate.L["copyTooltip"]
	_G(prestr..substr.."Lock_Title"):SetText(DPSMate.L["lock"])
	_G(prestr..substr.."Lock").aide = DPSMate.L["locktooltip"]
	_G(prestr..substr.."Testmode_Title"):SetText(DPSMate.L["testmode"])
	_G(prestr..substr.."Testmode").aide = DPSMate.L["testmodetooltip"]
	
	-- Bars
	substr = "Tab_Bars_"
	_G(prestr..substr.."BarFont_Text"):SetText(DPSMate.L["barfont"])
	_G(prestr..substr.."BarFont").aide = DPSMate.L["barfontTooltip"]
	_G(prestr..substr.."BarFontSizeText"):SetText(DPSMate.L["barfontsize"])
	_G(prestr..substr.."BarFontSize").aide = DPSMate.L["barfontsizeTooltip"]
	_G(prestr..substr.."BarFontFlag_Text"):SetText(DPSMate.L["barfontflags"])
	_G(prestr..substr.."BarFontFlag").aide = DPSMate.L["barfontflagsTooltip"]
	_G(prestr..substr.."BarTexture_Text"):SetText(DPSMate.L["bartexture"])
	_G(prestr..substr.."BarTexture").aide = DPSMate.L["bartextureTooltip"]
	_G(prestr..substr.."BarSpacingText"):SetText(DPSMate.L["barspacing"])
	_G(prestr..substr.."BarSpacing").aide = DPSMate.L["barspacingTooltip"]
	_G(prestr..substr.."BarHeightText"):SetText(DPSMate.L["barheight"])
	_G(prestr..substr.."BarHeight").aide = DPSMate.L["barheightTooltip"]
	_G(prestr..substr.."FontColor_Font"):SetText(DPSMate.L["fontcolor"])
	_G(prestr..substr.."FontColor").aide = DPSMate.L["fontcolorTooltip"]
	_G(prestr..substr.."BackgroundBarColor_Font"):SetText(DPSMate.L["bgbarcolor"])
	_G(prestr..substr.."BackgroundBarColor").aide = DPSMate.L["bgbarcolorTooltip"]
	_G(prestr..substr.."ClassIcons_Title"):SetText(DPSMate.L["classicons"])
	_G(prestr..substr.."ClassIcons").aide = DPSMate.L["classiconstooltip"]
	_G(prestr..substr.."Ranks_Title"):SetText(DPSMate.L["ranks"])
	_G(prestr..substr.."Ranks").aide = DPSMate.L["rankstooltip"]
	_G(prestr..substr.."DisableBG_Title"):SetText(DPSMate.L["disablebarbg"])
	_G(prestr..substr.."DisableBG").aide = DPSMate.L["disablebarbgtooltip"]
	_G(prestr..substr.."TotalAlphaText"):SetText(DPSMate.L["totalbaropacity"])
	_G(prestr..substr.."TotalAlpha").aide = DPSMate.L["totalbaropacitytooltip"]
	
	-- Titlebar
	substr = "Tab_TitleBar_"
	_G(prestr..substr.."Enable_Title"):SetText(DPSMate.L["enable"])
	_G(prestr..substr.."Enable").aide = DPSMate.L["enabletitlebartooltip"]
	_G(prestr..substr.."BarFont_Text"):SetText(DPSMate.L["barfont"])
	_G(prestr..substr.."BarFont").aide = DPSMate.L["barfontTooltip"]
	_G(prestr..substr.."BarFontSizeText"):SetText(DPSMate.L["barfontsize"])
	_G(prestr..substr.."BarFontSize").aide = DPSMate.L["barfontsizeTooltip"]
	_G(prestr..substr.."BarFontFlag_Text"):SetText(DPSMate.L["barfontflags"])
	_G(prestr..substr.."BarFontFlag").aide = DPSMate.L["barfontflagsTooltip"]
	_G(prestr..substr.."BarTexture_Text"):SetText(DPSMate.L["bartexture"])
	_G(prestr..substr.."BarTexture").aide = DPSMate.L["bartextureTooltip"]
	_G(prestr..substr.."BarHeightText"):SetText(DPSMate.L["barheight"])
	_G(prestr..substr.."BarHeight").aide = DPSMate.L["barheightTooltip"]
	_G(prestr..substr.."BGOpacityText"):SetText(DPSMate.L["bgOpacity"])
	_G(prestr..substr.."BGOpacity").aide = DPSMate.L["bgOpacityTooltip"]
	_G(prestr..substr.."BGColor_Font"):SetText(DPSMate.L["bgcolor"])
	_G(prestr..substr.."BGColor").aide = DPSMate.L["bgcolorTooltip"]
	_G(prestr..substr.."FontColor_Font"):SetText(DPSMate.L["fontcolor"])
	_G(prestr..substr.."FontColor").aide = DPSMate.L["fontcolorTooltip"]
	_G(prestr..substr.."Box1_Report_Title"):SetText(DPSMate.L["report"])
	_G(prestr..substr.."Box1_Report").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_Mode_Title"):SetText(DPSMate.L["mode"])
	_G(prestr..substr.."Box1_Mode").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_Reset_Title"):SetText(DPSMate.L["reset"])
	_G(prestr..substr.."Box1_Reset").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_Config_Title"):SetText(DPSMate.L["config"])
	_G(prestr..substr.."Box1_Config").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_Sync_Title"):SetText(DPSMate.L["sync"])
	_G(prestr..substr.."Box1_Sync").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_Enable_Title"):SetText(DPSMate.L["enabledisable"])
	_G(prestr..substr.."Box1_Enable").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_Filter_Title"):SetText(DPSMate.L["filter"])
	_G(prestr..substr.."Box1_Filter").aide = DPSMate.L["buttonshowtooltip"]
	_G(prestr..substr.."Box1_CBTDisplay_Title"):SetText(DPSMate.L["cbtdisplay"])
	_G(prestr..substr.."Box1_CBTDisplay").aide = DPSMate.L["buttonshowtooltip"]
	
	-- Tab content
	substr = "Tab_Content_"
	_G(prestr..substr.."BGDropDown_Text"):SetText(DPSMate.L["bgtex"])
	_G(prestr..substr.."BGDropDown").aide = DPSMate.L["bgtexTooltip"]
	_G(prestr..substr.."ScaleText"):SetText(DPSMate.L["scale"])
	_G(prestr..substr.."Scale").aide = DPSMate.L["scaleTooltip"]
	_G(prestr..substr.."OpacityText"):SetText(DPSMate.L["opacity"])
	_G(prestr..substr.."Opacity").aide = DPSMate.L["opacityTooltip"]
	_G(prestr..substr.."BGOpacityText"):SetText(DPSMate.L["bgOpacity"])
	_G(prestr..substr.."BGOpacity").aide = DPSMate.L["bgOpacityTooltip"]
	_G(prestr..substr.."BorderOpacityText"):SetText(DPSMate.L["borderOpacity"])
	_G(prestr..substr.."BorderOpacity").aide = DPSMate.L["borderOpacityTooltip"]
	_G(prestr..substr.."BGColor_Font"):SetText(DPSMate.L["bgcolor"])
	_G(prestr..substr.."BGColor").aide = DPSMate.L["bgcolorTooltip"]
	_G(prestr..substr.."NumberFormat_Text"):SetText(DPSMate.L["numberformat"])
	_G(prestr..substr.."NumberFormat").aide = DPSMate.L["numberformatTooltip"]
	_G(prestr..substr.."BorderTexture_Text"):SetText(DPSMate.L["bordertexture"])
	_G(prestr..substr.."BorderTexture").aide = DPSMate.L["bordertextureTooltip"]
	_G(prestr..substr.."BorderStrata_Text"):SetText(DPSMate.L["borderstrata"])
	_G(prestr..substr.."BorderStrata").aide = DPSMate.L["borderstrataTooltip"]
	_G(prestr..substr.."BorderColor_Font"):SetText(DPSMate.L["bordercolor"])
	_G(prestr..substr.."BorderColor").aide = DPSMate.L["bordercolorTooltip"]
	
	-- Tab Dataresets
	substr = "Tab_DataResets_"
	_G(prestr..substr.."EnteringWorld_Text"):SetText(DPSMate.L["enterworldinstance"])
	_G(prestr..substr.."EnteringWorld").aide = DPSMate.L["enterworldinstanceTooltip"]
	_G(prestr..substr.."JoinParty_Text"):SetText(DPSMate.L["joinparty"])
	_G(prestr..substr.."JoinParty").aide = DPSMate.L["joinpartyTooltip"]
	_G(prestr..substr.."PartyMemberChanged_Text"):SetText(DPSMate.L["partymemberchanged"])
	_G(prestr..substr.."PartyMemberChanged").aide = DPSMate.L["partymemberchangedTooltip"]
	_G(prestr..substr.."LeaveParty_Text"):SetText(DPSMate.L["leavingparty"])
	_G(prestr..substr.."LeaveParty").aide = DPSMate.L["leavingpartyTooltip"]
	_G(prestr..substr.."Sync_Text"):SetText(DPSMate.L["syncrequest"])
	_G(prestr..substr.."Sync").aide = DPSMate.L["syncrequesttooltip"]
	_G(prestr..substr.."Logout_Text"):SetText(DPSMate.L["dataresetslogout"])
	_G(prestr..substr.."Logout").aide = DPSMate.L["dataresetslogouttooltip"]
	
	-- Tab general options
	substr = "Tab_GeneralOptions_"
	_G(prestr..substr.."Minimap_Title"):SetText(DPSMate.L["minimap"])
	_G(prestr..substr.."Minimap").aide = DPSMate.L["minimaptooltip"]
	_G(prestr..substr.."Total_Title"):SetText(DPSMate.L["showtotal"])
	_G(prestr..substr.."Total").aide = DPSMate.L["showtotaltooltip"]
	_G(prestr..substr.."Solo_Title"):SetText(DPSMate.L["solo"])
	_G(prestr..substr.."Solo").aide = DPSMate.L["solotooltip"]
	_G(prestr..substr.."Combat_Title"):SetText(DPSMate.L["combat"])
	_G(prestr..substr.."Combat").aide = DPSMate.L["combattooltip"]
	_G(prestr..substr.."Login_Title"):SetText(DPSMate.L["loginhide"])
	_G(prestr..substr.."Login").aide = DPSMate.L["loginhidetooltip"]
	_G(prestr..substr.."BossFights_Title"):SetText(DPSMate.L["bossfights"])
	_G(prestr..substr.."BossFights").aide = DPSMate.L["bossfightstooltip"]
	_G(prestr..substr.."PVP_Title"):SetText(DPSMate.L["pvp"])
	_G(prestr..substr.."PVP").aide = DPSMate.L["pvptooltip"]
	_G(prestr..substr.."Disable_Title"):SetText(DPSMate.L["disable"])
	_G(prestr..substr.."Disable").aide = DPSMate.L["disabletooltip"]
	_G(prestr..substr.."MergePets_Title"):SetText(DPSMate.L["mergepets"])
	_G(prestr..substr.."MergePets").aide = DPSMate.L["mergepetstooltip"]
	_G(prestr..substr.."SegmentsText"):SetText(DPSMate.L["segments"])
	_G(prestr..substr.."Segments").aide = DPSMate.L["segmentsTooltip"]
	_G(prestr..substr.."TargetScaleText"):SetText(DPSMate.L["targetscale"])
	_G(prestr..substr.."TargetScale").aide = DPSMate.L["targetscaleTooltip"]
	
	-- Tab Columns
	substr = "Tab_Columns_Child_"
	_G(prestr..substr.."DPS_Title"):SetText(DPSMate.L["dps"])
	_G(prestr..substr.."Damage_Title"):SetText(DPSMate.L["damage"])
	_G(prestr..substr.."DamageTaken_Title"):SetText(DPSMate.L["damagetaken"])
	_G(prestr..substr.."DTPS_Title"):SetText(DPSMate.L["dtps"])
	_G(prestr..substr.."EDD_Title"):SetText(DPSMate.L["enemydamagedone"])
	_G(prestr..substr.."EDT_Title"):SetText(DPSMate.L["enemydamagetaken"])
	_G(prestr..substr.."Healing_Title"):SetText(DPSMate.L["healing"])
	_G(prestr..substr.."HealingTaken_Title"):SetText(DPSMate.L["healingtaken"])
	_G(prestr..substr.."HPS_Title"):SetText(DPSMate.L["hps"])
	_G(prestr..substr.."Overhealing_Title"):SetText(DPSMate.L["overhealing"])
	_G(prestr..substr.."EffectiveHealing_Title"):SetText(DPSMate.L["effectivehealing"])
	_G(prestr..substr.."EffectiveHealingTaken_Title"):SetText(DPSMate.L["effectivehealingtaken"])
	_G(prestr..substr.."EffectiveHPS_Title"):SetText(DPSMate.L["effectivehps"])
	_G(prestr..substr.."Absorbs_Title"):SetText(DPSMate.L["absorbs"])
	_G(prestr..substr.."AbsorbsTaken_Title"):SetText(DPSMate.L["absorbstaken"])
	_G(prestr..substr.."HAB_Title"):SetText(DPSMate.L["healingandabsorbs"])
	_G(prestr..substr.."Deaths_Title"):SetText(DPSMate.L["deaths"])
	_G(prestr..substr.."Interrupts_Title"):SetText(DPSMate.L["interrupts"])
	_G(prestr..substr.."Dispels_Title"):SetText(DPSMate.L["dispels"])
	_G(prestr..substr.."DispelsReceived_Title"):SetText(DPSMate.L["dispelsreceived"])
	_G(prestr..substr.."Decurses_Title"):SetText(DPSMate.L["decurses"])
	_G(prestr..substr.."DecursesReceived_Title"):SetText(DPSMate.L["decursesreceived"])
	_G(prestr..substr.."Disease_Title"):SetText(DPSMate.L["curedisease"])
	_G(prestr..substr.."DiseaseReceived_Title"):SetText(DPSMate.L["curediseasereceived"])
	_G(prestr..substr.."Poison_Title"):SetText(DPSMate.L["curepoison"])
	_G(prestr..substr.."PoisonReceived_Title"):SetText(DPSMate.L["curepoisonreceived"])
	_G(prestr..substr.."Magic_Title"):SetText(DPSMate.L["liftmagic"])
	_G(prestr..substr.."MagicReceived_Title"):SetText(DPSMate.L["liftmagicreceived"])
	_G(prestr..substr.."AurasGained_Title"):SetText(DPSMate.L["aurasgained"])
	_G(prestr..substr.."AurasLost_Title"):SetText(DPSMate.L["auraslost"])
	_G(prestr..substr.."AuraUptime_Title"):SetText(DPSMate.L["aurauptime"])
	_G(prestr..substr.."FriendlyFire_Title"):SetText(DPSMate.L["friendlyfire"])
	_G(prestr..substr.."Procs_Title"):SetText(DPSMate.L["procs"])
	_G(prestr..substr.."Casts_Title"):SetText(DPSMate.L["casts"])
	_G(prestr..substr.."Threat_Title"):SetText(DPSMate.L["threat"])
	_G(prestr..substr.."TPS_Title"):SetText(DPSMate.L["tps"])
	_G(prestr..substr.."Fails_Title"):SetText(DPSMate.L["fails"])
	_G(prestr..substr.."CCBreaker_Title"):SetText(DPSMate.L["cccbreaker"])
	_G(prestr..substr.."OHPS_Title"):SetText(DPSMate.L["OHPS"])
	_G(prestr..substr.."OHealingTaken_Title"):SetText(DPSMate.L["OHealingTaken"])
	_G(prestr..substr.."FriendlyFireTaken_Title"):SetText(DPSMate.L["friendlyfiretaken"])
	
	-- Tab Tooltips
	substr = "Tab_Tooltips_"
	_G(prestr..substr.."Tooltips_Title"):SetText(DPSMate.L["showtooltips"])
	_G(prestr..substr.."Tooltips").aide = DPSMate.L["showtooltipsTooltip"]
	_G(prestr..substr.."InformativeTooltips_Title"):SetText(DPSMate.L["informativetooltips"])
	_G(prestr..substr.."InformativeTooltips").aide = DPSMate.L["informativetooltipsTooltip"]
	_G(prestr..substr.."RowsText"):SetText(DPSMate.L["subviewrows"])
	_G(prestr..substr.."Rows").aide = DPSMate.L["subviewrowsTooltip"]
	_G(prestr..substr.."Position_Text"):SetText(DPSMate.L["TooltipPositionDropDown"])
	_G(prestr..substr.."Position").aide = DPSMate.L["TooltipPositionDropDownTooltip"]
	
	-- Raidleader
	substr = "Tab_RaidLeader_"
	_G(prestr..substr.."HelloWorldText"):SetText(DPSMate.L["helloworld"])
	_G(prestr..substr.."HelloWorld").aide = DPSMate.L["helloworldTooltip"]
	
	-- Tab Broadcasting
	substr = "Tab_Broadcasting_"
	_G(prestr..substr.."Enable_Title"):SetText(DPSMate.L["enable"])
	_G(prestr..substr.."Enable").aide = DPSMate.L["enablebroadcasting"]
	_G(prestr..substr.."RaidWarning_Title"):SetText(DPSMate.L["useraidwarning"])
	_G(prestr..substr.."RaidWarning").aide = DPSMate.L["useraidwarningTooltip"]
	_G(prestr..substr.."Cooldowns_Title"):SetText(DPSMate.L["relevantcds"])
	_G(prestr..substr.."Cooldowns").aide = DPSMate.L["relevantcdsTooltip"]
	_G(prestr..substr.."Ress_Title"):SetText(DPSMate.L["ress"])
	_G(prestr..substr.."Ress").aide = DPSMate.L["ressTooltip"]
	_G(prestr..substr.."KillingBlows_Title"):SetText(DPSMate.L["killingblows"])
	_G(prestr..substr.."KillingBlows").aide = DPSMate.L["killingblowsTooltip"]
	_G(prestr..substr.."Fails_Title"):SetText(DPSMate.L["fails"])
	_G(prestr..substr.."Fails").aide = DPSMate.L["failsTooltip"]
	
	-- Tab About
	substr = "Tab_About_"
	_G(prestr..substr.."What_Title"):SetText(DPSMate.L["whatisdpsmate"])
	_G(prestr..substr.."What_Text"):SetText(DPSMate.L["whatisdpsmateText"])
	_G(prestr..substr.."Who_Title"):SetText(DPSMate.L["whocreateddpsmate"])
	_G(prestr..substr.."Who_Text"):SetText(DPSMate.L["whocreateddpsmateText"])
	_G(prestr..substr.."Thanks_Title"):SetText(DPSMate.L["thanksto"])
	_G(prestr..substr.."Thanks_Text"):SetText(DPSMate.L["thankstoText"])
	
	-- Damage done details
	DPSMate_Details_DiagramLegend_Procs_Text:SetText(DPSMate.L["procs"])
	DPSMate_Details_LogDetails_Block:SetText(DPSMate.L["block"])
	DPSMate_Details_LogDetails_Glance:SetText(DPSMate.L["glance"])
	DPSMate_Details_LogDetails_Hit:SetText(DPSMate.L["hit"])
	DPSMate_Details_LogDetails_Amount:SetText(DPSMate.L["amount"])
	DPSMate_Details_LogDetails_Average:SetText(DPSMate.L["average"])
	DPSMate_Details_LogDetails_Min:SetText(DPSMate.L["min"])
	DPSMate_Details_LogDetails_Max:SetText(DPSMate.L["max"])
	DPSMate_Details_LogDetails_Crit:SetText(DPSMate.L["crit"])
	DPSMate_Details_LogDetails_Miss:SetText(DPSMate.L["miss"])
	DPSMate_Details_LogDetails_Parry:SetText(DPSMate.L["parry"])
	DPSMate_Details_LogDetails_Dodge:SetText(DPSMate.L["dodge"])
	DPSMate_Details_LogDetails_Resist:SetText(DPSMate.L["resist"])
	
	DPSMate_Details_CompareDamage_DiagramLegend_Procs_Text:SetText(DPSMate.L["procs"])
	DPSMate_Details_CompareDamage_LogDetails_Block:SetText(DPSMate.L["block"])
	DPSMate_Details_CompareDamage_LogDetails_Glance:SetText(DPSMate.L["glance"])
	DPSMate_Details_CompareDamage_LogDetails_Hit:SetText(DPSMate.L["hit"])
	DPSMate_Details_CompareDamage_LogDetails_Amount:SetText(DPSMate.L["amount"])
	DPSMate_Details_CompareDamage_LogDetails_Average:SetText(DPSMate.L["average"])
	DPSMate_Details_CompareDamage_LogDetails_Min:SetText(DPSMate.L["min"])
	DPSMate_Details_CompareDamage_LogDetails_Max:SetText(DPSMate.L["max"])
	DPSMate_Details_CompareDamage_LogDetails_Crit:SetText(DPSMate.L["crit"])
	DPSMate_Details_CompareDamage_LogDetails_Miss:SetText(DPSMate.L["miss"])
	DPSMate_Details_CompareDamage_LogDetails_Parry:SetText(DPSMate.L["parry"])
	DPSMate_Details_CompareDamage_LogDetails_Dodge:SetText(DPSMate.L["dodge"])
	DPSMate_Details_CompareDamage_LogDetails_Resist:SetText(DPSMate.L["resist"])
	
	DPSMate.Options.Options[1]["args"]["damage"] = {
		order = 20,
		type = 'toggle',
		name = DPSMate.L["damage"],
		desc = DPSMate.L["show"].." "..DPSMate.L["damage"]..".",
		get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["damage"] end,
		set = function() DPSMate.Options:ToggleDrewDrop(1, "damage", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
	}
	DPSMate.Options.Options[1]["args"]["dps"] = {
		order = 10,
		type = 'toggle',
		name = DPSMate.L["dps"],
		desc = DPSMate.L["show"].." "..DPSMate.L["dps"]..".",
		get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["dps"] end, -- Addons might conflicting here with dewdrop
		set = function() DPSMate.Options:ToggleDrewDrop(1, "dps", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
	}
	
	-- Popups
	DPSMate_PopUp_Text:SetText(DPSMate.L["popup"])
	DPSMate_PopUp_TotalText:SetText(DPSMate.L["total"])
	DPSMate_PopUp_CurrentText:SetText(DPSMate.L["current"])
	DPSMate_PopUp_CancelText:SetText(DPSMate.L["cancel"])
	DPSMate_Vote_Text:SetText(DPSMate.L["popup"])
	DPSMate_Vote_AcceptText:SetText(DPSMate.L["vreset"])
	DPSMate_Vote_CancelText:SetText(DPSMate.L["vdreset"])
	DPSMate_Logout_Text:SetText(DPSMate.L["memory"])
	DPSMate_Logout_AcceptText:SetText(DPSMate.L["accept"])
	DPSMate_Logout_CancelText:SetText(DPSMate.L["decline"])
	DPSMate_Report_Text:SetText(DPSMate.L["report"].." - "..DPSMate.L["name"])
	DPSMate_Report_Channel_Text:SetText(DPSMate.L["channel"])
	DPSMate_Report_Delay.aide = DPSMate.L["reportdelaytooltip"]
	DPSMate_Report_Delay_Title:SetText(DPSMate.L["delay"])
	DPSMate_Report_Editbox_Text:SetText(DPSMate.L["editboxtitle"])
	DPSMate_Report_ReportButton:SetText(DPSMate.L["report"])
	
	
	DPSMate.Options.Options[2]["args"]["total"]["name"] = DPSMate.L["total"]
	DPSMate.Options.Options[2]["args"]["total"]["desc"] = DPSMate.L["totalmode"]
	DPSMate.Options.Options[2]["args"]["currentFight"]["name"] = DPSMate.L["mcurrent"]
	DPSMate.Options.Options[2]["args"]["currentFight"]["desc"] = DPSMate.L["currentmode"]
	DPSMate.Options.Options[3]["args"]["test"]["name"] = DPSMate.L["testmode"]
	DPSMate.Options.Options[3]["args"]["test"]["desc"] = DPSMate.L["testmodedesc"]
	DPSMate.Options.Options[3]["args"]["report"]["name"] = DPSMate.L["report"]
	DPSMate.Options.Options[3]["args"]["report"]["desc"] = DPSMate.L["reportsegment"]
	DPSMate.Options.Options[3]["args"]["reset"]["name"] = DPSMate.L["reset"]
	DPSMate.Options.Options[3]["args"]["reset"]["desc"] = DPSMate.L["resetdesc"]
	DPSMate.Options.Options[3]["args"]["realtime"]["name"] = DPSMate.L["mrealtime"]
	DPSMate.Options.Options[3]["args"]["realtime"]["desc"] = DPSMate.L["mrealtimedesc"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["damage"]["name"] = DPSMate.L["damagedone"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["damage"]["desc"] = DPSMate.L["realtimedmgdone"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["dmgt"]["name"] = DPSMate.L["damagetaken"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["dmgt"]["desc"] = DPSMate.L["realtimedmgtaken"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["heal"]["name"] = DPSMate.L["healing"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["heal"]["desc"] = DPSMate.L["realtimehealing"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["eheal"]["name"] = DPSMate.L["effectivehealing"]
	DPSMate.Options.Options[3]["args"]["realtime"]["args"]["eheal"]["desc"] = DPSMate.L["realtimeehealing"]
	DPSMate.Options.Options[3]["args"]["startnewsegment"]["name"] = DPSMate.L["newsegment"]
	DPSMate.Options.Options[3]["args"]["startnewsegment"]["desc"] = DPSMate.L["newsegmentdesc"]
	DPSMate.Options.Options[3]["args"]["deletesegment"]["name"] = DPSMate.L["removesegment"]
	DPSMate.Options.Options[3]["args"]["deletesegment"]["desc"] = DPSMate.L["removesegmentdesc"]
	DPSMate.Options.Options[3]["args"]["showAll"]["name"] = DPSMate.L["showAll"]
	DPSMate.Options.Options[3]["args"]["showAll"]["desc"] = DPSMate.L["showAllDesc"]
	DPSMate.Options.Options[3]["args"]["hideAll"]["name"] = DPSMate.L["hideAll"]
	DPSMate.Options.Options[3]["args"]["hideAll"]["desc"] = DPSMate.L["hideAllDesc"]
	DPSMate.Options.Options[3]["args"]["showwindow"]["name"] = DPSMate.L["showwindow"]
	DPSMate.Options.Options[3]["args"]["showwindow"]["desc"] = DPSMate.L["showwindowdesc"]
	DPSMate.Options.Options[3]["args"]["hidewindow"]["name"] = DPSMate.L["hidewindow"]
	DPSMate.Options.Options[3]["args"]["hidewindow"]["desc"] = DPSMate.L["hidewindowdesc"]
	DPSMate.Options.Options[3]["args"]["lock"]["name"] = DPSMate.L["lock"]
	DPSMate.Options.Options[3]["args"]["lock"]["desc"] = DPSMate.L["lockdesc"]
	DPSMate.Options.Options[3]["args"]["unlock"]["name"] = DPSMate.L["unlock"]
	DPSMate.Options.Options[3]["args"]["unlock"]["desc"] = DPSMate.L["unlock"]
	DPSMate.Options.Options[3]["args"]["configure"]["name"] = DPSMate.L["config"]
	DPSMate.Options.Options[3]["args"]["configure"]["desc"] = DPSMate.L["config"]
	DPSMate.Options.Options[3]["args"]["close"]["name"] = DPSMate.L["close"]
	DPSMate.Options.Options[3]["args"]["close"]["desc"] = DPSMate.L["close"]
	DPSMate.Options.Options[4]["args"]["report"]["name"] = DPSMate.L["report"]
	DPSMate.Options.Options[4]["args"]["report"]["desc"] = DPSMate.L["reportdesc"]
	DPSMate.Options.Options[4]["args"]["report"]["args"]["whisper"]["name"] = DPSMate.L["whisper"]
	DPSMate.Options.Options[4]["args"]["report"]["args"]["whisper"]["desc"] = DPSMate.L["whisperdesc"]
	DPSMate.Options.Options[4]["args"]["compare"]["name"] = DPSMate.L["comparewith"]
	DPSMate.Options.Options[4]["args"]["compare"]["desc"] = DPSMate.L["comparewithdesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["name"] = DPSMate.L["classes"]
	DPSMate.Options.Options[5]["args"]["classes"]["desc"] = DPSMate.L["classesdesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["warrior"]["name"] = DPSMate.L["warrior"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["warrior"]["desc"] = DPSMate.L["warlockdesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["rogue"]["name"] = DPSMate.L["rogue"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["rogue"]["desc"] = DPSMate.L["roguedesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["priest"]["name"] = DPSMate.L["priest"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["priest"]["desc"] = DPSMate.L["priestdesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["hunter"]["name"] = DPSMate.L["hunter"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["hunter"]["desc"] = DPSMate.L["hunterdesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["druid"]["name"] = DPSMate.L["druid"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["druid"]["desc"] = DPSMate.L["druiddesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["mage"]["name"] = DPSMate.L["mage"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["mage"]["desc"] = DPSMate.L["magedesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["warlock"]["name"] = DPSMate.L["warlock"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["warlock"]["desc"] = DPSMate.L["warlockdesc"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["paladin"]["name"] = DPSMate.L["paladin"]
	DPSMate.Options.Options[5]["args"]["classes"]["args"]["paladin"]["desc"] = DPSMate.L["paladindesc"]
	DPSMate.Options.Options[5]["args"]["people"]["name"] = DPSMate.L["certainnames"]
	DPSMate.Options.Options[5]["args"]["people"]["desc"] = DPSMate.L["certainnamesdesc"]
	DPSMate.Options.Options[5]["args"]["group"]["name"] = DPSMate.L["grouponly"]
	DPSMate.Options.Options[5]["args"]["group"]["desc"] = DPSMate.L["grouponlydesc"]
end