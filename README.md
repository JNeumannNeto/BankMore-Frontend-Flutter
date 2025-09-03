# BankMore Flutter Frontend

Frontend Flutter para o sistema bancário BankMore, desenvolvido para consumir as APIs do backend em .NET.

## 📱 Sobre o Projeto

Este é um aplicativo móvel Flutter que oferece uma interface moderna e intuitiva para o sistema bancário BankMore. O app permite aos usuários realizar operações bancárias básicas como cadastro, login, consulta de saldo, depósitos, saques, transferências e visualização de tarifas.

## 🏗️ Arquitetura

O projeto segue uma arquitetura limpa e organizada:

```
lib/
├── models/           # Modelos de dados
├── services/         # Serviços de API
├── providers/        # Gerenciamento de estado (Provider)
├── screens/          # Telas da aplicação
├── utils/           # Utilitários e formatadores
└── main.dart        # Ponto de entrada da aplicação
```

## 🚀 Funcionalidades

### ✅ Implementadas

- **Autenticação**
  - Cadastro de usuário com validação de CPF
  - Login com CPF ou número da conta
  - Logout seguro

- **Dashboard**
  - Visualização do saldo atual
  - Informações da conta
  - Acesso rápido às operações

- **Operações Bancárias**
  - Depósitos
  - Saques
  - Transferências entre contas
  - Validação de conta de destino

- **Tarifas**
  - Visualização de todas as tarifas
  - Resumo de valores
  - Histórico detalhado

- **Interface**
  - Design moderno e responsivo
  - Tema claro e escuro
  - Animações suaves
  - Feedback visual para ações

## 🛠️ Tecnologias Utilizadas

- **Flutter 3.0+**: Framework principal
- **Provider**: Gerenciamento de estado
- **HTTP**: Comunicação com APIs
- **Flutter Secure Storage**: Armazenamento seguro de tokens
- **Intl**: Formatação de datas e valores
- **CPF/CNPJ Validator**: Validação de documentos

## 📋 Pré-requisitos

- Flutter SDK 3.0 ou superior
- Dart SDK 3.0 ou superior
- Android Studio / VS Code
- Emulador Android ou dispositivo físico

## 🔧 Instalação e Execução

1. **Clone o repositório**
```bash
git clone <repository-url>
cd BankMore-Frontend-Flutter
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Configure o backend**
   - Certifique-se de que as APIs do BankMore-Backend estão rodando
   - As URLs padrão são:
     - Account API: http://localhost:5001
     - Transfer API: http://localhost:5002
     - Fee API: http://localhost:5003

4. **Execute o aplicativo**
```bash
flutter run
```

## 🔗 Integração com Backend

O aplicativo consome as seguintes APIs:

### Account API (Porta 5001)
- `POST /api/account/register` - Cadastro de usuário
- `POST /api/account/login` - Login
- `GET /api/account/balance` - Consulta de saldo
- `POST /api/account/movement` - Movimentações (depósito/saque)
- `GET /api/account/exists/{accountNumber}` - Verificação de conta

### Transfer API (Porta 5002)
- `POST /api/transfer` - Transferências entre contas

### Fee API (Porta 5003)
- `GET /api/fee/{accountNumber}` - Consulta de tarifas por conta

## 📱 Telas da Aplicação

### 1. Splash Screen
- Tela de carregamento inicial
- Verificação de autenticação
- Animações de entrada

### 2. Login
- Login com CPF ou número da conta
- Validação de campos
- Alternância entre tipos de login

### 3. Cadastro
- Formulário de registro
- Validação de CPF
- Confirmação de senha

### 4. Dashboard
- Saldo atual
- Informações da conta
- Acesso às operações principais

### 5. Transferência
- Validação de conta de destino
- Verificação de saldo
- Confirmação da operação

### 6. Tarifas
- Lista de todas as tarifas
- Resumo de valores
- Detalhes por operação

## 🎨 Design System

### Cores Principais
- **Primary**: #1976D2 (Azul)
- **Success**: #4CAF50 (Verde)
- **Error**: #E53935 (Vermelho)
- **Warning**: #FF9800 (Laranja)

### Componentes
- Cards com elevação
- Botões com estados de loading
- Campos de texto com validação
- Mensagens de erro e sucesso

## 🔒 Segurança

- **Tokens JWT**: Armazenamento seguro com Flutter Secure Storage
- **Validação de entrada**: Todos os campos são validados
- **Timeout de sessão**: Logout automático quando necessário
- **Comunicação HTTPS**: Preparado para produção

## 📊 Gerenciamento de Estado

Utiliza o padrão Provider com os seguintes providers:

- **AuthProvider**: Autenticação e dados do usuário
- **AccountProvider**: Operações de conta e saldo
- **TransferProvider**: Transferências
- **FeeProvider**: Tarifas

## 🧪 Testes

Para executar os testes:

```bash
flutter test
```

## 📦 Build para Produção

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🔧 Configurações

### URLs das APIs
As URLs das APIs podem ser configuradas no arquivo `lib/services/api_service.dart`:

```dart
static const String _baseUrl = 'http://localhost';
static const String _accountApiPort = '5001';
static const String _transferApiPort = '5002';
static const String _feeApiPort = '5003';
```

### Tema
O tema pode ser personalizado no arquivo `lib/utils/app_theme.dart`.

## 🐛 Troubleshooting

### Problemas Comuns

1. **Erro de conexão com API**
   - Verifique se o backend está rodando
   - Confirme as URLs das APIs
   - Verifique a conectividade de rede

2. **Erro de dependências**
   - Execute `flutter clean`
   - Execute `flutter pub get`

3. **Problemas de build**
   - Verifique a versão do Flutter
   - Atualize as dependências

## 📈 Próximas Melhorias

- [ ] Testes unitários e de integração
- [ ] Notificações push
- [ ] Biometria para login
- [ ] Modo offline
- [ ] Histórico de transações
- [ ] Exportação de extratos
- [ ] Suporte a múltiplas contas

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

---

**Desenvolvido com ❤️ usando Flutter**
