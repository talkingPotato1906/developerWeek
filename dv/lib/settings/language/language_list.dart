//  각 메시지 별 언어 리스트
class LanguageList {
  static Map<String, List<String>> languageMessages =
      // English, Korean, Japanese, Chinese
      {
    // 기본 메시지
    "앱 제목": ["Gallery for Mania", "마니아를 위한 전시장", "マニアのためのギャラリー", "为狂热者的画廊"],
    "설정": ["Settings", "설정", "設定", "设置"],
    "언어 선택": ["Select Language", "언어 선택", "言語選択", "选择语言"],
    "테마 선택": ["Select Theme", "테마 선택", "テーマ選択", "选择主题"],
    "홈": ["Home", "홈", "ホーム", "主页"],
    "로그아웃": ["Log Out", "로그아웃", "ログアウト", "登出"],
    "포인트 상점": ["Point Store", "포인트 상점", "ポイントストア", "积分商店"],
    "갤러리": ["Gallery", "갤러리", "ギャラリー", "画廊"],
    "갤러리가 비어있습니다": ["Gallery is empty", "갤러리가 비어있습니다", "ギャラリーが空です", "画廊是空的"],
    "나의 보관함": ["My Collection", "나의 보관함", "私のコレクション", "我的收藏"],
    "마이 페이지": ["My Page", "마이 페이지", "マイページ", "我的页面"],
    "카테고리": ["Category", "카테고리", "カテゴリー", "类别"],

    // 게시글 관련 메시지
    "제목과 내용 입력": [
      "Enter title and content",
      "제목과 내용 입력",
      "タイトルと内容を入力",
      "输入标题和内容"
    ],
    "제목을 입력하세요": ["Enter the title", "제목을 입력하세요", "タイトルを入力してください", "输入标题"],
    "내용을 입력하세요": ["Enter the content", "내용을 입력하세요", "内容を入力してください", "输入内容"],
    "확인": ["Confirm", "확인", "確認", "确认"],
    "수정": ["Edit", "수정", "編集", "编辑"],
    "삭제": ["Delete", "삭제", "削除", "删除"],
    "저장": ["Save", "저장", "保存", "保存"],
    "갤러리에 추가": ["Add to Gallery", "갤러리에 추가", "ギャラリーに追加", "添加到画廊"],
    "제목과 내용 수정": [
      "Edit title and content",
      "제목과 내용 수정",
      "タイトルと内容を編集",
      "标题和内容编辑"
    ],
    "갤러리 선택 제한": [
      "Gallery selection limit",
      "갤러리 선택 제한",
      "ギャラリー選択制限",
      "画廊选择限制"
    ],
    "최대 9개의 전시품만 선택할 수 있습니다.": [
      "You can only select up to 9 exhibits.",
      "최대 9개의 전시품만 선택할 수 있습니다.",
      "最大9つの展示品のみ選択できます。",
      "您只能选择最多9件展品。"
    ],

    // 로그인 관련 메시지
    "로그인 성공": ["Login successful", "로그인 성공", "ログイン成功", "登录成功"],
    "로그인 실패": ["Login failed", "로그인 실패", "ログインに失敗しました。", "登录失败"],
    "로그인": ["Log In", "로그인", "ログイン", "登录"],
    "이메일": ["Email", "이메일", "メール", "电子邮件"],
    "비밀번호": ["Password", "비밀번호", "パスワード", "密码"],
    "이메일을 입력하세요": [
      "Enter your email",
      "이메일을 입력하세요",
      "メールアドレスを入力してください",
      "输入您的电子邮件"
    ],
    "비밀번호를 입력하세요": [
      "Enter your password",
      "비밀번호를 입력하세요",
      "パスワードを入力してください",
      "输入您的密码"
    ],
    "마이 페이지로 이동": ["Go to my page", "마이 페이지로 이동", "マイページへ移動", "前往我的页面"],
    "환영합니다.": ["Welcome.", "환영합니다.", "ようこそ。", "欢迎。"],
    "로그아웃 되었습니다.": [
      "You have been logged out.",
      "로그아웃 되었습니다.",
      "ログアウトされました。",
      "您已退出登录。"
    ],

    // 로그아웃 상태에서 출력할 메시지
    "로그인이 필요한 서비스입니다.": [
      "This service requires login.",
      "로그인이 필요한 서비스입니다.",
      "ログインが必要なサービスです。",
      "此服务需要登录。"
    ],

    // 마이 페이지 내부 메시지
    "보유 포인트": ["Available Points", "보유 포인트", "保有ポイント", "持有积分"],
    "프로필 편집": ["Edit Profile", "프로필 편집", "プロフィール編集", "编辑个人资料"],
    "카테고리 즐겨찾기":["Favorite Categories", "카테고리 즐겨찾기", "カテゴリのお気に入り", "类别收藏夹"],
    "팔로우한 사람이 없습니다.":[
      "You are not following anyone.", 
      "팔로우한 사람이 없습니다.", 
      "フォローしている人がいません。",
      "您没有关注任何人。"
      ],

    // 포인트 메시지
    "품절": ["Sold Out", "품절", "完売", "售罄"],
    "구매": ["Purchase", "구매", "購入", "购买"],
    "취소": ["Cancel", "취소", "キャンセル", "取消"],

    //  회원가입 메시지
    "회원가입": ["Sign Up", "회원가입", "会員登録", "注册"],

    //sign_up_rules 메시지
    "부적합한 이메일입니다.":[
      "Invalid email.",
      "부적합한 이메일입니다."
      "不適切なメールアドレスです。",
      "无效的电子邮件。"
      ],
    "이미 존재하는 계정입니다.":[
      "This account already exists.",
      "이미 존재하는 계정입니다."
      "既に存在するアカウントです。",
      "该账户已存在。"
    ],
    "비밀번호는 8자 이상 20자 이하, 영문자와 숫자 및 특수문자(!@#%^&*)를 포함해야 합니다." :[
      "The password must be between 8 and 20 characters long and include letters, numbers, and special characters (!@#%^&*).",
      "비밀번호는 8자 이상 20자 이하, 영문자와 숫자 및 특수문자(!@#%^&*)를 포함해야 합니다.",
      "パスワードは8文字以上20文字以下で、英字、数字、および特殊文字 (!@#%^&*) を含める必要があります。",
      "密码必须为 8 至 20 个字符，并包含字母、数字和特殊字符 (!@#%^&)。"
    ],
    "회원가입에 성공했습니다.": [
      "Registration successful.",
      "회원가입에 성공했습니다.",
      "会員登録に成功しました。",
      "注册成功。"
    ],

    //카테고리
    "▼ 카테고리": ["▼ Category", "▼ 카테고리", "▼ カテゴリー", "▼ 类别"],

    "식물": ["Plant", "식물", "植物", "植物" ],
    "식기": ["Dishware", "식기", "食器", "餐具"],
    "원석": ["Gemstone", "원석", "原石", "原石"],
    "주류": ["Beverages", "주류", "酒類", "酒类"],
    "책": ["Book", "책", "本", "书"],
    "피규어": ["Figure", "피규어", "フィギュア", "手办"],
    "검색":["Search", "검색", "検索", "搜索"],
    "제목":["Title", "제목", "タイトル", "标题"],
    "날짜":["Date", "날짜", "日付", "日期"],

    //마이페이지-settings
    "새 비밀번호": ["New Password", "새 비밀번호", "新しいパスワード", "新密码"],
    "비밀번호 확인": ["Confirm Password", "비밀번호 확인", "パスワード確認", "确认密码"],
    "비밀번호 변경":["Change Password", "비밀번호 변경", "パスワード変更", "更改密码"],
    "회원 탈퇴":["Delete Account", "회원 탈퇴", "退会", "退出账户"],
    

    //home screen
    "갤러리 전시":["Gallery Exhibition", "갤러리 전시", "ギャラリー展示", "画廊展览"],
    "전시할 게시물이 없습니다.":[
      "No posts to exhibit.", 
      "전시할 게시물이 없습니다.", 
      "展示する投稿がありません。", 
      "没有可展览的帖子。"
      ],
    "팔로우한 게시글":["Followed Posts", "팔로우한 게시글", "フォローした投稿", "关注的帖子"],
    "게시글이 없습니다.":[
      "No posts available.", 
      "게시글이 없습니다.", 
      "投稿がありません。", 
      "没有帖子。"
      ],






  };
}
