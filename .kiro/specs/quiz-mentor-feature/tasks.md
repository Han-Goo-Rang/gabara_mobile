# Implementation Plan

## Quiz Mentor Feature

- [x] 1. Extend Domain Layer Entities





  - [ ] 1.1 Update QuizEntity with new fields (status, classId, createdBy, createdAt)
    - Add `status` field with 'draft' | 'published' values
    - Add `classId` field for class association

    - Add computed properties: `questionCount`, `isPublished`, `isDraft`
    - _Requirements: 1.2, 1.3, 1.4_
  - [ ] 1.2 Update QuestionEntity with quizId and orderIndex
    - Add `quizId` field for quiz association
    - Add `orderIndex` field for question ordering

    - Add `questionType` field with 'multiple_choice' | 'true_false' values
    - Add computed properties: `isMultipleChoice`, `isTrueFalse`
    - _Requirements: 2.4, 2.5, 3.8_


  - [x] 1.3 Update OptionEntity with questionId and orderIndex


    - Add `questionId` field for question association
    - Add `orderIndex` field for option ordering
    - _Requirements: 2.4, 5.1_



- [ ] 2. Extend Data Layer Models and Service


  - [ ] 2.1 Update QuizModel with fromJson/toJson for new fields
    - Implement complete fromJson() parsing for all quiz fields
    - Implement complete toJson() serialization for all quiz fields
    - Handle nested questions parsing

    - _Requirements: 6.1, 6.5, 6.6_


  - [ ] 2.2 Write property test for QuizModel serialization round-trip
    - **Property 15: JSON serialization round-trip**
    - **Validates: Requirements 6.5, 6.6**
  - [ ] 2.3 Update QuestionModel with fromJson/toJson
    - Implement fromJson() for question_type, order_index

    - Implement toJson() serialization
    - Handle nested options parsing


    - _Requirements: 6.2_


  - [ ] 2.4 Update OptionModel with fromJson/toJson
    - Implement fromJson() for order_index
    - Implement toJson() serialization
    - _Requirements: 6.2_
  - [x] 2.5 Extend QuizService with mentor CRUD operations


    - Implement `fetchQuizzesByMentor(mentorId)` using Supabase
    - Implement `fetchQuizById(quizId)` with questions and options


    - Implement `createQuiz(quiz)` with nested questions/options
    - Implement `updateQuiz(quiz)` for metadata updates


    - Implement `deleteQuiz(quizId)` with cascade delete


    - _Requirements: 2.9, 6.1, 6.2, 6.3, 6.4_
  - [ ] 2.6 Write property test for quiz save round-trip
    - **Property 4: Quiz save round-trip consistency**

    - **Validates: Requirements 2.9, 6.1, 6.2**

- [ ] 3. Implement Quiz Validation Logic


  - [ ] 3.1 Create quiz validation functions
    - Implement `validateQuizTitle()` - reject empty/whitespace
    - Implement `validateQuizQuestions()` - reject empty list
    - Implement `validateQuestion()` - reject empty text


    - Implement `validateCorrectAnswer()` - ensure one correct option
    - Implement `validateDateRange()` - closeAt > openAt
    - _Requirements: 2.10, 2.11_
  - [x] 3.2 Write property tests for validation functions

    - **Property 5: Empty title validation rejection**
    - **Property 6: Empty questions validation rejection**

    - **Validates: Requirements 2.10, 2.11**

- [ ] 4. Checkpoint - Ensure all tests pass



  - Ensure all tests pass, ask the user if questions arise.



