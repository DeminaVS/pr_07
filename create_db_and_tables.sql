--Создайте таблицу medical_db и подключитесь к ней
--Создание таблицы Hospital
CREATE TABLE Hospital (
        Hospital_Id serial NOT NULL PRIMARY KEY,
        Hospital_Name VARCHAR (100) NOT NULL,
        Bed_Count serial
    );
--Вставка данных в таблицу

 INSERT INTO Hospital (Hospital_Id, Hospital_Name, Bed_Count)
    VALUES
    (1, 'Mayo Clinic', 200),
    (2, 'Cleveland Clinic', 400),
    (3, 'Johns Hopkins', 1000),
    (4, 'UCLA Medical Center', 1500);

--Создание таблицы Doctor

 CREATE TABLE IF NOT EXISTS Doctor (
        Doctor_Id VARCHAR(10) PRIMARY KEY,
        Doctor_Name VARCHAR(100) NOT NULL,
        Hospital_Id INT NOT NULL,
        Joining_Date DATE,
        Speciality VARCHAR(100),
        Salary INT,
        Experience INT,
        FOREIGN KEY (Hospital_Id) REFERENCES Hospital(Hospital_Id)
    );

-- Вставка данных о докторах
INSERT INTO Doctor (Doctor_Id, Doctor_Name, Hospital_Id, Joining_Date, Speciality, Salary, Experience)
VALUES
('101', 'David', '1', '2005-02-10', 'Pediatric', 40000, NULL),
('102', 'Michael', '1', '2018-07-23', 'Oncologist', 20000, NULL),
('103', 'Susan', '2', '2016-05-19', 'Garnacologist', 25000, NULL),
('104', 'Robert', '2', '2017-12-28', 'Pediatric', 28000, NULL),
('105', 'Linda', '3', '2004-06-04', 'Garnacologist', 42000, NULL),
('106', 'William', '3', '2012-09-11', 'Dermatologist', 30000, NULL),
('107', 'Richard', '4', '2014-08-21', 'Garnacologist', 32000, NULL),
('108', 'Karen', '4', '2011-10-17', 'Radiologist', 30000, NULL),
('109', 'James', '1', '2022-01-15', 'Cardiologist', 45000, 5),
('110', 'Emily', '1', '2023-04-10', 'Orthopedic Surgeon', 50000, 3),
('111', 'Olivia', '2', '2021-09-05', 'Neurologist', 42000, 4),
('112', 'John', '2', '2024-02-18', 'Surgeon', 60000, 2),
('113', 'Sophia', '3', '2022-07-30', 'Urologist', 38000, 6),
('114', 'Daniel', '3', '2025-03-22', 'Pulmonologist', 47000, 1),
('115', 'Isabella', '4', '2023-11-01', 'Pediatrician', 41000, 3),
('116', 'Liam', '4', '2022-05-25', 'Dermatologist', 35000, 4),
('117', 'Mia', '1', '2024-06-17', 'Gastroenterologist', 53000, 2),
('118', 'Lucas', '2', '2023-01-12', 'Anesthesiologist', 46000, 3);
--Задание 1. Создайте таблицу "Appointments" для хранения данных о приёмах.
 CREATE TABLE Appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date TIMESTAMP NOT NULL,
    diagnosis VARCHAR(255),
    treatment TEXT,
    status VARCHAR(50) DEFAULT 'scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id));
--Задание 2.Получите всех врачей, работающих в больнице с ID=2.
SELECT 
    d.doctor_id,
    d.doctor_name,
    d.speciality,
    d.salary,
    d.experience,
    TO_CHAR(d.joining_date, 'DD.MM.YYYY') AS joining_date_formatted
FROM 
    Doctor d
WHERE 
    d.hospital_id = 2
ORDER BY 
    d.doctor_name;
--Задание 3. Обновите информацию о докторе с ID=103 (измените его зарплату).
UPDATE Doctor
SET 
    salary = 32000,
    experience = EXTRACT(YEAR FROM AGE(CURRENT_DATE, joining_date))
WHERE 
    doctor_id = 103;
SELECT * FROM Doctor WHERE doctor_id = 103;
--Задание 4.Получите все записи из таблицы "Doctor" с опытом работы более 5 лет.
SELECT *
FROM Doctor
WHERE experience > 5;
--Задание 5.Визуализируйте распределение врачей по специальностям.
SELECT doctor.speciality, COUNT(*) as count 
        FROM Doctor 
        GROUP BY doctor.speciality
        ORDER BY count DESC