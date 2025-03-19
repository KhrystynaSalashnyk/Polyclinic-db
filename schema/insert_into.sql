INSERT INTO Patients (identification_code, name, address, special_accounting) 
VALUES 
('1234567890', 'John Doe', '123 Main St', 1),
('9876543210', 'Jane Smith', '456 Elm St', 0),
('4567891234', 'Mike Johnson', '789 Oak St', 1),
('3216549870', 'Anna Brown', '321 Pine St', 0);

INSERT INTO Doctors (identification_code, name, specialization, address) 
VALUES 
('5678901234', 'Dr. House', 'Diagnostics', '101 Clinic Rd'),
('8765432109', 'Dr. Wilson', 'Oncology', '202 Cancer Center'),
('2345678901', 'Dr. Brown', 'Cardiology', '303 Heart Ave'),
('8901234567', 'Dr. White', 'Neurology', '404 Brain St');

INSERT INTO Treatment (patients_id, doctors_id, diagnosis, start_date, end_date, effectiveness, status, note, diagnosis_date) 
VALUES 
(1, 1, 'Flu', '2025-03-01', '2025-03-10', 90, 'Completed', 'Rest and fluids', '2025-03-01'),
(2, 2, 'Cancer', '2025-02-15', '2025-04-20', 70, 'Ongoing', 'Chemotherapy', '2025-02-15'),
(3, 3, 'Heart disease', '2025-03-01', '2025-03-30', 80, 'Completed', 'Surgery', '2025-03-01'),
(4, 4, 'Migraine', '2025-03-05', '2025-03-12', 60, 'Ongoing', 'Pain management', '2025-03-05');

INSERT INTO Medicines (name) 
VALUES 
('Aspirin'),
('Ibuprofen'),
('Paracetamol'),
('Amoxicillin');

INSERT INTO Ingredients (name, unit) 
VALUES 
('Acetylsalicylic Acid', 'mg'),
('Ibuprofen', 'mg'),
('Paracetamol', 'mg'),
('Amoxicillin', 'mg');

INSERT INTO Compositions (ingredients_id, medicines_id, amount) 
VALUES 
(1, 1, 500.00),
(2, 2, 200.00),
(3, 3, 300.00),
(4, 4, 250.00);

INSERT INTO Contraindications (patients_id, ingredients_id) 
VALUES 
(1, 3),
(2, 1),
(3, 2);

INSERT INTO Prescription (treatment_id, ingredients_id) 
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4);
