snap 앱 만들기 프로젝트

1. 최상단 snap 디렉토리 들어가시면 snapTests 등 여러 개 있는데, snap 디렉토리 한 번 더 들어가시면 됩니다.
2. Model : 유저 데이터 모델, 아이템 데이터 모델을 정의했습니다.
3. View : 사용자에게 보여지는 화면들입니다. 큰 흐름은 MainView - AuthView - HomeView 로 이어집니다.
4. ViewModel : 각 뷰에서 사용되는 주요 로직 및 상태 처리를 담당합니다. FirebaseRepository 를 어디로 분류해야할까 감이 안와서 여기에다 같이 넣어두었습니다.
5. Design : 뭔가 자주 쓸 것 같은 버튼 디자인이나 프로필 아이콘 디자인 등의 모음입니다.

