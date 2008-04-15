local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("Chatter", "koKR")
if not L then return end

-- ./Chatter.lua
L["Standalone Config"] = "단독 설정"
L["Open a standalone config window. You might consider installing |cffffff00BetterBlizzOptions|r to make the Blizzard UI options panel resizable."] = "Chatter 설정창을 엽니다. |cffffff00BetterBlizzOptions|r을 설치하여 Blizzard UI 설정창의 크기를 조절할 수 있습니다."
L["Configure"] = "설정"
L["Modules"] = "모듈"
L["Settings"] = "현재 설정"
L["Enable "] = "사용: "
L["Enabled"] = "사용중"
L["Disabled"] = "미사용중"
L["Chatter Settings"] = "Chatter 설정"
L["Welcome to Chatter! Type /chatter to configure."] = "/chatter를 입력하면 설정창을 불러옵니다."

-- ./Modules/AltNames.lua
L["Alt Linking"] = "사용자 정보"
L["Use PlayerNames coloring"] = "플레이어 이름 색상 사용"
L["Use custom color"] = "사용자 색상 사용"
L["Use channel color"] = "대화 채널 색상 사용"
L["Name color"] = "이름 색상"
L["Set the coloring mode for alt names"] = "사용자 정보의 색상을 변경합니다."
L["Custom color"] = "사용자 색상"
L["Select the custom color to use for alt names"] = "사용자 정보의 사용자 색상을 선택합니다."
L["Who is %s's main?"] = true
L["Enables you to right-click a person's name in chat and set a note on them to be displayed in chat, such as their main character's name."] = "대화창에서 캐릭터 이름의 오른쪽 클릭으로 사용 가능합니다."

-- ./Modules/AutoLogChat.lua
L["Chat Autolog"] = "대화 자동저장"
L["Automatically turns on chat logging."] = "대화창의 내용을 자동으로 저장합니다."

-- ./Modules/Buttons.lua
L["Disable Buttons"] = "버튼 사용중지"
L["Show bottom when scrolled"] = "스크롤시 버튼 표시"
L["Show bottom button when scrolled up"] = "마우스로 대화창을 스크롤 할 때 버튼을 표시합니다."
L["Hides the buttons attached to the chat frame"] = "대화창에 표시되는 버튼을 숨깁니다."

-- ./Modules/ChannelColors.lua
L["Keeps your channel colors by name rather than by number."] = "대화채널을 이름으로 표시합니다."
L["Other Channels"] = "다른 채널"
L["Yell"] = "외치기"
L["Guild"] = "길드"
L["Officer"] = "길드관리자"
L["Raid"] = "공격대"
L["Party"] = "파티"
L["Raid Warning"] = "공격대 경보"
L["Say"] = "일반"
L["Battleground"] = "전장"
L["Whisper"] = "귓속말"
L["Select a color for this channel"] = "현재 채널의 색상을 선택합니다."


-- ./Modules/ChatFading.lua
L["Disable Fading"] = "사라짐 방지"
L["Makes old text disappear rather than fade out"] = "일정 시간 후에도 지난 대화가 계속 볼 수 있도록 합니다."

-- ./Modules/ChatFont.lua
L["Chat Font"] = "대화창 폰트"
L["Font"] = "폰트"
L["Font size"] = "폰트 크기"
L["Font Outline"] = "폰트 외곽선"
L["Font outlining"] = "폰트 외곽선을 사용합니다."
L["Chat Frame "] = "대화창 "
L["Enables you to set a custom font and font size for your chat frames"] = "대화창에 사용자 폰트 및 크기를 적용할 수 있습니다."


-- ./Modules/ChatLink.Lua
L["Chat Link"] = "대화창 링크"
L["Lets you link items, enchants, spells, and quests in custom channels."] = "사용자 채널에 아이템, 마법부여, 주문 및 퀘스트를 링크할 수 있습니다."

-- ./Modules/ChatScroll.lua
L["Mousewheel Scroll"] = "마우스 스크롤"
L["Scroll lines"] = "스크롤 줄 수"
L["How many lines to scroll per mouse wheel click"] = "휠 스크롤시 한 번에 몇 줄을 이동할지 선택합니다."
L["Lets you use the mousewheel to page up and down chat."] = "대화창을 마우스 휠의 스크롤을 이용하여 올리거나 내릴 수 있습니다."

-- ./Modules/ChatTabs.lua
L["Chat Tabs"] = "대화창 탭"
L["Button Height"] = "버튼 높이"
L["Button's height, and text offset from the frame"] = "버튼의 높이 및 글자의 위치를 변경합니다."


-- ./Modules/CopyChat.lua
L["Copy Chat"] = "대화창 복사"
L["Lets you copy text out of your chat frames."] = "대화창의 내용을 복사합니다."

L["Warlock"] = "흑마법사"
L["Warrior"] = "전사"
L["Hunter"] = "사냥꾼"
L["Mage"] = "마법사"
L["Priest"] = "사제"
L["Druid"] = "드루이드"
L["Paladin"] = "성기사"
L["Shaman"] = "주술사"
L["Rogue"] = "도적"

-- ./Modules/StickyChannels.lua
L["Sticky Channels"] = "채널 고정"
L["Emote"] = "감정표현"
L["Raid warning"] = "공격대 경보"
L["Custom channels"] = "사용자 채널"
L["Make %s sticky"] = "%s 채널고정"
L["Makes channels you select sticky."] = "선택한 채널을 채널고정으로 만듭니다."


-- ./Modules/Timestamps.lua
L["Timestamps"] = "시간표시"
L["HH:MM:SS AM (12-hour)"] = "시:분:초 오전 (12시간제)"
L["HH:MM (12-hour)"] = "시:분 (12시간제)"
L["HH:MM:SS (24-hour)"] = "시:분:초 (24시간제)"
L["HH:MM (24-hour)"] = "시:분 (24시간제)"
L["MM:SS"] = "분:초"
L["Timestamp format"] = "시간표시 형식"
L["Custom format (advanced)"] = "사용자 형식"
L["Enter a custom time format. See http://www.lua.org/pil/22.1.html for a list of valid formatting symbols."] = "시간표시 형식을 입력하세요. 사용되는 변수는 http://www.lua.org/pil/22.1.html를 참조하세요."
L["Timestamp color"] = "시간표시 색상"
L["Color timestamps the same as the channel they appear in."] = "시간표시의 색상을 대화채널의 색상과 동일하게 합니다."
L["Adds timestamps to chat."] = "대화창에 시간표시를 추가합니다."

-- ./Modules/TinyChat.lua
L["Tiny Chat"] = "작은 대화창"
L["Allows you to make the chat frames much smaller than usual."] = "현재보다 대화창을 작게 만듭니다."

-- ./Modules/UrlCopy.lua
L["URL Copy"] = "홈페이지 주소"
L["Lets you copy URLs out of chat."] = "대화창의 홈페이지 주소를 복사할 수 있습니다."

