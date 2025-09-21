# Архитектура приложения Quiz Admin App

## Обзор
Приложение построено по упрощенной чистой архитектуре с разделением на два основных слоя:

## Структура проекта

```
lib/
├── domain/                    # Бизнес-логика
│   ├── entities/             # Модели данных
│   │   ├── quiz.dart         # Модель квиза
│   │   └── question.dart     # Модель вопроса
│   └── repositories/         # Интерфейсы репозиториев
│       └── quiz_repository.dart
├── data/                     # Слой данных
│   └── repositories/        # Реализация репозиториев
│       └── quiz_repository_impl.dart
├── view/                     # Слой представления
│   ├── pages/               # Экраны приложения
│   │   ├── quiz_list_page.dart
│   │   ├── create_quiz_page.dart
│   │   └── quiz_detail_page.dart
│   └── providers/           # Управление состоянием
│       └── quiz_provider.dart
├── di/                      # Dependency Injection
│   └── injection_container.dart
└── main.dart               # Точка входа
```

## Слои архитектуры

### 1. Domain Layer (Слой домена)
- **Entities**: Чистые модели данных без зависимостей от фреймворков
- **Repositories**: Абстракции для работы с данными

### 2. Data Layer (Слой данных)
- **Repository Implementations**: Реализация интерфейсов из domain слоя с прямым доступом к SharedPreferences

### 3. View Layer (Слой представления)
- **Pages**: Экраны приложения
- **Providers**: Управление состоянием с помощью Provider
- **Widgets**: Переиспользуемые компоненты UI

## Модели данных

### Quiz (Квиз)
```dart
class Quiz {
  final String id;
  final String name;
  final List<Question> questions;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### Question (Вопрос)
```dart
class Question {
  final String questionText;
  final List<String> options;
  final List<int> correctAnswerIndexes;
}
```

## Функциональность

### Основные возможности:
1. **Создание квизов** - добавление названия и вопросов
2. **Редактирование квизов** - изменение существующих квизов
3. **Просмотр квизов** - детальный просмотр с вопросами и ответами
4. **Удаление квизов** - удаление с подтверждением
5. **Локальное хранение** - данные сохраняются в SharedPreferences

### Экраны:
1. **QuizListPage** - список всех квизов
2. **CreateQuizPage** - создание/редактирование квиза
3. **QuizDetailPage** - детальный просмотр квиза
4. **QuestionEditorPage** - редактор вопросов

## Технологии

- **Flutter** - UI фреймворк
- **Provider** - управление состоянием
- **SharedPreferences** - локальное хранение данных
- **Clean Architecture** - архитектурный паттерн

## Принципы

1. **Разделение ответственности** - каждый слой имеет свою зону ответственности
2. **Инверсия зависимостей** - domain слой не зависит от внешних слоев
3. **Простота** - убраны избыточные слои абстракции (use cases, data sources)
4. **Тестируемость** - каждый компонент можно тестировать изолированно
5. **Расширяемость** - легко добавлять новые источники данных или UI компоненты

## Упрощения

Для данного проекта были убраны избыточные слои:
- **Use Cases** - простые CRUD операции не требуют дополнительной абстракции
- **Data Sources** - репозиторий работает напрямую с SharedPreferences
- Это делает код более читаемым и менее сложным для поддержки
