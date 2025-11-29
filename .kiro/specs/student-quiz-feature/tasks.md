# Implementation Plan

## 1. Setup Database Schema and Core Entities

- [ ] 1.1 Create database migration for quiz_attempts and student_answers tables

  - Create quiz_attempts table with id, quiz_id, student_id, started_at, finished_at, status, score
  - Create student_answers table with id, attempt_id, question_id, selected_option_id, is_correct
  - Add indexes for performance
  - _Requirements: 8.1, 8.2, 8.4_

- [ ] 1.2 Create QuizAttemptEntity and StudentAnswerEntity in domain layer

  - Define QuizAttemptEntity with all required fields
  - Define StudentAnswerEntity with all required fields
  - Add helper getters for computed properties
  - _Requirements: 8.1, 8.2_

- [ ] 1.3 Create QuizAttemptModel and StudentAnswerModel in data layer

  - Implement fromJson and toJson for QuizAttemptModel
  - Implement fromJson and toJson for StudentAnswerModel
  - Ensure proper type handling for nullable fields
  - _Requirements: 8.1, 8.2_

- [ ] 1.4 Write property test for model serialization round-trip
  - **Property 5: Submission Data Completeness**
  - Test that toJson then fromJson produces equivalent model
  - **Validates: Requirements 5.5, 8.2**

## 2. Implement Student Quiz Service

- [ ] 2.1 Create StudentQuizService class

  - Implement fetchAttemptsByQuiz method
  - Implement fetchAttemptById method with answers
  - Implement createAttempt method
  - Implement submitAttempt method with score calculation
  - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5_

- [ ] 2.2 Implement score calculation logic

  - Compare selected options with correct options
  - Calculate percentage score
  - Handle edge cases (no answers, all wrong, all correct)
  - _Requirements: 5.3, 8.3_

- [ ] 2.3 Write property test for score calculation

  - **Property 1: Score Calculation Correctness**
  - Generate random answers and verify score = (correct/total) \* 100
  - **Validates: Requirements 5.3, 8.3**

- [ ] 2.4 Write property test for attempt history ordering
  - **Property 7: Attempt History Ordering**
  - Generate multiple attempts and verify descending order by started_at
  - **Validates: Requirements 8.5**

## 3. Implement Student Quiz Provider

- [ ] 3.1 Create StudentQuizProvider with core state management

  - Define state variables: currentQuiz, currentAttempt, attemptHistory, currentAnswers
  - Implement loadQuizWithAttempts method
  - Implement startQuizAttempt method
  - Implement selectAnswer method
  - Implement submitQuizAttempt method
  - _Requirements: 3.3, 4.4, 5.3_

- [ ] 3.2 Implement quiz availability validation logic

  - Check if current time is within open/close date range
  - Check if student has remaining attempts
  - Implement canStartQuiz method
  - Implement getStudentStatus method
  - _Requirements: 1.4, 1.5, 1.2, 1.3_

- [ ] 3.3 Write property test for quiz availability validation

  - **Property 2: Quiz Availability Validation**
  - Generate random dates and attempt counts, verify canStartQuiz result
  - **Validates: Requirements 1.4, 1.5**

- [ ] 3.4 Implement timer functionality

  - Add remainingSeconds state
  - Implement startTimer with countdown
  - Implement stopTimer
  - Handle timer expiry with auto-submit
  - _Requirements: 4.1, 4.2_

- [ ] 3.5 Write property test for timer formatting

  - **Property 8: Timer Duration Formatting**
  - Generate random seconds and verify M:SS format
  - **Validates: Requirements 4.1**

- [ ] 3.6 Write property test for answer state persistence

  - **Property 3: Answer State Persistence**
  - Select answer, change question, return, verify answer preserved
  - **Validates: Requirements 4.4, 4.5**

- [ ] 3.7 Write property test for answered count accuracy

  - **Property 9: Answered Count Accuracy**
  - Generate random answer states, verify count matches non-null answers
  - **Validates: Requirements 5.1**

- [ ] 3.8 Write property test for status display consistency
  - **Property 10: Status Display Consistency**
  - Generate attempt counts, verify status text matches expected
  - **Validates: Requirements 1.2, 1.3**

## 4. Checkpoint - Ensure Core Logic Tests Pass

- [ ] 4. Checkpoint
  - Ensure all tests pass, ask the user if questions arise.

## 5. Implement Student Quiz Detail Page

- [ ] 5.1 Create StudentQuizDetailPage scaffold

  - Create page with AppBar and breadcrumb navigation
  - Add Consumer for StudentQuizProvider
  - Implement loading and error states
  - _Requirements: 1.1_

- [ ] 5.2 Implement quiz info card section

  - Display quiz title, description
  - Display status badges (published, duration, question count)
  - Display open date, close date, max attempts, duration
  - Display student status (Belum mengerjakan / Selesai)
  - _Requirements: 1.1, 1.2, 1.3_

- [ ] 5.3 Implement "Mulai Quiz" button with validation

  - Show button when quiz is available
  - Disable button when outside date range or max attempts reached
  - Show appropriate message when disabled
  - _Requirements: 1.4, 1.5_

