CREATE TABLE Patients (
    id INT IDENTITY(1,1) PRIMARY KEY,
	 identification_code CHAR(10) NOT NULL UNIQUE,
    name NVARCHAR(100) NOT NULL,
    address NVARCHAR(255),
    special_accounting BIT NOT NULL
);
GO

CREATE TABLE Doctors (
    id INT IDENTITY(1,1) PRIMARY KEY,
	identification_code CHAR(10) NOT NULL UNIQUE,
    name NVARCHAR(100) NOT NULL,
    specialization NVARCHAR(100) NOT NULL,
    address NVARCHAR(255)
);
GO

CREATE TABLE Treatment (
    id INT IDENTITY(1,1) PRIMARY KEY,
    patients_id INT,
    doctors_id INT,
    diagnosis NVARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    effectiveness INT CHECK (effectiveness BETWEEN 0 AND 100),
    status NVARCHAR(50) CHECK (status IN ('Completed', 'Ongoing', 'Pending')),
    note NVARCHAR(500),
    diagnosis_date DATE NOT NULL,
    CONSTRAINT fk_treatment_patients
        FOREIGN KEY (patients_id) REFERENCES Patients(id),
    CONSTRAINT fk_treatment_doctors
        FOREIGN KEY (doctors_id) REFERENCES Doctors(id),
	CONSTRAINT chk_treatment_status_completed 
        CHECK (
		    status IN ('Ongoing', 'Pending')
            OR (status = 'Completed' AND end_date IS NOT NULL)
            
        )
);
GO

CREATE TABLE Medicines (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE Ingredients (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    unit NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Compositions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ingredients_id INT,
    medicines_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_compositions_ingredients
        FOREIGN KEY (ingredients_id) REFERENCES Ingredients(id),
    CONSTRAINT fk_compositions_medicines
        FOREIGN KEY (medicines_id) REFERENCES Medicines(id)
);
GO

CREATE TABLE Contraindications (
    id INT IDENTITY(1,1) PRIMARY KEY,
    patients_id INT,
    ingredients_id INT,
    CONSTRAINT fk_contraindications_patients
        FOREIGN KEY (patients_id) REFERENCES Patients(id),
    CONSTRAINT fk_contraindications_ingredients
        FOREIGN KEY (ingredients_id) REFERENCES Ingredients(id)
);
GO

CREATE TABLE Prescription (
    id INT IDENTITY(1,1) PRIMARY KEY,
    treatment_id INT,
    ingredients_id INT,
    CONSTRAINT fk_prescription_treatment
        FOREIGN KEY (treatment_id) REFERENCES Treatment(id),
    CONSTRAINT fk_prescription_ingredients
        FOREIGN KEY (ingredients_id) REFERENCES Ingredients(id)
);
GO