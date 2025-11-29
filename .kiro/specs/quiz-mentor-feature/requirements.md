# Requirements Document

## Introduction

Fitur Quiz untuk Mentor pada aplikasi Garasi Belajar memungkinkan mentor untuk membuat, mengelola, dan mempublikasikan kuis untuk kelas yang mereka ajar. Fitur ini mencakup pembuatan soal dengan berbagai tipe (Pilihan Ganda dan Benar/Salah), pengaturan jadwal kuis, serta manajemen status publikasi kuis.

## Glossary

- **Quiz**: Kumpulan soal yang dibuat mentor untuk menguji pemahaman siswa
- **Question (Pertanyaan/Soal)**: Item individual dalam kuis yang harus dijawab siswa
- **Option (Opsi)**: Pilihan jawaban untuk soal pilihan ganda
- **Multiple Choice (Pilihan Ganda)**: Tipe soal dengan beberapa opsi jawaban, satu yang benar
- **True/False (Benar/Salah)**: Tipe soal dengan dua pilihan jawaban: Benar atau Salah
- **Quiz Status**: Status publikasi kuis (Draf atau Diterbitkan)
- **Open Date (Tanggal Dibuka)**: Waktu mulai kuis dapat diakses siswa
- **Close Date (Tanggal Ditutup)**: Waktu berakhir kuis tidak dapat diakses lagi
- **Duration (Durasi)**: Batas waktu pengerjaan kuis dalam menit
- **Attempts Allowed (Kesempatan Mengerjakan)**: Jumlah maksimal percobaan siswa mengerjakan kuis
- **Mentor**: Pengguna dengan role tutor yang membuat dan mengelola kuis
- **QuizCard**: Widget card untuk menampilkan ringkasan kuis di halaman list
- **QuizBuilder**: Halaman untuk membuat kuis baru dengan form lengkap
- **QuizDetail**: Halaman untuk melihat detail kuis beserta daftar soal
- **QuizModalEdit**: Modal dialog untuk mengedit metadata kuis

## Requirements

### Requirement 1: Quiz List Display (QuizCard)

**User Story:** As a mentor, I want to see a list of quizzes I have created, so that I can manage and monitor my quizzes easily.

#### Acceptance Criteria

1. WHEN a mentor opens the Quiz page THEN the Quiz_System SHALL display a header with title "Kuis" and a "+ Buat" button on the right side
2. WHEN quizzes exist THEN the Quiz_System SHALL display each quiz as a QuizCard showing title, description, status badge, duration badge, question count badge, open date, and close date
3. WHEN a quiz has status "Diterbitkan" THEN the Quiz_System SHALL display a blue filled badge with text "Diterbitkan"
4. WHEN a quiz has status "Draf" THEN the Quiz_System SHALL display an outlined badge with text "Draf"
5. WHEN displaying a QuizCard THEN the Quiz_System SHALL show edit button (pencil icon, blue) and delete button (trash icon, red) at the bottom of the card
6. WHEN a mentor taps the edit button on QuizCard THEN the Quiz_System SHALL open the QuizModalEdit dialog
7. WHEN a mentor taps the delete button on QuizCard THEN the Quiz_System SHALL show a confirmation dialog before deleting
8. WHEN a mentor taps on a QuizCard (not on action buttons) THEN the Quiz_System SHALL navigate to QuizDetail page

### Requirement 2: Quiz Creation (QuizBuilder)

**User Story:** As a mentor, I want to create a new quiz with questions, so that I can assess my students' understanding of the material.

#### Acceptance Criteria

1. WHEN a mentor taps "+ Buat" button THEN the Quiz_System SHALL navigate to QuizBuilder page with breadcrumb "Home > Kuis > Buat Quiz"
2. WHEN QuizBuilder loads THEN the Quiz_System SHALL display a form with fields: Judul Quiz (text), Deskripsi (textarea with 255 char limit), Kelas (dropdown), Tanggal Dibuka (date picker), Waktu Dibuka (time picker HH:MM), Tanggal Ditutup (date picker), Waktu Ditutup (time picker HH:MM), Durasi in minutes (number), Status (dropdown: Draf/Diterbitkan), and Kesempatan Mengerjakan (number)
3. WHEN QuizBuilder loads THEN the Quiz_System SHALL display one empty question section with question type dropdown (Pilihan Ganda/Benar Salah), question text field, and options section
4. WHEN question type is "Pilihan Ganda" THEN the Quiz_System SHALL display radio buttons for each option with text input, a delete button (x) for each option, and "+ Tambah opsi" link
5. WHEN question type is "Benar / Salah" THEN the Quiz_System SHALL display two radio buttons labeled "Benar" and "Salah" without additional option inputs
6. WHEN a mentor taps "+ Tambah Pertanyaan" THEN the Quiz_System SHALL add a new question section below existing questions
7. WHEN a mentor taps "Hapus" on a question THEN the Quiz_System SHALL remove that question section from the form
8. WHEN a mentor taps "Batal" button THEN the Quiz_System SHALL navigate back to Quiz list without saving
9. WHEN a mentor taps "Simpan Quiz" button with valid data THEN the Quiz_System SHALL save the quiz and navigate to Quiz list
10. WHEN a mentor attempts to save quiz without title THEN the Quiz_System SHALL display validation error and prevent submission
11. WHEN a mentor attempts to save quiz without any questions THEN the Quiz_System SHALL display validation error and prevent submission
12. WHEN a mentor selects correct answer for Pilihan Ganda THEN the Quiz_System SHALL mark the selected option with filled red radio button

