# 📚 ProAcademy

O **ProAcademy** é um aplicativo móvel desenvolvido para estudantes de nível médio e superior, com o objetivo de **facilitar o gerenciamento de projetos acadêmicos**, incluindo **tarefas, cronogramas e acompanhamento de progresso**.  
O app foi projetado para oferecer **usabilidade, organização e produtividade** em um ambiente moderno e intuitivo.

---

## 🚀 Funcionalidades

- **Cadastro e login de usuários** (com autenticação segura via API REST).
- **Atualização de dados do perfil**.
- **Criação, edição e exclusão de projetos** vinculados ao usuário.
- **Criação, edição e exclusão de tarefas** vinculadas aos projetos.
- **Acompanhamento de progresso** dos projetos e tarefas.
- **Exportação de dados em PDF**.
- **Modo offline** (armazenamento local sincronizado com a nuvem).
- **Notificações** para prazos e lembretes.
- **Tema claro e escuro** com base nas cores institucionais da **Unitins**.

---

## 🛠️ Tecnologias Utilizadas

### **Frontend**
- [Flutter](https://flutter.dev/) (Dart)
- Gerenciamento de estado: `setState` / Provider (dependendo da versão final)
- Design responsivo com Material Design

### **Backend**
- [Java 21](https://www.oracle.com/java/)
- [Spring Boot 3.5](https://spring.io/projects/spring-boot)
- API RESTful
- Autenticação com JWT
- Validação e tratamento de erros centralizados

### **Banco de Dados**
- [MySQL](https://www.mysql.com/)

---

## 📂 Estrutura do Projeto

proacademy_app/
├── lib/
│   ├── core/
│   │   ├── views/           # Telas do app organizadas por contexto
│   │   ├── models/          # Modelos de dados
│   │   ├── services/        # Comunicação com API
│   │   └── widgets/         # Componentes reutilizáveis
│   └── main.dart            # Ponto de entrada do app
└── pubspec.yaml

proacademy-backend/
├── src/main/java/com/proacademy/proacademy/
│   ├── controllers/   # Controladores REST
│   ├── dtos/          # Objetos de transferência de dados
│   ├── models/        # Entidades JPA
│   ├── repositories/  # Interfaces de persistência
│   ├── services/      # Regras de negócio
│   └── configs/       # Configurações de segurança e CORS
└── pom.xml

---

## 📦 Instalação e Uso

### **1️⃣ Clonar o repositório**
```bash
git clone https://github.com/lipeluccia/proacademy.git
cd proacademy
```

### **2️⃣ Backend**
```bash
cd proacademy-backend
mvn spring-boot:run
```
- A API será iniciada em: `http://localhost:8090`

### **3️⃣ Frontend**
```bash
cd proacademy_app
flutter pub get
flutter run
```

---

## 🔑 Variáveis de Ambiente

No backend, configurar o arquivo `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/proacademy
spring.datasource.username=SEU_USUARIO
spring.datasource.password=SUA_SENHA
jwt.secret=SUA_CHAVE_SECRETA
jwt.expiration=86400000
```

---

## 📌 Endpoints Principais

| Método | Endpoint                  | Descrição                       |
|--------|---------------------------|---------------------------------|
| POST   | `/auth/login`             | Autenticação de usuário         |
| POST   | `/auth/register`          | Registro de usuário             |
| GET    | `/projects`               | Lista de projetos do usuário    |
| POST   | `/projects`               | Cria novo projeto               |
| PUT    | `/projects/{id}`          | Atualiza projeto                |
| DELETE | `/projects/{id}`          | Remove projeto                  |
| GET    | `/tasks`                  | Lista de tarefas                |
| POST   | `/tasks`                  | Cria nova tarefa                |

---

## 🎨 Paleta de Cores

Baseada na identidade visual da **Unitins**:

| Cor          | Hex     |
|--------------|---------|
| Azul         | `#004093` |
| Azul Cinza   | `#405f6f` |
| Dourado Escuro | `#807d4a` |
| Dourado Médio | `#c09b25` |
| Amarelo Vivo | `#ffb900` |

---

## 📅 Status do Projeto

🚧 **Em desenvolvimento**  
O aplicativo encontra-se em estágio avançado, porém ainda **incompleto** devido a mudanças de emprego e município.  
Mesmo após o término da bolsa de extensão, o desenvolvimento **continuará até a conclusão**.

---

## 👨‍💻 Autor

**Felipe Luccia de Lima**  
Desenvolvedor Full Stack em formação  
📧 Email: [contato@felipeluccia.com](mailto:contato@felipeluccia.com)  
🔗 GitHub: [@lipeluccia](https://github.com/lipeluccia)

---

## 📜 Licença

Este projeto está licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para mais detalhes.
