# Design Document: Quiz Mentor Feature

## Overview

Fitur Quiz untuk Mentor memungkinkan mentor membuat, mengelola, dan mempublikasikan kuis untuk kelas yang mereka ajar. Implementasi mengikuti Clean Architecture pattern yang sudah ada di project dengan layer domain, data, dan presentation.

Fitur ini terdiri dari 4 komponen utama:

1. **QuizCard** - Widget untuk menampilkan ringkasan quiz di halaman list
2. **QuizBuilder** - Halaman untuk membuat quiz baru
3. **QuizDetail** - Halaman untuk melihat detail quiz
4. **QuizModalEdit** - Modal dialog untuk edit metadata quiz

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
├─────────────────────────────────────────────────────────────┤
│  Pages:                    Widgets:           Providers:     │
│  ├── QuizListPage          ├── QuizCard       QuizProvider   │
│  ├── QuizBuilderPage       ├── QuizModalEdit                 │
│  └── QuizDetailPage        ├── QuestionEditor                │
│                            └── OptionEditor                  │
├─────────────────────────────────────────────────────────────┤
│                      DOMAIN LAYER                            │
├─────────────────────────────────────────────────────────────┤
│  Entities:                                                   │
│  ├── QuizEntity (existing, needs extension)                  │
│  ├── QuestionEntity (existing)                               │
│  └── OptionEntity (existing)                                 │
├─────────────────────────────────────────────────────────────┤
│                       DATA LAYER                             │
├─────────────────────────────────────────────────────────────┤
│  Models:                   Services:                         │
│  ├── QuizModel (existing)  QuizService (needs extension)     │
│  ├── QuestionModel                                           │
│  └── OptionModel                                             │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

```
┌──────────┐    ┌─────────────┐    ┌─────────────┐    ┌──────────┐
│   UI     │───▶│  Provider   │───▶│   Service   │───▶│ Supabase │
│ (Pages)  │◀───│ (State Mgmt)│◀───│ (API Layer) │◀───│    DB    │
└──────────┘    └─────────────┘    └─────────────┘    └──────────┘
```

## Components and Interfaces

### 1. QuizEntity (Domain Layer - Extension)

```dart
class QuizEntity {
  final String id;
  final String classId;
  final String title;
  final String description;
  final List<QuestionEntity> questions;
  final DateTime? openAt;
  final DateTime? closeAt;
  final int attemptsAllowed;
  final int durationMinutes;
  final String status; // 'draft' | 'published'
  final String? createdBy;
  final DateTime? createdAt;

  // Computed properties
  int get questionCount => questions.length;
  bool get isPublished => status == 'published';
  bool get isDraft => status == 'draft';
}
```

### 2. QuestionEntity (Domain Layer - Extension)

```dart
class QuestionEntity {
  final String id;
  final String quizId;
  final String question;
  final String questionType; // 'multiple_choice' | 'true_false'
  final List<OptionEntity> options;
  final int orderIndex;

  // Computed
  bool get isMultipleChoice => questionType == 'multiple_choice';
  bool get isTrueFalse => questionType == 'true_false';
}
```

### 3. OptionEntity (Domain Layer)

```dart
class OptionEntity {
  final String id;
  final String questionId;
  final String text;
  final bool isCorrect;
  final int orderIndex;
}
```

### 4. QuizService (Data Layer - Extension)

```dart
abstract class QuizServiceInterface {
  // Fetch operations
  Future<List<QuizModel>> fetchQuizzesByMentor(String mentorId);
  Future<List<QuizModel>> fetchQuizzesByClass(String classId);
  Future<QuizModel?> fetchQuizById(String quizId);

  // CRUD operations
  Future<QuizModel> createQuiz(QuizModel quiz);
  Future<QuizModel> updateQuiz(QuizModel quiz);
  Future<void> deleteQuiz(String quizId);

  // Question operations
  Future<List<QuestionModel>> fetchQuestionsByQuiz(String quizId);
  Future<QuestionModel> createQuestion(QuestionModel question);
  Future<QuestionModel> updateQuestion(QuestionModel question);
  Future<void> deleteQuestion(String questionId);

  // Option operations
  Future<OptionModel> createOption(OptionModel option);
  Future<void> deleteOption(String optionId);
}
```

### 5. QuizProvider (Presentation Layer)