### Requirement 3: Quiz Detail View (QuizDetail)

**User Story:** As a mentor, I want to view the complete details of a quiz including all questions, so that I can review the quiz content.

#### Acceptance Criteria

1. WHEN a mentor opens QuizDetail THEN the Quiz_System SHALL display breadcrumb "Home > Kuis > [Quiz Title truncated]"
2. WHEN QuizDetail loads THEN the Quiz_System SHALL display quiz title, description, status badge, duration badge, and question count badge in a card section
3. WHEN QuizDetail loads THEN the Quiz_System SHALL display "Dibuka" with formatted date and time (DD/MM/YYYY, HH.MM.SS)
4. WHEN QuizDetail loads THEN the Quiz_System SHALL display "Ditutup" with formatted date and time (DD/MM/YYYY, HH.MM.SS)
5. WHEN QuizDetail loads THEN the Quiz_System SHALL display "Kesempatan Mengerjakan" with the number followed by "x"
6. WHEN QuizDetail loads THEN the Quiz_System SHALL display "Durasi" with the number followed by "menit"
7. WHEN QuizDetail loads THEN the Quiz_System SHALL display "Daftar Soal" section with all questions listed
8. WHEN displaying each question in Daftar Soal THEN the Quiz_System SHALL show "Soal [number]" as header, question text, and question type in italic (pilihan_ganda or benar_salah)

### Requirement 4: Quiz Edit Modal (QuizModalEdit)

**User Story:** As a mentor, I want to quickly edit quiz metadata without leaving the list page, so that I can make quick adjustments efficiently.

#### Acceptance Criteria

1. WHEN QuizModalEdit opens THEN the Quiz_System SHALL display a modal dialog with title "Edit Quiz" and close button (X)
2. WHEN QuizModalEdit loads THEN the Quiz_System SHALL pre-populate all fields with existing quiz data
3. WHEN QuizModalEdit displays THEN the Quiz_System SHALL show fields: Judul Quiz, Deskripsi (with character counter showing current/255), Kelas dropdown, Tanggal Dibuka, Waktu Dibuka, Tanggal Ditutup, Waktu Ditutup
4. WHEN a mentor modifies fields and closes modal THEN the Quiz_System SHALL save changes automatically or provide explicit save action
5. WHEN a mentor taps X button THEN the Quiz_System SHALL close the modal and discard unsaved changes

### Requirement 5: Question Management in QuizBuilder

**User Story:** As a mentor, I want to manage questions within a quiz flexibly, so that I can create comprehensive assessments.

#### Acceptance Criteria

1. WHEN adding a Pilihan Ganda question THEN the Quiz_System SHALL initialize with two empty options (Opsi A, Opsi B) by default
2. WHEN a mentor taps "+ Tambah opsi" THEN the Quiz_System SHALL add a new option input field below existing options
3. WHEN a mentor taps delete (x) on an option THEN the Quiz_System SHALL remove that option from the question
4. WHEN a mentor selects a radio button for an option THEN the Quiz_System SHALL mark that option as the correct answer
5. WHEN question type changes from Pilihan Ganda to Benar/Salah THEN the Quiz_System SHALL replace options with Benar/Salah radio buttons
6. WHEN question type changes from Benar/Salah to Pilihan Ganda THEN the Quiz_System SHALL restore default two empty options

### Requirement 6: Quiz Data Persistence

**User Story:** As a mentor, I want my quiz data to be saved reliably, so that I do not lose my work.

#### Acceptance Criteria

1. WHEN a quiz is saved THEN the Quiz_System SHALL store all quiz metadata including title, description, class_id, open_at, close_at, duration_minutes, status, and attempts_allowed
2. WHEN a quiz is saved THEN the Quiz_System SHALL store all questions with their type, text, options, and correct answer indicator
3. WHEN a quiz is deleted THEN the Quiz_System SHALL remove the quiz and all associated questions from storage
4. WHEN quiz list is refreshed THEN the Quiz_System SHALL fetch updated data from the server
5. WHEN serializing quiz data THEN the Quiz_System SHALL encode to JSON format
6. WHEN deserializing quiz data THEN the Quiz_System SHALL decode from JSON format and reconstruct quiz objects