- [x] 5. Implement QuizProvider State Management



  - [x] 5.1 Create QuizProvider with state variables


    - Add `quizzes` list, `selectedQuiz`, `isLoading`, `errorMessage`



    - Implement `fetchMyQuizzes()` method


    - Implement `fetchQuizDetail(quizId)` method
    - _Requirements: 1.2, 3.2_
  - [ ] 5.2 Implement quiz CRUD methods in provider
    - Implement `createQuiz(quiz)` with validation
    - Implement `updateQuiz(quiz)` with validation
    - Implement `deleteQuiz(quizId)` with confirmation state
    - _Requirements: 2.9, 4.4, 6.3_

  - [ ] 5.3 Implement question builder state management
    - Implement `addQuestion()` - adds new question to builder
    - Implement `removeQuestion(index)` - removes question at index

    - Implement `updateQuestion(index, question)` - updates question
    - _Requirements: 2.6, 2.7_


  - [x] 5.4 Write property tests for question count invariants


    - **Property 2: Question addition increases count**
    - **Property 3: Question removal decreases count**
    - **Validates: Requirements 2.6, 2.7**
  - [ ] 5.5 Implement option management in provider
    - Implement `addOption(questionIndex)` - adds option to question

    - Implement `removeOption(questionIndex, optionIndex)` - removes option
    - Implement `setCorrectOption(questionIndex, optionIndex)` - marks correct
    - _Requirements: 5.2, 5.3, 5.4_
  - [ ] 5.6 Write property tests for option management
    - **Property 12: Option addition increases count**

    - **Property 13: Option removal decreases count**
    - **Property 7: Single correct answer invariant**

    - **Validates: Requirements 5.2, 5.3, 5.4**


- [ ] 6. Checkpoint - Ensure all tests pass

  - Ensure all tests pass, ask the user if questions arise.


- [ ] 7. Implement Date Formatting Utilities

  - [ ] 7.1 Create date formatting helper functions
    - Implement `formatQuizDate(DateTime)` → "DD/MM/YYYY, HH.MM.SS"

    - Implement `formatQuizTime(DateTime)` → "HH:MM"
    - _Requirements: 3.3, 3.4_
  - [x] 7.2 Write property test for date formatting

    - **Property 9: Date formatting consistency**
    - **Validates: Requirements 3.3, 3.4**


- [ ] 8. Implement QuizCard Widget

  - [ ] 8.1 Create QuizCard widget structure
    - Create card layout with title, description (truncated)
    - Add status badge (filled blue for published, outlined for draft)
    - Add duration badge showing "X menit"
    - Add question count badge showing "X soal"
    - Display open/close dates formatted

    - Add edit button (pencil icon, blue background)
    - Add delete button (trash icon, red background)
    - _Requirements: 1.2, 1.3, 1.4, 1.5_
  - [x] 8.2 Write property test for QuizCard rendering

    - **Property 1: QuizCard renders all required information**
    - **Validates: Requirements 1.2**
  - [ ] 8.3 Implement QuizCard interactions
    - Implement onTap → navigate to QuizDetail
    - Implement onEdit → open QuizModalEdit

    - Implement onDelete → show confirmation dialog
    - _Requirements: 1.6, 1.7, 1.8_

- [x] 9. Implement QuizListPage






  - [x] 9.1 Create QuizListPage layout

    - Add header with "Kuis" title and "+ Buat" button
    - Integrate with QuizProvider to fetch quizzes
    - Display loading state while fetching
    - Display empty state when no quizzes

    - Display QuizCard list when quizzes exist
    - _Requirements: 1.1, 1.2_
  - [ ] 9.2 Implement QuizListPage navigation
    - Navigate to QuizBuilderPage on "+ Buat" tap

    - Navigate to QuizDetailPage on card tap
    - Open QuizModalEdit on edit button tap

    - Show delete confirmation on delete button tap

    - _Requirements: 1.6, 1.7, 1.8, 2.1_


- [ ] 10. Implement QuestionEditor Widget


  - [ ] 10.1 Create QuestionEditor for multiple choice
    - Add question type dropdown (Pilihan Ganda / Benar Salah)

    - Add question text input field
    - Add "Hapus" button to remove question

    - Display option list with radio buttons and text inputs
    - Add "+ Tambah opsi" link
    - Add delete (x) button for each option

    - _Requirements: 2.4, 2.7, 5.1, 5.2, 5.3_

  - [ ] 10.2 Implement QuestionEditor for true/false
    - Display "Benar" and "Salah" radio buttons only
    - No additional option inputs
    - Handle type switching between multiple choice and true/false

    - _Requirements: 2.5, 5.5, 5.6_


  - [x] 10.3 Implement correct answer selection

    - Mark selected option with filled radio button
    - Ensure only one option is correct at a time
    - _Requirements: 2.12, 5.4_

