# 🎨 Depth Estimation Viewer

**RGB Depth Estimation with Gradient Masking & Animation**

실시간 depth 추정 및 컬러 그라디언트 변환을 지원하는 웹 기반 이미지 뷰어입니다.

---

## ✨ 주요 기능

### 🎯 핵심 기능

#### 1. **이미지 캡처 및 저장**
- 📷 **안드로이드 웹캠/시스템 카메라** 촬영 지원
- 📁 **파일 임포트** 기능 (이미지 파일 불러오기)
- 💾 **OPFS (Origin Private File System)** 저장

#### 2. **AI Depth 추정 처리**
- 🤖 **Transformers.js** + **Xenova/depth-anything-v2-small** 모델 사용
- 🌈 **RGB 이미지로 depth 추정** (그레이스케일 ❌)
- 🖥️ **로컬 처리** (서버 불필요)
- ⚡ **GPU 가속** (WebGPU/WebGL 지원)

#### 3. **컬러 그라디언트 변환**
- 🎨 RGB depth 이미지를 **무지개 컬러 그라디언트**로 변환
- 🖌️ **5개의 그라디언트 컬러 개별 설정** 가능
- 🔄 **HSB 컬러 시스템**의 H(Hue) 파라미터를 시간에 따라 선형 증가
- ♾️ **루핑 애니메이션** 효과

---

## 🎛️ 컨트롤 기능

### 슬라이더 컨트롤

| 컨트롤 | 범위 | 설명 |
|--------|------|------|
| ⚡ **Hue 회전 속도** | -30 ~ +30 프레임 | HSB Hue 값의 회전 속도 조절 |
| 🌈 **그라디언트 밀도** | -30 ~ +30 | 그라디언트 간격 조정 |
| 🎨 **그라디언트 컬러** | 5개 색상 | 각 단계별 색상 커스터마이징 |

### 🎭 마스킹 기능

**Depth 거리 기반 블랙 마스킹**

- 📍 **시작 포인트 슬라이더** (0-255): 마스킹 시작 depth 값
- 📏 **영역 범위 슬라이더** (0-255): 마스킹 적용 범위
- 🔍 **경계 선명도 슬라이더** (0-100): 화이트→블랙 전환의 부드러움 정도
- 🔘 **ON/OFF 토글 버튼**: 마스킹 활성화/비활성화
- 🔄 **반전 버튼**: 마스킹 영역 반전

### 🖥️ 화면 제어

- **전체화면 전환 버튼** (⛶)
- 전체화면 상태에서 **화면 클릭** → 복귀

---

## 📚 라이브러리 관리

- 💾 각 이미지와 **설정값을 함께 저장**
- 🎬 재생 순서 지정 가능
- 🔁 반복 재생 (루프) 기능
- 🗑️ 개별 항목 삭제 기능

---

## ⚡ 성능 최적화

### GPU 가속 활성화
```javascript
// WebGPU 우선 사용, 실패 시 WebGL/WASM 폴백
device: 'webgpu'  // or 'wasm' fallback
dtype: 'fp16'     // 반정밀도 부동소수점으로 메모리 절약
```

### ONNX Runtime 튜닝
```javascript
env.backends.onnx.wasm.numThreads = navigator.hardwareConcurrency || 4;
env.backends.onnx.wasm.simd = true;
```

### 안드로이드 최적화
- Canvas 렌더링 최적화
- `willReadFrequently: true` 옵션으로 읽기 성능 향상
- 메모리 효율적인 Uint8Array 사용

---

## 🚀 사용 방법

### 1. 파일 실행
```bash
# HTTPS 환경에서 실행 (카메라 접근 필요)
# Option 1: Python 서버
python -m http.server 8000

# Option 2: Node.js 서버
npx http-server -p 8000 -S

# Option 3: GitHub Pages
# 파일을 GitHub 저장소에 업로드 후 Pages 활성화
```