```dart
class QuizProvider extends ChangeNotifier {
  // State
  List<QuizModel> quizzes = [];
  QuizModel? selectedQuiz;
  bool isLoading = false;
  String? errorMessage;

  // Quiz operations
  Future<void> fetchMyQuizzes();
  Future<void> fetchQuizDetail(String quizId);
  Future<bool> createQuiz(QuizModel quiz);
  Future<bool> updateQuiz(QuizModel quiz);
  Future<bool> deleteQuiz(String quizId);

  // Local state management for builder
  void addQuestion();
  void removeQuestion(int index);
  void updateQuestion(int index, QuestionModel question);
  void addOption(int questionIndex);
  void removeOption(int questionIndex, int optionIndex);
  void setCorrectOption(int questionIndex, int optionIndex);
}
```

### 6. UI Components

#### QuizCard Widget

```dart
class QuizCard extends StatelessWidget {
  final QuizEntity quiz;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  // Displays: title, description, status badge, duration badge,
  // question count badge, open/close dates, edit/delete buttons
}
```

#### QuizBuilderPage

```dart
class QuizBuilderPage extends StatefulWidget {
  // Form fields: title, description, classId, openAt, closeAt,
  // duration, status, attemptsAllowed
  // Question list with QuestionEditor widgets
  // Buttons: Batal, Simpan Quiz
}
```

#### QuestionEditor Widget

```dart
class QuestionEditor extends StatelessWidget {
  final int index;
  final QuestionModel question;
  final Function(QuestionModel) onUpdate;
  final VoidCallback onDelete;

  // Dropdown: question type (Pilihan Ganda / Benar Salah)
  // TextField: question text
  // OptionEditor list or True/False radio buttons
}
```

#### QuizDetailPage

```dart
class QuizDetailPage extends StatelessWidget {
  final String quizId;

  // Displays: breadcrumb, quiz info card, question list
}
```

#### QuizModalEdit

```dart
class QuizModalEdit extends StatelessWidget {
  final QuizEntity quiz;
  final Function(QuizModel) onSave;

  // Modal with form fields for metadata only (no questions)
}
```

## Data Models

### Database Schema (Already exists in Supabase)