- [ ] 11. Implement QuizBuilderPage

  - [x] 11.1 Create QuizBuilderPage form layout


    - Add breadcrumb "Home > Kuis > Buat Quiz"

    - Add form fields: Judul Quiz, Deskripsi (255 char limit with counter)
    - Add Kelas dropdown (fetch from ClassProvider)

    - Add Tanggal Dibuka date picker and Waktu Dibuka time picker
    - Add Tanggal Ditutup date picker and Waktu Ditutup time picker

    - Add Durasi (menit) number input
    - Add Status dropdown (Draf / Diterbitkan)


    - Add Kesempatan Mengerjakan number input

    - _Requirements: 2.2_
  - [ ] 11.2 Integrate QuestionEditor list
    - Display initial empty question section
    - Add "+ Tambah Pertanyaan" link at bottom

    - Handle question add/remove/update through provider

    - _Requirements: 2.3, 2.6, 2.7_


  - [ ] 11.3 Implement form submission
    - Add "Batal" button → navigate back without saving

    - Add "Simpan Quiz" button → validate and save
    - Show validation errors for invalid data

    - Navigate to quiz list on successful save
    - _Requirements: 2.8, 2.9, 2.10, 2.11_

- [ ] 12. Checkpoint - Ensure all tests pass


  - Ensure all tests pass, ask the user if questions arise.

- [x] 13. Implement QuizDetailPage


  - [ ] 13.1 Create QuizDetailPage layout
    - Add breadcrumb "Home > Kuis > [Quiz Title truncated]"
    - Display quiz info card with title, description

    - Display status badge, duration badge, question count badge
    - Display "Dibuka" with formatted date/time

    - Display "Ditutup" with formatted date/time
    - Display "Kesempatan Mengerjakan" with "Nx" format
    - Display "Durasi" with "N menit" format
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6_
  - [x] 13.2 Write property test for QuizDetail metadata rendering

    - **Property 8: QuizDetail renders all metadata**
    - **Validates: Requirements 3.2**
  - [ ] 13.3 Implement Daftar Soal section
    - Display "Daftar Soal" header
    - List all questions with "Soal N" header
    - Display question text

    - Display question type in italic (pilihan_ganda / benar_salah)
    - _Requirements: 3.7, 3.8_



  - [x] 13.4 Write property test for question list completeness

    - **Property 10: Question list completeness**
    - **Validates: Requirements 3.7**

- [x] 14. Implement QuizModalEdit


  - [ ] 14.1 Create QuizModalEdit dialog layout
    - Add modal with "Edit Quiz" title and X close button

    - Add form fields: Judul Quiz, Deskripsi (with char counter)
    - Add Kelas dropdown
    - Add Tanggal Dibuka, Waktu Dibuka pickers

    - Add Tanggal Ditutup, Waktu Ditutup pickers
    - _Requirements: 4.1, 4.3_

  - [ ] 14.2 Implement pre-population and save
    - Pre-populate all fields with existing quiz data
    - Implement save action on form submission
    - Close modal and discard changes on X tap
    - _Requirements: 4.2, 4.4, 4.5_

  - [x] 14.3 Write property test for edit modal pre-population



    - **Property 11: Edit modal pre-population**
    - **Validates: Requirements 4.2**

- [ ] 15. Wire Up Navigation and Routes

  - [ ] 15.1 Add quiz routes to main.dart
    - Add '/quiz' route → QuizListPage
    - Add '/quiz/create' route → QuizBuilderPage
    - Add '/quiz/:id' route → QuizDetailPage (via onGenerateRoute)
    - _Requirements: 1.8, 2.1, 2.8_
  - [ ] 15.2 Update TutorAppDrawer menu
    - Enable "Kuis" menu item
    - Navigate to QuizListPage on tap
    - _Requirements: 1.1_
  - [ ] 15.3 Register QuizProvider in app
    - Add QuizProvider to MultiProvider in main.dart
    - Ensure provider is available throughout quiz feature
    - _Requirements: 5.1_

- [ ] 16. Implement Delete Confirmation and Cascade

  - [ ] 16.1 Create delete confirmation dialog
    - Show dialog with quiz title
    - Add "Batal" and "Hapus" buttons
    - Call deleteQuiz on confirmation
    - _Requirements: 1.7_
  - [ ] 16.2 Write property test for cascade delete
    - **Property 14: Quiz deletion cascade**
    - **Validates: Requirements 6.3**

- [ ] 17. Final Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.
