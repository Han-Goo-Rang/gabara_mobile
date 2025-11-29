# Requirements Document

## Introduction

Fitur Student Quiz memungkinkan siswa (student) untuk mengerjakan kuis yang dibuat oleh mentor dalam konteks kelas tertentu. Fitur ini mencakup alur lengkap dari melihat detail kuis, memulai pengerjaan dengan timer, menjawab soal-soal, konfirmasi pengiriman jawaban, hingga melihat riwayat attempt dan hasil penilaian dengan indikator warna untuk jawaban benar (hijau) dan salah (merah).

## Glossary

- **Student**: Pengguna dengan role siswa yang dapat mengerjakan kuis
- **Quiz**: Kuis yang dibuat oleh mentor, berisi soal-soal pilihan ganda atau benar/salah
- **Attempt**: Satu kali percobaan pengerjaan kuis oleh student
- **Quiz_Attempt**: Record yang menyimpan data attempt student termasuk waktu mulai, selesai, dan skor
- **Student_Answer**: Record yang menyimpan jawaban student untuk setiap soal dalam satu attempt
- **Timer**: Penghitung waktu mundur selama pengerjaan kuis
- **Score**: Nilai persentase dari jawaban benar dibagi total soal
- **Correct_Answer_Indicator**: Indikator visual warna hijau untuk jawaban benar
- **Wrong_Answer_Indicator**: Indikator visual warna merah untuk jawaban salah

## Requirements

### Requirement 1

**User Story:** As a student, I want to view quiz details before starting, so that I can understand the quiz parameters and prepare accordingly.

#### Acceptance Criteria

1. WHEN a student opens a quiz detail page THEN the System SHALL display quiz title, description, status badges (published, duration, question count), open date, close date, max attempts, and duration
2. WHEN a student has not attempted the quiz THEN the System SHALL display status "Belum mengerjakan" and show "Mulai Quiz" button
3. WHEN a student has completed attempts THEN the System SHALL display status "Selesai" and show attempt history section
4. WHEN the quiz is not within open/close date range THEN the System SHALL disable the "Mulai Quiz" button
5. WHEN the student has reached maximum attempts THEN the System SHALL disable the "Mulai Quiz" button and display appropriate message

### Requirement 2

**User Story:** As a student, I want to see my quiz attempt history, so that I can track my progress and review past attempts.

#### Acceptance Criteria

1. WHEN a student views quiz detail with previous attempts THEN the System SHALL display "Riwayat Mengerjakan" section with list of attempts
2. WHEN displaying an attempt in history THEN the System SHALL show attempt number, date/time, status, answered questions count, and score
3. WHEN a student has no previous attempts THEN the System SHALL display message "Anda belum pernah mengerjakan kuis ini"
4. WHEN a student clicks "Lihat Penilaian" on an attempt THEN the System SHALL navigate to the attempt result page

### Requirement 3

**User Story:** As a student, I want to confirm before starting a quiz, so that I understand the timer will begin immediately.

#### Acceptance Criteria

1. WHEN a student clicks "Mulai Quiz" button THEN the System SHALL display a confirmation dialog with quiz name, duration, open date, and close date
2. WHEN the confirmation dialog is shown THEN the System SHALL provide "Batal" and "Mulai Sekarang" buttons
3. WHEN a student clicks "Mulai Sekarang" THEN the System SHALL create a new quiz attempt record and navigate to quiz taking page
4. WHEN a student clicks "Batal" THEN the System SHALL close the dialog and remain on quiz detail page

### Requirement 4

**User Story:** As a student, I want to answer quiz questions with a countdown timer, so that I can complete the quiz within the time limit.

#### Acceptance Criteria

1. WHEN a student starts a quiz THEN the System SHALL display countdown timer showing remaining time in minutes and seconds
2. WHEN the timer reaches zero THEN the System SHALL automatically submit all answers and navigate to confirmation dialog
3. WHEN a student is answering questions THEN the System SHALL display current question number, total questions, question text, and answer options
4. WHEN a student selects an answer option THEN the System SHALL visually highlight the selected option and store the selection
5. WHEN a student navigates between questions THEN the System SHALL preserve previously selected answers
6. WHEN displaying navigation THEN the System SHALL show "Sebelumnya" and "Berikutnya" buttons and a question number grid (Daftar Soal)
7. WHEN a student clicks a question number in the grid THEN the System SHALL navigate directly to that question
8. WHEN displaying the question grid THEN the System SHALL visually distinguish answered questions from unanswered questions

### Requirement 5

**User Story:** As a student, I want to confirm before submitting my answers, so that I can review my completion status.

#### Acceptance Criteria

1. WHEN a student clicks finish/submit button THEN the System SHALL display confirmation dialog showing answered count and total questions
2. WHEN the confirmation dialog is shown THEN the System SHALL warn that answers cannot be changed after submission
3. WHEN a student clicks "Kirim Jawaban" THEN the System SHALL submit all answers, calculate score, and update attempt record
4. WHEN a student clicks "Kembali" THEN the System SHALL close the dialog and return to quiz taking page
5. WHEN answers are submitted THEN the System SHALL persist student answers to the database with selected option IDs

### Requirement 6

**User Story:** As a student, I want to view my quiz results with correct/incorrect indicators, so that I can understand my performance.

#### Acceptance Criteria

1. WHEN a student views attempt result THEN the System SHALL display quiz title, attempt timestamps, total score, and status
2. WHEN displaying each question result THEN the System SHALL show question number, type, question text, student's answer, and correct answer
3. WHEN the student's answer is correct THEN the System SHALL display the answer option with green background/border color
4. WHEN the student's answer is incorrect THEN the System SHALL display the answer option with red background/border color and show the correct answer with green indicator
5. WHEN displaying score summary THEN the System SHALL show percentage score and "Selesai" status badge

### Requirement 7

**User Story:** As a student, I want to view a score summary modal, so that I can quickly see my overall performance.

#### Acceptance Criteria

1. WHEN a student completes a quiz THEN the System SHALL display a score summary modal with quiz title and percentage score
2. WHEN displaying the summary THEN the System SHALL list all questions with their answer options
3. WHEN displaying answer options in summary THEN the System SHALL highlight correct answers with green border and "(Kunci)" label
4. WHEN the student answered correctly THEN the System SHALL show the option as selected with green styling
5. WHEN the student answered incorrectly THEN the System SHALL show their selected option and indicate the correct answer separately

### Requirement 8

**User Story:** As a student, I want quiz data to be persisted correctly, so that my progress and results are saved reliably.

#### Acceptance Criteria

1. WHEN a student starts a quiz attempt THEN the System SHALL create a quiz_attempts record with student_id, quiz_id, started_at timestamp, and status "in_progress"
2. WHEN a student submits answers THEN the System SHALL create student_answers records linking attempt_id, question_id, and selected_option_id
3. WHEN calculating score THEN the System SHALL compare selected options with correct options and compute percentage
4. WHEN a quiz attempt is completed THEN the System SHALL update the attempt record with finished_at timestamp, score, and status "finished"
5. WHEN fetching attempt history THEN the System SHALL retrieve all attempts for the student-quiz combination ordered by started_at descending