```sql
-- quizzes table
CREATE TABLE quizzes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  class_id UUID REFERENCES classes(id) NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  duration_minutes INTEGER DEFAULT 60,
  passing_score DECIMAL(5,2) DEFAULT 60.00,
  max_attempts INTEGER DEFAULT 1,
  is_active BOOLEAN DEFAULT true,
  open_at TIMESTAMP WITH TIME ZONE,
  close_at TIMESTAMP WITH TIME ZONE,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- questions table
CREATE TABLE questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id UUID REFERENCES quizzes(id) ON DELETE CASCADE NOT NULL,
  question_text TEXT NOT NULL,
  question_type TEXT CHECK (question_type IN ('multiple_choice', 'true_false', 'essay')),
  points INTEGER DEFAULT 10,
  order_index INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- options table
CREATE TABLE options (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID REFERENCES questions(id) ON DELETE CASCADE NOT NULL,
  option_text TEXT NOT NULL,
  is_correct BOOLEAN DEFAULT false,
  order_index INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### JSON Serialization Format

```json
{
  "id": "uuid",
  "class_id": "uuid",
  "title": "Quiz 1: Dasar Foodtech",
  "description": "Ayo uji seberapa jauh pemahamanmu...",
  "duration_minutes": 5,
  "max_attempts": 5,
  "is_active": true,
  "open_at": "2025-11-18T10:00:00Z",
  "close_at": "2025-11-30T15:00:00Z",
  "created_by": "uuid",
  "questions": [
    {
      "id": "uuid",
      "quiz_id": "uuid",
      "question_text": "Manakah pernyataan yang paling tepat?",
      "question_type": "multiple_choice",
      "order_index": 1,
      "options": [
        {
          "id": "uuid",
          "option_text": "Seni memasak makanan tradisional",
          "is_correct": false,
          "order_index": 1
        },
        {
          "id": "uuid",
          "option_text": "Penerapan ilmu pengetahuan",
          "is_correct": true,
          "order_index": 2
        }
      ]
    }
  ]
}
```

## Correctness Properties

_A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees._

Based on the prework analysis, the following correctness properties have been identified:

### Property 1: QuizCard renders all required information

_For any_ QuizEntity with valid data, the QuizCard widget SHALL render the title, description, status badge, duration badge, question count badge, open date, and close date.
**Validates: Requirements 1.2**

### Property 2: Question addition increases count

_For any_ quiz builder state with N questions, adding a new question SHALL result in exactly N+1 questions in the list.
**Validates: Requirements 2.6**

### Property 3: Question removal decreases count

_For any_ quiz builder state with N questions where N > 1, removing a question SHALL result in exactly N-1 questions in the list.
**Validates: Requirements 2.7**

### Property 4: Quiz save round-trip consistency

_For any_ valid QuizModel, saving to the database and then fetching by ID SHALL return an equivalent QuizModel with matching title, description, duration, attempts, and question count.
**Validates: Requirements 2.9, 6.1, 6.2**

### Property 5: Empty title validation rejection

_For any_ quiz data where title is empty or whitespace-only, the validation function SHALL return false and prevent submission.
**Validates: Requirements 2.10**

### Property 6: Empty questions validation rejection

_For any_ quiz data where questions list is empty, the validation function SHALL return false and prevent submission.
**Validates: Requirements 2.11**

### Property 7: Single correct answer invariant

_For any_ multiple choice question, selecting an option as correct SHALL mark exactly one option as correct and all others as not correct.
**Validates: Requirements 2.12, 5.4**

### Property 8: QuizDetail renders all metadata

_For any_ QuizEntity, the QuizDetail page SHALL display the title, description, status, duration, question count, open date, close date, and attempts allowed.
**Validates: Requirements 3.2**

### Property 9: Date formatting consistency

_For any_ DateTime value, the formatted string SHALL follow the pattern "DD/MM/YYYY, HH.MM.SS".
**Validates: Requirements 3.3, 3.4**

### Property 10: Question list completeness

_For any_ quiz with N questions, the QuizDetail page SHALL display exactly N question items in the "Daftar Soal" section.
**Validates: Requirements 3.7**

### Property 11: Edit modal pre-population

_For any_ QuizEntity, opening the QuizModalEdit SHALL pre-populate all form fields with the existing quiz values.
**Validates: Requirements 4.2**

### Property 12: Option addition increases count

_For any_ multiple choice question with N options, adding an option SHALL result in exactly N+1 options.
**Validates: Requirements 5.2**

### Property 13: Option removal decreases count

_For any_ multiple choice question with N options where N > 2, removing an option SHALL result in exactly N-1 options.
**Validates: Requirements 5.3**

### Property 14: Quiz deletion cascade

_For any_ quiz that is deleted, all associated questions and options SHALL also be removed from storage.
**Validates: Requirements 6.3**

### Property 15: JSON serialization round-trip

_For any_ valid QuizModel, serializing to JSON and then deserializing SHALL produce an equivalent QuizModel.
**Validates: Requirements 6.5, 6.6**

## Error Handling

### Validation Errors

| Error               | Condition                 | User Message                               |
| ------------------- | ------------------------- | ------------------------------------------ |
| EMPTY_TITLE         | Title is empty/whitespace | "Judul quiz tidak boleh kosong"            |
| EMPTY_QUESTIONS     | No questions added        | "Quiz harus memiliki minimal 1 pertanyaan" |
| EMPTY_QUESTION_TEXT | Question text is empty    | "Teks pertanyaan tidak boleh kosong"       |
| NO_CORRECT_ANSWER   | No option marked correct  | "Pilih jawaban yang benar"                 |
| INVALID_DATE_RANGE  | closeAt <= openAt         | "Tanggal tutup harus setelah tanggal buka" |

### Network Errors

| Error              | Handling                             |
| ------------------ | ------------------------------------ |
| Connection timeout | Show retry dialog                    |
| Server error (5xx) | Show error message with retry option |
| Unauthorized (401) | Redirect to login                    |
| Not found (404)    | Show "Quiz tidak ditemukan"          |

### State Management

- Loading states for all async operations
- Optimistic updates with rollback on failure
- Error state with user-friendly messages

## Testing Strategy

### Unit Testing

- QuizModel.fromJson() / toJson() serialization
- QuizEntity computed properties (questionCount, isPublished)
- Validation functions (validateQuiz, validateQuestion)
- Date formatting utilities

### Property-Based Testing

Using `fast_check` or `glados` package for Dart:

1. **Serialization round-trip** (Property 15)

   - Generate random QuizModel instances
   - Verify toJson() → fromJson() produces equivalent object

2. **Question count invariants** (Properties 2, 3, 10)

   - Generate random question lists
   - Verify add/remove operations maintain correct counts

3. **Single correct answer** (Property 7)

   - Generate random option selections
   - Verify exactly one option is marked correct

4. **Validation rejection** (Properties 5, 6)

   - Generate invalid quiz data (empty title, no questions)
   - Verify validation always rejects

5. **Date formatting** (Property 9)
   - Generate random DateTime values
   - Verify formatted string matches expected pattern

### Widget Testing

- QuizCard renders all required elements
- QuizBuilder form validation
- QuizModalEdit pre-population
- Navigation between pages

### Integration Testing

- Create quiz → appears in list
- Edit quiz → changes reflected
- Delete quiz → removed from list
- Quiz with questions → detail shows all questions