- [ ] 5.4 Create StartQuizDialog widget

  - Display quiz name, duration, open date, close date
  - Add "Batal" and "Mulai Sekarang" buttons
  - Handle button actions
  - _Requirements: 3.1, 3.2, 3.3, 3.4_

- [ ] 5.5 Create AttemptHistoryCard widget

  - Display attempt number, date/time, status
  - Display answered count and score
  - Add "Lihat Penilaian" link
  - _Requirements: 2.1, 2.2_

- [ ] 5.6 Implement attempt history section
  - Display "Riwayat Mengerjakan" header
  - List AttemptHistoryCard for each attempt
  - Show empty state message when no attempts
  - _Requirements: 2.1, 2.2, 2.3, 2.4_

## 6. Implement Quiz Taking Page

- [ ] 6.1 Create StudentQuizTakingPage scaffold

  - Create page with quiz title in AppBar
  - Add Consumer for StudentQuizProvider
  - Implement timer display in header
  - _Requirements: 4.1_

- [ ] 6.2 Create QuizTimerWidget

  - Display countdown in M:SS format
  - Update every second
  - Handle timer expiry
  - _Requirements: 4.1, 4.2_

- [ ] 6.3 Create AnswerOptionWidget

  - Display option text with letter prefix (A, B, C, D)
  - Handle selection state with visual highlight
  - Support radio-button style selection
  - _Requirements: 4.4_

- [ ] 6.4 Implement question display section

  - Display "Soal X dari Y" header
  - Display question text
  - Display answer options using AnswerOptionWidget
  - _Requirements: 4.3_

- [ ] 6.5 Implement navigation buttons

  - Add "Sebelumnya" and "Berikutnya" buttons
  - Handle first/last question edge cases
  - Navigate between questions
  - _Requirements: 4.6_

- [ ] 6.6 Create QuestionNavigationGrid widget

  - Display numbered grid of question buttons
  - Highlight current question
  - Distinguish answered vs unanswered questions
  - Handle tap to navigate to question
  - _Requirements: 4.6, 4.7, 4.8_

- [ ] 6.7 Create SubmitConfirmationDialog widget

  - Display answered count and total questions
  - Show warning about answer finality
  - Add "Kembali" and "Kirim Jawaban" buttons
  - _Requirements: 5.1, 5.2, 5.3, 5.4_

- [ ] 6.8 Implement submit flow
  - Show SubmitConfirmationDialog on finish button click
  - Handle submission via provider
  - Navigate to result page on success
  - _Requirements: 5.3, 5.5_

## 7. Implement Quiz Result Page

- [ ] 7.1 Create StudentQuizResultPage scaffold

  - Create page with breadcrumb navigation
  - Add Consumer for StudentQuizProvider
  - Display quiz title and attempt info header
  - _Requirements: 6.1_

- [ ] 7.2 Implement attempt summary section

  - Display score with large text
  - Display status badge ("finished")
  - Display started_at and finished_at timestamps
  - Display duration taken
  - _Requirements: 6.1, 6.5_

- [ ] 7.3 Create QuestionResultCard widget

  - Display question number and type
  - Display question text
  - Display student's answer
  - Display correct answer (Kunci Jawaban)
  - Apply green styling for correct answers
  - Apply red styling for incorrect answers
  - _Requirements: 6.2, 6.3, 6.4_

- [ ] 7.4 Write property test for answer correctness determination

  - **Property 6: Answer Correctness Determination**
  - Generate answers and verify is_correct matches option.is_correct
  - **Validates: Requirements 6.3, 6.4, 8.3**

- [ ] 7.5 Implement question results list
  - List all questions with QuestionResultCard
  - Show all options with correct/incorrect indicators
  - Highlight selected option and correct option
  - _Requirements: 6.2, 6.3, 6.4_

## 8. Implement Score Summary Modal

- [ ] 8.1 Create ScoreSummaryModal widget

  - Display quiz title with "Ringkasan Skor" header
  - Display percentage score with color coding
  - List all questions with answer options
  - Highlight correct answers with green border and "(Kunci)" label
  - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5_

- [ ] 8.2 Integrate ScoreSummaryModal into result flow
  - Show modal after quiz submission
  - Add close button to navigate to result page
  - _Requirements: 7.1_

## 9. Wire Up Navigation and Integration

- [ ] 9.1 Register StudentQuizProvider in app

  - Add provider to MultiProvider in main.dart
  - Inject StudentQuizService dependency
  - _Requirements: All_

- [ ] 9.2 Add navigation routes

  - Add route for StudentQuizDetailPage
  - Add route for StudentQuizTakingPage
  - Add route for StudentQuizResultPage
  - _Requirements: All_

- [ ] 9.3 Integrate with existing class/quiz navigation

  - Update quiz list to navigate to StudentQuizDetailPage for students
  - Handle role-based navigation (mentor vs student)
  - _Requirements: All_

- [ ] 9.4 Write property test for attempt record integrity
  - **Property 4: Attempt Record Integrity**
  - Start attempt and verify record has all required fields
  - **Validates: Requirements 3.3, 8.1**

## 10. Final Checkpoint

- [ ] 10. Final Checkpoint
  - Ensure all tests pass, ask the user if questions arise.
