--������ ����� �� ��������, ���� ���� ������ �� ������ ������ ����
SELECT D.name AS DoctorName, P.name AS PatientName, T.diagnosis
FROM Treatment T
JOIN Doctors D ON T.doctors_id = D.id
JOIN Patients P ON T.patients_id = P.id
WHERE '2025-03-10' BETWEEN T.start_date AND ISNULL(T.end_date, '9999-12-31')
ORDER BY D.name, P.name;


--��� "������ �������" ��� ������� �������� � ��������� ������� � ����������� ���
SELECT T.diagnosis, T.start_date, T.end_date, I.name AS Ingredient
FROM Treatment T
JOIN Patients P ON T.patients_id = P.id
LEFT JOIN Prescription PR ON PR.treatment_id = T.id
LEFT JOIN Ingredients I ON PR.ingredients_id = I.id
WHERE P.id = 1 -- ID ����������� ��������
ORDER BY T.start_date;


--������� ������� ������������� ����� �������� ������� ����
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



-- 1. SELECT �� ��� ���� ������� � ������������� ����������, ����������� ���� � �������� OR �� AND
-- ������� ��������, �� ��� �� ���������, ��� ������ �� ������� '123 Main St', ����������� �� ����
SELECT *
FROM Patients
WHERE special_accounting = 1 OR address = '123 Main St'
ORDER BY name;


-- 2. SELECT � ������� ������������ ���� (������) � �������� ����������
-- ������� �������� �� ������ ���� � �������� ����
SELECT name, address, LEN(name) AS name_length
FROM Patients;


-- 3. SELECT �� ��� ������ ������� � ������������� ����������, ����������� ���� � �������� OR �� AND
-- ������� �������� � �������� 'Completed' ��� ����������� ����� 80, ����������� �� �����������
SELECT T.id, P.name AS patient, D.name AS doctor, T.diagnosis, T.status, T.effectiveness
FROM Treatment T
JOIN Patients P ON T.patients_id = P.id
JOIN Doctors D ON T.doctors_id = D.id
WHERE T.status = 'Completed' OR T.effectiveness > 80
ORDER BY T.effectiveness DESC;


-- 4. SELECT �� ��� ������ ������� � ����� �������� Outer Join
-- ������� ��� �������� � �� ��������, ����� ���� �������� ����
SELECT P.name AS patient, T.diagnosis, T.status
FROM Patients P
LEFT JOIN Treatment T ON P.id = T.patients_id;


-- 5. SELECT � ������������� ��������� Like, Between, In, Exists, All, Any
-- ������� ��������, �� ��� �������� �� 'St', ��� ����� id � ������, ��� ����� ��������������
SELECT *
FROM Patients
WHERE address LIKE '%St%'
   OR id IN (1,2,3)
   OR EXISTS (SELECT 1 FROM Contraindications C WHERE C.patients_id = Patients.id);


-- 6. SELECT � ������������� ������������� �� ����������
-- ���������� ������� ������� ������� �����
SELECT D.name AS doctor, COUNT(T.id) AS treatments_count
FROM Doctors D
LEFT JOIN Treatment T ON D.id = T.doctors_id
GROUP BY D.name;


-- 7. SELECT � ������������� ��-������ � ������ WHERE
-- ������ ��������, �� ����� �������� � ����������� ����� ����������
SELECT *
FROM Patients
WHERE id IN (
    SELECT patients_id
    FROM Treatment
    WHERE effectiveness > (SELECT AVG(effectiveness) FROM Treatment)
);


-- 8. SELECT � ������������� ��-������ � ������ FROM
-- ������� �������� � ������� ���� �������
SELECT P.name, T.count_treatments
FROM Patients P
JOIN (
    SELECT patients_id, COUNT(*) AS count_treatments
    FROM Treatment
    GROUP BY patients_id
) T ON P.id = T.patients_id;


-- 9. ����������� SELECT-����� 
-- ������� ������ ������� �� ����� ����� � ��������
SELECT T.id, P.name AS patient, D.name AS doctor, T.diagnosis
FROM Treatment T
JOIN Patients P ON T.patients_id = P.id
JOIN Doctors D ON T.doctors_id = D.id;


-- 10. SELECT-����� ���� CrossTab (Pivot)
-- ������� ������� ������������ ����� �� �������
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


-- 11. UPDATE �� ��� ���� �������
-- ������� ������ ��������
UPDATE Patients
SET address = 'New Address 123'
WHERE id = 1;


-- 12. UPDATE �� ��� ������ �������
-- ������ ������ �������� �� 'Completed', ���� ������� �� ���������
UPDATE T
SET T.status = 'Completed'
FROM Treatment T
JOIN Patients P ON T.patients_id = P.id
WHERE P.special_accounting = 1;


-- 13. Append (INSERT) ��� ��������� ������ � ���� ��������� ����������
INSERT INTO Medicines (name)
VALUES ('New Medicine');


-- 14. Append (INSERT) ��� ��������� ������ � ����� �������
-- ������ �� �����䳺���, �� �� ������� �� ������� �������, � ������ ������������� ��� �������� 1
INSERT INTO Contraindications (patients_id, ingredients_id)
SELECT 1, I.id
FROM Ingredients I
WHERE NOT EXISTS (
    SELECT 1 FROM Compositions C WHERE C.ingredients_id = I.id
);

/*
-- 15. DELETE ��� ��������� ��� ����� � �������
DELETE FROM Prescription;


-- 16. DELETE ��� ��������� �������� ������ �������
-- �������� �� �������� � ����������� ����� 50
DELETE FROM Treatment
WHERE effectiveness < 50;
*/