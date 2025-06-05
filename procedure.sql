-- Створюємо таблицю рейтингу
IF OBJECT_ID('DoctorRatings', 'U') IS NULL
BEGIN
    CREATE TABLE DoctorRatings (
        doctor_id INT PRIMARY KEY,
        rating DECIMAL(10, 2)
    );
END;
GO

-- Створюємо процедуру для одного лікаря
CREATE OR ALTER PROCEDURE CalculateDoctorRating
    @doctor_id INT
AS
BEGIN
    DECLARE @avg_effectiveness FLOAT;
    DECLARE @patient_count INT;
    DECLARE @avg_duration FLOAT;
    DECLARE @avg_contraindications FLOAT;
    DECLARE @rating FLOAT;

    -- Середня ефективність лікування лікаря
    SELECT @avg_effectiveness = AVG(effectiveness)
    FROM Treatment
    WHERE doctors_id = @doctor_id;

    -- Кількість унікальних пацієнтів лікаря
    SELECT @patient_count = COUNT(DISTINCT patients_id)
    FROM Treatment
    WHERE doctors_id = @doctor_id;

    -- Середня тривалість лікування (у днях)
    SELECT @avg_duration = AVG(DATEDIFF(DAY, start_date, end_date))
    FROM Treatment
    WHERE doctors_id = @doctor_id AND end_date IS NOT NULL AND start_date IS NOT NULL;

    -- Середня кількість протипоказань на пацієнта
    SELECT @avg_contraindications = AVG(CNT)
    FROM (
        SELECT COUNT(*) AS CNT
        FROM Contraindications C
        JOIN Treatment T ON C.patients_id = T.patients_id
        WHERE T.doctors_id = @doctor_id
        GROUP BY C.patients_id
    ) AS SubQ;

    -- Формула розрахунку рейтингу 
    SET @rating = 
        ISNULL(@avg_effectiveness, 0) * 2 +
        ISNULL(@patient_count, 0) * 1.5 -
        ISNULL(@avg_duration, 0) * 0.5 -
        ISNULL(@avg_contraindications, 0) * 1.0;

    -- Зберігаємо або оновлюємо рейтинг у таблиці DoctorRatings
    IF EXISTS (SELECT 1 FROM DoctorRatings WHERE doctor_id = @doctor_id)
    BEGIN
        UPDATE DoctorRatings
        SET rating = @rating
        WHERE doctor_id = @doctor_id;
    END
    ELSE
    BEGIN
        INSERT INTO DoctorRatings (doctor_id, rating)
        VALUES (@doctor_id, @rating);
    END
END;
GO

-- Створюємо процедуру для всіх лікарів
CREATE OR ALTER PROCEDURE CalculateAllDoctorsRating
AS

BEGIN
    DECLARE @doctor_id INT;

    DECLARE doctor_cursor CURSOR FOR
        SELECT id FROM Doctors; 

    OPEN doctor_cursor;

    FETCH NEXT FROM doctor_cursor INTO @doctor_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC CalculateDoctorRating @doctor_id;
        FETCH NEXT FROM doctor_cursor INTO @doctor_id;
    END

    CLOSE doctor_cursor;
    DEALLOCATE doctor_cursor;
END;
GO


EXEC CalculateAllDoctorsRating;

SELECT * FROM DoctorRatings ORDER BY rating DESC;