# 🎨 Depth Estimation Viewer

**RGB Depth Estimation with Gradient Masking & Animation**

실시간 depth 추정 및 컬러 그라디언트 변환을 지원하는 웹 기반 이미지 뷰어입니다.

---

## ⚠️ 중요: 실행 환경

**이 애플리케이션은 반드시 HTTP/HTTPS 서버에서 실행해야 합니다!**

- ❌ **file:// 프로토콜로 직접 열면 작동하지 않습니다**
- ✅ **HTTP 서버를 실행한 후 브라우저에서 접속하세요**

### 빠른 시작

```bash
# 1. Python 서버 (가장 쉬운 방법)
python -m http.server 8000

# 2. Node.js 서버
npx http-server -p 8000

# 3. PHP 서버
php -S localhost:8000

# 그런 다음 브라우저에서:
http://localhost:8000/depth-estimation-viewer.html
```

---

## 🐛 오류 해결 가이드

### 1. **CORS 오류 (가장 흔한 문제)**

```
Access to fetch at 'file://...' has been blocked by CORS policy
```

**원인**: file:// 프로토콜로 HTML 파일을 직접 열었을 때 발생

**해결 방법**:
```bash
# 파일이 있는 폴더로 이동
cd /path/to/your/folder

# HTTP 서버 실행
python -m http.server 8000

# 브라우저에서 접속
# http://localhost:8000/depth-estimation-viewer.html
```

### 2. **HuggingFace 401 오류**

```
Failed to load resource: the server responded with a status of 401
```

**원인**: HuggingFace API 속도 제한 또는 일시적 접근 제한

**해결 방법**:

#### Option A: 잠시 후 다시 시도
- 몇 분 후 새로고침

#### Option B: 로컬 모델 사용

1. **모델 다운로드**
```bash
# huggingface-cli 설치
pip install huggingface-hub

# 모델 다운로드
huggingface-cli download Xenova/depth-anything-v2-small-hf --local-dir ./models/Xenova/depth-anything-v2-small-hf
```

2. **HTML 파일 수정** (depth-estimation-viewer.html 상단)
```javascript
// Configuration for local models
const USE_LOCAL_MODELS = true;  // false에서 true로 변경
const LOCAL_MODELS_PATH = '/models/'; // 모델 폴더 경로
```

3. **HTTP 서버 실행**
```bash
# 모델 폴더와 HTML이 같은 레벨에 있어야 함
# 프로젝트 구조:
# ├── depth-estimation-viewer.html
# └── models/
#     └── Xenova/
#         └── depth-anything-v2-small-hf/
#             ├── config.json
#             ├── preprocessor_config.json
#             └── onnx/
#                 └── model.onnx

python -m http.server 8000
```

### 3. **OPFS SecurityError**

```
SecurityError: It was determined that certain files are unsafe for access
```

**원인**: file:// 프로토콜에서는 OPFS(파일 시스템) 접근 불가

**해결 방법**:
- HTTP 서버에서 실행
- 또는 "다운로드" 기능 사용 (자동으로 폴백됨)

### 4. **카메라 접근 오류**

```
NotAllowedError: Permission denied
```

**해결 방법**:
1. **HTTPS 사용** (localhost는 예외)
2. 브라우저 주소창의 카메라 아이콘 클릭 → 권한 허용
3. Chrome 설정 → 개인정보 보호 및 보안 → 사이트 설정 → 카메라

---

## ✨ 주요 기능

### 🎯 핵심 기능