### 2. 브라우저에서 접속
```
https://localhost:8000/depth-estimation-viewer.html
```

### 3. 이미지 캡처
1. **카메라** 버튼 클릭 → 웹캠/시스템 카메라로 촬영
2. **파일** 버튼 클릭 → 로컬 이미지 파일 선택

### 4. Depth 추정 대기
- AI 모델이 자동으로 depth를 추정합니다
- 처리 완료 후 컬러 그라디언트가 적용된 이미지가 표시됩니다

### 5. 설정 조정
- 슬라이더로 **Hue 회전 속도**, **그라디언트 밀도** 조절
- **컬러 피커**로 5단계 그라디언트 색상 변경
- **마스킹** 활성화 후 범위 조정

### 6. 애니메이션
- **재생** 버튼 클릭 → Hue 회전 애니메이션 시작
- **일시정지** 버튼으로 중지

### 7. 저장 & 라이브러리
- **현재 이미지 저장** 버튼 → OPFS에 저장
- 라이브러리에서 **썸네일 클릭** → 이전 작업 불러오기
- **×** 버튼으로 삭제

---

## 🐛 해결된 문제

### ✅ 마스킹 기능
- **문제**: 마스킹 미동작
- **해결**: Depth 값 기반 알파 블렌딩 구현
  - 시작 포인트와 범위로 마스킹 영역 정의
  - 경계 선명도 조절로 부드러운 전환
  - 반전 기능으로 역마스킹 지원

### ✅ 안드로이드 카메라 인식
- **문제**: 시스템 카메라 인식 불가
- **해결**:
  ```javascript
  navigator.mediaDevices.getUserMedia({
    video: {
      facingMode: { ideal: 'environment' },  // 후면 카메라 우선
      width: { ideal: 1280 },
      height: { ideal: 720 }
    }
  })
  ```

### ✅ 성능 저하
- **문제**: 심각한 성능 저하
- **해결**:
  1. **GPU 가속**: WebGPU → WebGL 폴백 체인
  2. **멀티스레딩**: `numThreads` 설정
  3. **SIMD 활성화**: WASM SIMD 지원
  4. **메모리 최적화**: FP16 사용
  5. **Canvas 최적화**: `willReadFrequently` 옵션

---

## 🛠️ 기술 스택

- **AI 모델**: Xenova/depth-anything-v2-small-hf
- **프레임워크**: Transformers.js
- **저장소**: OPFS (Origin Private File System)
- **렌더링**: HTML5 Canvas
- **가속**: WebGPU / WebGL / WASM
- **색상 시스템**: HSB (Hue, Saturation, Brightness)

---

## 📱 브라우저 호환성

| 브라우저 | 지원 여부 | 비고 |
|----------|-----------|------|
| Chrome 89+ | ✅ | WebGPU 지원 (권장) |
| Edge 89+ | ✅ | WebGPU 지원 |
| Safari 15+ | ✅ | WebGL 폴백 |
| Firefox 90+ | ✅ | WebGL 폴백 |
| Android Chrome | ✅ | 카메라 접근 가능 |
| iOS Safari | ✅ | 카메라 접근 가능 |

---

## 🔒 보안 요구사항

- **HTTPS 필수**: 카메라 접근을 위해 보안 컨텍스트 필요
- **권한 허용**: 브라우저에서 카메라 권한 승인 필요

---

## 📄 라이선스

MIT License

---

## 🤝 기여

버그 리포트 및 기능 제안은 Issue로 등록해주세요!

---

## 📞 지원

문제가 발생하면 다음을 확인하세요:

1. ✅ HTTPS 환경에서 실행 중인가?
2. ✅ 브라우저 카메라 권한이 허용되었는가?
3. ✅ 최신 Chrome/Edge 브라우저인가?
4. ✅ 인터넷 연결 (모델 다운로드 필요)

---

**Enjoy creating beautiful depth visualizations! 🎨✨**
