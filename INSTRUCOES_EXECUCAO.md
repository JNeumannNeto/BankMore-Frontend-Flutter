# Instruções de Execução - BankMore Flutter Frontend

Este documento fornece instruções detalhadas para executar o aplicativo Flutter do BankMore.

## 📋 Pré-requisitos

### 1. Flutter SDK
- **Versão mínima**: Flutter 3.0.0
- **Dart SDK**: 3.0.0 ou superior

Para verificar se o Flutter está instalado:
```bash
flutter --version
```

Para instalar o Flutter, siga as instruções em: https://docs.flutter.dev/get-started/install

### 2. Ambiente de Desenvolvimento
- **Android Studio** (recomendado) ou **VS Code**
- **Android SDK** (para desenvolvimento Android)
- **Xcode** (para desenvolvimento iOS - apenas macOS)

### 3. Dispositivo/Emulador
- **Emulador Android** ou dispositivo físico Android
- **Simulador iOS** ou dispositivo físico iOS (apenas macOS)

## 🚀 Configuração Inicial

### 1. Clone o Repositório
```bash
git clone <repository-url>
cd BankMore-Frontend-Flutter
```

### 2. Instale as Dependências
```bash
flutter pub get
```

### 3. Verifique a Configuração do Flutter
```bash
flutter doctor
```

Resolva quaisquer problemas indicados pelo comando acima.

## 🔧 Configuração do Backend

**IMPORTANTE**: O aplicativo Flutter precisa se comunicar com as APIs do backend BankMore.

### 1. Inicie o Backend
Certifique-se de que o projeto `BankMore-Backend` está rodando com as seguintes APIs:

- **Account API**: http://localhost:5001
- **Transfer API**: http://localhost:5002  
- **Fee API**: http://localhost:5003

### 2. Configuração de URLs (Opcional)
Se as APIs estiverem rodando em portas diferentes, edite o arquivo:
`lib/services/api_service.dart`

```dart
static const String _baseUrl = 'http://localhost';
static const String _accountApiPort = '5001';  // Altere se necessário
static const String _transferApiPort = '5002'; // Altere se necessário
static const String _feeApiPort = '5003';      // Altere se necessário
```

## 📱 Executando o Aplicativo

### 1. Listar Dispositivos Disponíveis
```bash
flutter devices
```

### 2. Executar em Modo Debug
```bash
# Executar no primeiro dispositivo disponível
flutter run

# Executar em dispositivo específico
flutter run -d <device-id>

# Executar com hot reload ativado (padrão)
flutter run --hot
```

### 3. Executar em Modo Release
```bash
flutter run --release
```

## 🔍 Comandos Úteis

### Análise de Código
```bash
# Verificar problemas no código
flutter analyze

# Formatar código
flutter format .
```

### Limpeza
```bash
# Limpar cache e builds
flutter clean

# Reinstalar dependências
flutter pub get
```

### Build para Produção
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (apenas macOS)
flutter build ios --release
```

## 🐛 Solução de Problemas

### Problema: Erro de Conexão com API
**Sintomas**: Telas de erro, "Erro de conexão"

**Soluções**:
1. Verifique se o backend está rodando
2. Confirme as URLs das APIs
3. Verifique conectividade de rede
4. Para emulador Android, use `10.0.2.2` em vez de `localhost`

### Problema: Dependências não Encontradas
**Sintomas**: Erros de import, packages não encontrados

**Soluções**:
```bash
flutter clean
flutter pub get
```

### Problema: Erro de Build Android
**Sintomas**: Falha no build para Android

**Soluções**:
1. Verifique se o Android SDK está instalado
2. Configure as variáveis de ambiente ANDROID_HOME
3. Execute: `flutter doctor` e resolva os problemas

### Problema: Erro de Build iOS
**Sintomas**: Falha no build para iOS

**Soluções**:
1. Certifique-se de estar no macOS
2. Instale o Xcode
3. Execute: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`

## 📊 Estrutura de Telas

### Fluxo de Navegação
1. **Splash Screen** → Verificação de autenticação
2. **Login Screen** → Autenticação do usuário
3. **Register Screen** → Cadastro de novo usuário
4. **Dashboard Screen** → Tela principal com saldo e operações
5. **Transfer Screen** → Transferências entre contas
6. **Fees Screen** → Visualização de tarifas

### Dados de Teste
Para testar o aplicativo, você pode:

1. **Criar uma nova conta** na tela de registro
2. **Usar contas existentes** (se houver dados no backend)

## 🔐 Funcionalidades Implementadas

### ✅ Autenticação
- [x] Login com CPF ou número da conta
- [x] Cadastro de usuário
- [x] Logout seguro
- [x] Armazenamento seguro de tokens

### ✅ Operações Bancárias
- [x] Consulta de saldo
- [x] Depósitos
- [x] Saques
- [x] Transferências entre contas
- [x] Validação de conta de destino

### ✅ Tarifas
- [x] Visualização de tarifas
- [x] Resumo de valores
- [x] Histórico detalhado

### ✅ Interface
- [x] Design responsivo
- [x] Tema claro/escuro
- [x] Animações
- [x] Feedback visual
- [x] Tratamento de erros

## 📝 Logs e Debug

### Visualizar Logs
```bash
# Logs em tempo real
flutter logs

# Logs com filtro
flutter logs --verbose
```

### Debug no VS Code
1. Abra o projeto no VS Code
2. Instale a extensão Flutter
3. Pressione F5 para iniciar o debug
4. Use breakpoints para debug

### Debug no Android Studio
1. Abra o projeto no Android Studio
2. Configure um dispositivo/emulador
3. Clique em "Run" ou "Debug"
4. Use o debugger integrado

## 🚀 Deploy

### Android
1. Configure a assinatura do app
2. Execute: `flutter build appbundle --release`
3. Faça upload para Google Play Console

### iOS
1. Configure certificados no Xcode
2. Execute: `flutter build ios --release`
3. Faça upload para App Store Connect

## 📞 Suporte

Se encontrar problemas:

1. Verifique este documento
2. Execute `flutter doctor` para diagnóstico
3. Consulte a documentação oficial do Flutter
4. Verifique se o backend está funcionando corretamente

---

**Desenvolvido com ❤️ usando Flutter**