#### 1. **이미지 캡처 및 저장**
- 📷 **안드로이드 웹캠/시스템 카메라** 촬영 지원
- 📁 **파일 임포트** 기능 (이미지 파일 불러오기)
- 💾 **OPFS (Origin Private File System)** 저장
- 💿 **다운로드** 기능 (file:// 프로토콜용 폴백)

#### 2. **AI Depth 추정 처리**
- 🤖 **Transformers.js** + **Xenova/depth-anything-v2-small** 모델 사용
- 🌈 **RGB 이미지로 depth 추정** (그레이스케일 ❌)
- 🖥️ **로컬 처리** (서버 불필요)
- ⚡ **GPU 가속** (WebGPU/WebGL 지원)
- 📥 **자동 다운로드** (최초 실행 시 모델 자동 다운로드)

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
- ⚠️ **HTTP 서버 필요** (file://에서는 다운로드로 대체)

---

## ⚡ 성능 최적화

### GPU 가속 활성화
```javascript
// WebGPU 우선 사용, 실패 시 WASM 폴백
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
# 파일이 있는 폴더로 이동
cd /path/to/depth-estimation-viewer

# Option 1: Python 서버 (권장)
python -m http.server 8000

# Option 2: Python 3
python3 -m http.server 8000

# Option 3: Node.js 서버
npx http-server -p 8000

# Option 4: GitHub Pages (카메라 접근 가능)
# 파일을 GitHub 저장소에 업로드 후 Pages 활성화
```

### 2. 브라우저에서 접속
```
http://localhost:8000/depth-estimation-viewer.html
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
- **현재 이미지 저장** 버튼 → OPFS에 저장 (HTTP 서버 필요)
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
  1. **GPU 가속**: WebGPU → WASM 폴백 체인
  2. **멀티스레딩**: `numThreads` 설정
  3. **SIMD 활성화**: WASM SIMD 지원
  4. **메모리 최적화**: FP16 사용
  5. **Canvas 최적화**: `willReadFrequently` 옵션

### ✅ CORS/OPFS 오류
- **문제**: file:// 프로토콜에서 오류 발생
- **해결**:
  1. file:// 감지 및 경고 표시
  2. OPFS 실패 시 자동 다운로드 폴백
  3. 로컬 모델 지원 추가
  4. 상세한 오류 메시지 및 해결 방법 제공

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

- **HTTP/HTTPS 필수**: file:// 프로토콜에서는 제한적으로 작동
- **HTTPS 권장**: 카메라 접근 (localhost는 예외)
- **권한 허용**: 브라우저에서 카메라 권한 승인 필요

---

## 📦 로컬 모델 설정 (선택 사항)

HuggingFace 접근 제한이나 오프라인 사용을 위해 로컬 모델 사용 가능:

### 1. 모델 다운로드

```bash
# huggingface-cli 설치
pip install huggingface-hub

# 모델 다운로드
huggingface-cli download Xenova/depth-anything-v2-small-hf \
  --local-dir ./models/Xenova/depth-anything-v2-small-hf
```

### 2. 프로젝트 구조

```
프로젝트/
├── depth-estimation-viewer.html
└── models/
    └── Xenova/
        └── depth-anything-v2-small-hf/
            ├── config.json
            ├── preprocessor_config.json
            ├── model.safetensors
            └── onnx/
                ├── model.onnx
                ├── model_quantized.onnx
                └── ...
```

### 3. HTML 설정 변경

`depth-estimation-viewer.html` 파일 상단 (534행 근처):

```javascript
// Configuration for local models
const USE_LOCAL_MODELS = true;  // false → true로 변경
const LOCAL_MODELS_PATH = '/models/'; // 경로 확인
```

### 4. HTTP 서버 실행

```bash
python -m http.server 8000
```

---

## 💡 팁 & 트릭

### 최상의 결과를 위한 팁

1. **이미지 품질**: 고해상도 이미지 사용
2. **밝기**: 밝고 선명한 조명에서 촬영
3. **대비**: 명확한 depth 차이가 있는 장면
4. **성능**: WebGPU 지원 브라우저 사용 (Chrome/Edge)

### 성능 개선

- **작은 이미지**: 처리 속도 향상
- **브라우저 업데이트**: 최신 버전 사용
- **하드웨어 가속**: 브라우저 설정에서 활성화

---

## 📄 라이선스

MIT License

---

## 🤝 기여

버그 리포트 및 기능 제안은 Issue로 등록해주세요!

---

## 📞 지원

문제가 발생하면 다음을 확인하세요:

### 체크리스트

- [ ] ✅ HTTP 서버에서 실행 중? (file:// 아님)
- [ ] ✅ 인터넷 연결 확인 (최초 모델 다운로드)
- [ ] ✅ 최신 Chrome/Edge 브라우저?
- [ ] ✅ 브라우저 카메라 권한 허용?
- [ ] ✅ 콘솔에서 오류 메시지 확인 (F12)

### 자주 묻는 질문

**Q: "file://..." CORS 오류가 나요**
A: HTTP 서버를 실행하세요: `python -m http.server 8000`

**Q: 401 Unauthorized 오류**
A: HuggingFace 일시 제한. 몇 분 후 재시도 또는 로컬 모델 사용

**Q: OPFS SecurityError**
A: HTTP 서버에서 실행. file://에서는 다운로드 기능 사용

**Q: 카메라가 작동하지 않아요**
A: HTTPS 필요 (또는 localhost). 브라우저 권한 확인

**Q: 너무 느려요**
A: 이미지 크기 줄이기, WebGPU 지원 브라우저 사용

---

**Enjoy creating beautiful depth visualizations! 🎨✨**

---

## 🔍 개발자 정보

### 디버그 모드

브라우저 콘솔(F12)에서 상세 로그 확인:
- 모델 로딩 상태
- GPU/WASM 폴백 정보
- 렌더링 성능 정보

### 성능 모니터링

```javascript
// 콘솔에서 실행
console.log('Model:', window.depthApp.depthEstimator);
console.log('Settings:', window.depthApp.settings);
```

---

**버전**: 2.0.0
**마지막 업데이트**: 2025-11-06
**작성자**: Claude AI
