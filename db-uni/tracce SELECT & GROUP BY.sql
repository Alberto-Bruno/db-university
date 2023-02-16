-- ---------------------------------------  QUERY CON SELECT

-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT `name`, `surname`, `date_of_birth` 
FROM `students`
WHERE YEAR(`date_of_birth`) = 1990;

-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT `name`, `cfu`
FROM `courses`
WHERE `cfu` > 10;

-- 3. Selezionare tutti gli studenti che hanno più di 30 anni
SELECT `name`, `surname`, `date_of_birth`
FROM `students`
WHERE DATE(`date_of_birth`) <=DATE_SUB(CURDATE(), INTERVAL 30 YEAR);

-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT `name`, `period`, `year`
FROM `courses`
WHERE `period` = 'I semestre' 
AND `year` = 1;

-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
SELECT `course_id`, `date`, `hour`
FROM `exams`
WHERE `date` = '2020-06-20' 
AND `hour` > '14:%';

-- 6. Selezionare tutti i corsi di laurea magistrale (38)
SELECT `name`, `level`
FROM `degrees`
WHERE `level` = 'magistrale';

-- 7. Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(*) AS 'Departments of university'
FROM `departments`;

-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT COUNT(*) AS 'Teachers without phone number'
FROM `teachers`
WHERE `phone` IS NULL;


-- ------------------------------------------ QUERY CON GROUP BY


-- 1. Contare quanti iscritti ci sono stati ogni anno
SELECT COUNT(*) 
AS 'Enrolled students', YEAR(`enrolment_date`) 
FROM `students`
GROUP BY YEAR(`enrolment_date`);

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT COUNT(*) 
AS 'teachers', `office_address`
FROM `teachers`
GROUP BY `office_address`;

-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT `exam_id` 
AS `appeal`, AVG(`vote`) 
AS 'media'
FROM `exam_student`
GROUP BY `exam_id`;

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT COUNT(*) 
AS 'Degree courses', department_id
FROM `degrees`
GROUP BY department_id;

-- ------------------------------------------ QUERY CON JOIN

-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT `students`.`name`, `students`.`surname`, `degrees`.`name`
FROM `degrees`
JOIN `students`
ON `degrees`.`id` = `students`.`degree_id`
WHERE `degrees`.`name` = 'Corso di Laurea in Economia';

-- 2. Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze
SELECT `degrees`.`name` AS 'Degrees', `departments`.`name`
FROM `departments`
JOIN `degrees`
ON `departments`.`id` = `degrees`.`department_id`
WHERE `departments`.`name` = 'Dipartimento di Neuroscienze';

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT `teachers`.`name`, `teachers`.`surname`, `courses`.`name` AS 'Nome Corso'
FROM `teachers`
JOIN `course_teacher`
ON `teachers`.`id`= `teacher_id`
JOIN `courses`
ON `courses`.`id`= `course_teacher`.`course_id`
WHERE `teachers`.`id` = 44;

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT `students`.`name`, `students`.`surname`, `departments`.`name` AS 'Department', `degrees`.`name` AS 'Degree', `degrees`.`level`, `degrees`.`email`, `degrees`.`address`, `degrees`.`website`
FROM `students`
JOIN `degrees`
ON `degrees`.`id` = `students`.`degree_id`
JOIN `departments`
ON `departments`.`id` = `degrees`.`department_id`  
ORDER BY `students`.`surname`;

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT `degrees`.`name` AS 'Degrees', `courses`.`name` AS 'Courses', `teachers`.`name`, `teachers`.`surname`
FROM `degrees`
JOIN `courses`
ON `degrees`.`id`= `courses`.`degree_id`
JOIN `course_teacher`
ON `courses`.`id` = `course_teacher`.`course_id`
JOIN `teachers`
ON `teachers`.`id` = `course_teacher`.`teacher_id`

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT DISTINCT `teachers`.`name`, `teachers`.`surname` AS 'Surname', `departments`.`name` AS 'Department'
FROM `teachers`
JOIN `course_teacher`
ON `teachers`.`id` = `course_teacher`.`teacher_id`
JOIN `courses`
ON `courses`.`id` = `course_teacher`.`course_id`
JOIN `degrees`
ON `degrees`.`id` = `courses`.`degree_id`
JOIN `departments`
ON `departments`.`id` = `degrees`.`department_id`
WHERE `departments`.`name` = 'Dipartimento di Matematica';

-- 7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per superare ciascuno dei suoi esami
SELECT `students`.`name` AS `student_name`, `students`.`surname` AS `student_surname`, COUNT(`exam_student`.`vote`) AS `attempts`, `courses`.`name` AS `course`
FROM `students`
JOIN `exam_student`
ON `students`.`id` = `exam_student`.`student_id`
JOIN `exams`
ON `exams`.`id` = `exam_student`.`exam_id`
JOIN `courses`
ON `courses`.`id` = `exams`.`course_id`
GROUP BY `students`.`id`, `courses`.`id`