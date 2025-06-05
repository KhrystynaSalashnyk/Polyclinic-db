--Список лікарів та пацієнтів, яких вони лікують на певний момент часу
SELECT D.name AS DoctorName, P.name AS PatientName, T.diagnosis
FROM Treatment T
JOIN Doctors D ON T.doctors_id = D.id
JOIN Patients P ON T.patients_id = P.id
WHERE '2025-03-10' BETWEEN T.start_date AND ISNULL(T.end_date, '9999-12-31')
ORDER BY D.name, P.name;


--Звіт "Історія хвороби" для певного пацієнта з вказанням діагнозів і призначених ліків
SELECT T.diagnosis, T.start_date, T.end_date, I.name AS Ingredient
FROM Treatment T
JOIN Patients P ON T.patients_id = P.id
LEFT JOIN Prescription PR ON PR.treatment_id = T.id
LEFT JOIN Ingredients I ON PR.ingredients_id = I.id
WHERE P.id = 1 -- ID конкретного пацієнта
ORDER BY T.start_date;


--Зведена таблиця завантаженості лікарів протягом певного року
SELECT DoctorName, [1] AS Jan, [2] AS Feb, [3] AS Mar, [4] AS Apr,
       [5] AS May, [6] AS Jun, [7] AS Jul, [8] AS Aug, [9] AS Sep,
       [10] AS Oct, [11] AS Nov, [12] AS Dec
FROM (
    SELECT D.name AS DoctorName, MONTH(T.start_date) AS MonthNum
    FROM Treatment T
    JOIN Doctors D ON T.doctors_id = D.id
    WHERE YEAR(T.start_date) = 2025
) AS SourceTable
PIVOT (
    COUNT(MonthNum)
    FOR MonthNum IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) AS PivotTable
ORDER BY DoctorName;



-- 1. SELECT на базі однієї таблиці з використанням сортування, накладенням умов зі зв’язками OR та AND
-- Вивести пацієнтів, які або на спецобліку, або живуть за адресою '123 Main St', відсортувати по імені
SELECT *
FROM Patients
WHERE special_accounting = 1 OR address = '123 Main St'
ORDER BY name;


-- 2. SELECT з виводом обчислюваних полів (виразів) в колонках результату
-- Вивести пацієнтів та додати поле з довжиною імені
SELECT name, address, LEN(name) AS name_length
FROM Patients;


-- 3. SELECT на базі кількох таблиць з використанням сортування, накладенням умов зі зв’язками OR та AND
-- Вивести лікування зі статусом 'Completed' або ефективністю більше 80, відсортувати по ефективності
SELECT T.id, P.name AS patient, D.name AS doctor, T.diagnosis, T.status, T.effectiveness
FROM Treatment T
JOIN Patients P ON T.patients_id = P.id
JOIN Doctors D ON T.doctors_id = D.id
WHERE T.status = 'Completed' OR T.effectiveness > 80
ORDER BY T.effectiveness DESC;


-- 4. SELECT на базі кількох таблиць з типом поєднання Outer Join
-- Вивести всіх пацієнтів і їх лікування, навіть якщо лікування немає
SELECT P.name AS patient, T.diagnosis, T.status
FROM Patients P
LEFT JOIN Treatment T ON P.id = T.patients_id;


-- 5. SELECT з використанням операторів Like, Between, In, Exists, All, Any
-- Вивести пацієнтів, які або мешкають на 'St', або мають id в списку, або мають протипоказання
SELECT *
FROM Patients
WHERE address LIKE '%St%'
   OR id IN (1,2,3)
   OR EXISTS (SELECT 1 FROM Contraindications C WHERE C.patients_id = Patients.id);


-- 6. SELECT з використанням підсумовування та групування
-- Порахувати кількість лікувань кожного лікаря
SELECT D.name AS doctor, COUNT(T.id) AS treatments_count
FROM Doctors D
LEFT JOIN Treatment T ON D.id = T.doctors_id
GROUP BY D.name;


-- 7. SELECT з використанням під-запитів в частині WHERE
-- Знайти пацієнтів, які мають лікування з ефективністю більше середнього
SELECT *
FROM Patients
WHERE id IN (
    SELECT patients_id
    FROM Treatment
    WHERE effectiveness > (SELECT AVG(effectiveness) FROM Treatment)
);


-- 8. SELECT з використанням під-запитів в частині FROM
-- Вивести пацієнтів і кількість їхніх лікувань
SELECT P.name, T.count_treatments
FROM Patients P
JOIN (
    SELECT patients_id, COUNT(*) AS count_treatments
    FROM Treatment
    GROUP BY patients_id
) T ON P.id = T.patients_id;


-- 9. Ієрархічний SELECT-запит 
-- Вивести список лікувань та імена лікарів і пацієнтів
SELECT T.id, P.name AS patient, D.name AS doctor, T.diagnosis
FROM Treatment T
JOIN Patients P ON T.patients_id = P.id
JOIN Doctors D ON T.doctors_id = D.id;


-- 10. SELECT-запит типу CrossTab (Pivot)
-- Зведена таблиця завантаження лікарів за місяцями
SELECT doctor, [1] AS Jan, [2] AS Feb, [3] AS Mar, [4] AS Apr, [5] AS May, [6] AS Jun,
       [7] AS Jul, [8] AS Aug, [9] AS Sep, [10] AS Oct, [11] AS Nov, [12] AS Dec
FROM (
    SELECT D.name AS doctor, MONTH(T.start_date) AS month, COUNT(T.id) AS treat_count
    FROM Treatment T
    JOIN Doctors D ON T.doctors_id = D.id
    GROUP BY D.name, MONTH(T.start_date)
) AS SourceTable
PIVOT (
    SUM(treat_count)
    FOR month IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) AS PivotTable;


-- 11. UPDATE на базі однієї таблиці
-- Оновити адресу пацієнта
UPDATE Patients
SET address = 'New Address 123'
WHERE id = 1;


-- 12. UPDATE на базі кількох таблиць
-- Змінити статус лікування на 'Completed', якщо пацієнт на спецобліку
UPDATE T
SET T.status = 'Completed'
FROM Treatment T
JOIN Patients P ON T.patients_id = P.id
WHERE P.special_accounting = 1;


-- 13. Append (INSERT) для додавання записів з явно вказаними значеннями
INSERT INTO Medicines (name)
VALUES ('New Medicine');


-- 14. Append (INSERT) для додавання записів з інших таблиць
-- Додати всі інгредієнти, які не входять до жодного рецепта, у список протипоказань для пацієнта 1
INSERT INTO Contraindications (patients_id, ingredients_id)
SELECT 1, I.id
FROM Ingredients I
WHERE NOT EXISTS (
    SELECT 1 FROM Compositions C WHERE C.ingredients_id = I.id
);

/*
-- 15. DELETE для видалення всіх даних з таблиці
DELETE FROM Prescription;


-- 16. DELETE для видалення вибраних записів таблиці
-- Видалити всі лікування з ефективністю нижче 50
DELETE FROM Treatment
WHERE effectiveness < 50;
*/