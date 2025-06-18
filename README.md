# LanguageExchangeApp (SwiftUI 기반)

iOS에서 SwiftUI로 제작된 **언어 교환 채팅 앱**입니다.  
두 명의 사용자가 각자의 언어로 대화하며, 메시지를 탭하면 해당 메시지를 음성으로 들을 수 있습니다.  
또한 언어별 음성을 설정할 수 있어, 학습 목적의 언어 연습에도 적합합니다.

## 주요 기능

-  실시간 채팅 인터페이스 (SwiftUI 기반)
-  메시지 클릭 시 TTS(음성합성) 발음 재생 (AVFoundation 사용)
-  사용자별 음성 설정 가능 (예: 한국어, 일본어 등)
-  읽음 표시 기능 (Read Receipt)
- 사용자 전환 (레나 ↔ 황민)

## 사용 기술

- SwiftUI
- AVFoundation (Text-to-Speech)
- MVVM 구조
- Codable, Enum 기반 데이터 구조

## 개발 목적

App Store에 존재하지 않는 ‘**양방향 언어 교환 채팅 앱**’의 필요성을 느껴 직접 개발하였습니다.  
메신저 + 언어학습 기능을 동시에 담은 이 앱은, 언어 교환 파트너 간 소통과 발음 학습을 직관적으로 지원합니다.

## 추후 개발 방향

- Firebase를 통한 실제 사용자간 메시지 전송
- 번역 기능 추가 (ChatGPT API 활용)
- UI 고도화 및 테마 추가

---
## 시연 유튜브 링크
https://www.youtube.com/watch?v=7qSGaKtIask
