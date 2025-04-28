# pr_07
# Практическая работа 7. Импорт и экспорт данных в SQL. Работа с внешними источниками данных
Цель: научиться импортировать и экспортировать данные в базу данных SQL. Работа включает в себя загрузку данных из внешних источников в таблицы базы данных, а также экспорт данных из базы данных в различные форматы. Студенты научатся работать с внешними данными, преобразовывать их в нужный формат и интегрировать с существующими таблицами в базе данных.
# Задачи:
1. Создание ERD диаграммы для базы данных.
2. Разработка SQL-скриптов для создания базы данных и таблиц.
3. Реализация заданий в Jupyter Notebook с подключением к базе данных, вставкой и обновлением данных, а также визуализацией информации.
# Выполнение работы
Перед тем как приступить к выполнению задания, установим библиотеку psycopg2 для дальнейшей работы:

````
%pip install psycopg2
````

Теперь импортируем библиотеку psycopg2 для работы с PostgreSQL и класс Error для обработки ошибок при подключении к базе данных.
````
import psycopg2 from psycopg2 import Error
````
# Подключимся к серверу базы данных, создадим базу данных medical_db и таблицу Hospital
```
import psycopg2
def get_connection(database_name):
    # Функция для получения подключения к базе данных
    connection = psycopg2.connect(user="postgres",
                                  password="1",
                                  host="localhost",
                                  port="5432",
                                  database=database_name)
    return connection

def close_connection(connection):
    # Функция для закрытия подключения к базе данных
    if connection:
        connection.close()
        print("Соединение с PostgreSQL закрыто")

try:
    # Создание подключения к базе данных sql_case_bi_mgpu (база, с которой можно создавать другие базы)
    connection = psycopg2.connect(user="postgres",
                                  password="1",
                                  host="localhost",
                                  port="5432",
                                  database="bd")
    connection.autocommit = True  # Отключаем транзакцию для команды CREATE DATABASE
    cursor = connection.cursor()

    # Создание базы данных
    cursor.execute("CREATE DATABASE medical_db;")
    print("База данных 'medical_db' успешно создана")

    # Закрытие текущего соединения для подключения к новой базе данных
    close_connection(connection)

    # Подключение к новой базе данных 'medical_db'
    connection = get_connection("medical_db")
    cursor = connection.cursor()

    # Создание таблицы Hospital
    create_table_query = '''
    CREATE TABLE Hospital (
        Hospital_Id serial NOT NULL PRIMARY KEY,
        Hospital_Name VARCHAR (100) NOT NULL,
        Bed_Count serial
    );
    '''
    cursor.execute(create_table_query)
    connection.commit()
    print("Таблица 'Hospital' успешно создана")

    # Вставка данных в таблицу Hospital
    insert_query = '''
    INSERT INTO Hospital (Hospital_Id, Hospital_Name, Bed_Count)
    VALUES
    (1, 'Mayo Clinic', 200),
    (2, 'Cleveland Clinic', 400),
    (3, 'Johns Hopkins', 1000),
    (4, 'UCLA Medical Center', 1500);
    '''
    cursor.execute(insert_query)
    connection.commit()
    print("Данные успешно вставлены в таблицу 'Hospital'")

except (Exception, psycopg2.Error) as error:
    print("Ошибка при подключении или работе с PostgreSQL:", error)

finally:
    # Закрытие подключения к базе данных
    if connection:
        close_connection(connection)
````

# Создадим таблицу Doctor и заполним эту таблицу данными в Postgre SQL
````
CREATE TABLE Doctor (
    Doctor_Id serial NOT NULL PRIMARY KEY,
    Doctor_Name VARCHAR (100) NOT NULL,
    Hospital_Id serial NOT NULL,
    Joining_Date DATE NOT NULL,
    Speciality VARCHAR (100) NOT NULL,
    Salary INTEGER NOT NULL,
    Experience SMALLINT
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
````
# Индивидуальные задания. Вариант 9
Задание 1. Создайте таблицу "Appointments" для хранения данных о приёмах.
````
import psycopg2

def get_connection(database_name):
    # Функция для получения подключения к базе данных
    connection = psycopg2.connect(user="postgres",
                                  password="1",
                                  host="localhost",
                                  port="5432",
                                  database=database_name)
    return connection

def close_connection(connection):
    # Функция для закрытия подключения к базе данных
    if connection:
        connection.close()
        print("Соединение с PostgreSQL закрыто")

try:
    # Подключение к базе данных 'medical_db'
    connection = get_connection("medical_db")
    cursor = connection.cursor()

    # Создание таблицы Appointments
    create_table_query = '''
       CREATE TABLE IF NOT EXISTS Appointments (
            appointment_id SERIAL PRIMARY KEY,
            patient_id INT NOT NULL,
            doctor_id INT NOT NULL,
            appointment_date TIMESTAMP NOT NULL,
            diagnosis TEXT,
            treatment TEXT,
            FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
        );
    '''
    cursor.execute(create_table_query)
    connection.commit()
    print("Таблица 'Appontments' успешно создана")

except (Exception, psycopg2.Error) as error:
    print("Ошибка при подключении или работе с PostgreSQL:", error)

finally:
    # Закрытие подключения к базе данных
    if connection:
        close_connection(connection)
````
Выполняем написанный код и получаем успешно созданную таблицу.
![image](https://github.com/user-attachments/assets/bbfcc880-137f-468e-aeec-0b4122e478c0)

Задание 2. Получите всех врачей, работающих в больнице с ID=2.
Составляем запрос на вывод врачей с Hospital_ID=2
````
import psycopg2

def get_connection(database_name):
    connection = psycopg2.connect(user="postgres",
                                  password="1",
                                  host="localhost",
                                  port="5432",
                                  database=database_name)
    return connection

def close_connection(connection):
    if connection:
        connection.close()
        print("Соединение с PostgreSQL закрыто")

def get_hospital_2_doctors():
    try:
       
        connection = psycopg2.connect(user="postgres",
                                      password="1",
                                      host="localhost",
                                      port="5432",
                                      database="medical_db"
                                    )
        cursor = connection.cursor()

        # Выбираем врачей из больницы, у которой ID = 2
        select_query = '''
        SELECT * FROM Doctor
        WHERE Hospital_Id = 2;
        '''
        
        cursor.execute(select_query)
        doctors = cursor.fetchall()

        
        print("\nВрачи из больницы с ID 2")
        print("-" * 50)
        for doctor in doctors:
           print(f"ID: {doctor[0]}")
           print(f"Имя: {doctor[1]}")
           print(f"Больница ID: {doctor[2]}")
           print(f"Дата приема: {doctor[3]}")
           print(f"Специальность: {doctor[4]}")
           print(f"Зарплата: ${doctor[5]}")
           print(f"Опыт: {doctor[6] or 'Не указан'} лет")
           print("-" * 50)
        return doctors

    except psycopg2.Error as error:
        print("Ошибка при работе с PostgreSQL:", error)
    finally:
        
        if connection:
            cursor.close()
            connection.close()
            print("\nСоединение с PostgreSQL закрыто")

get_hospital_2_doctors()
````
Получаем ответ на наш запрос
![image](https://github.com/user-attachments/assets/1a840f45-0a47-445f-9b72-8c6ef0e9f99e)

Задание 3. Обновите информацию о докторе с ID=103 (измените его зарплату).
````
import psycopg2

def get_connection(database_name):
    # Функция для получения подключения к базе данных
    connection = psycopg2.connect(user="postgres",
                                  password="1",
                                  host="localhost",
                                  port="5432",
                                  database=database_name)
    return connection

def close_connection(connection):
    # Функция для закрытия подключения к базе данных
    if connection:
        connection.close()
        print("Соединение с PostgreSQL закрыто")

def update_salary(doctor_id, new_salary):
    try:
        # Подключаемся к базе данных
        database_name = 'medical_db'
        connection = get_connection(database_name)
        cursor = connection.cursor()

        # Обновляем зарплату доктора с указанным ID
        update_query = """UPDATE Doctor SET Salary = %s WHERE Doctor_Id = %s"""
        cursor.execute(update_query, (new_salary, doctor_id))
        connection.commit()

        print(f"Зарплата врача с ID {doctor_id} успешно обновлена на {new_salary}")

        # Печать данных о докторе после обновления
        select_query = """SELECT Doctor_Id, Doctor_Name, Hospital_Id, Joining_Date, Speciality, Salary, Experience
                          FROM Doctor WHERE Doctor_Id = %s"""
        cursor.execute(select_query, (doctor_id,))
        doctor_record = cursor.fetchone()

        if doctor_record:
            print("\nИнформация о докторе после обновления:")
            print(f"ID: {doctor_record[0]}")
            print(f"Имя: {doctor_record[1]}")
            print(f"Больница ID: {doctor_record[2]}")
            print(f"Дата приема: {doctor_record[3]}")
            print(f"Специальность: {doctor_record[4]}")
            print(f"Зарплата: {doctor_record[5]}")
            print(f"Опыт: {doctor_record[6]}")

        # Закрытие подключения
        close_connection(connection)

    except (Exception, psycopg2.Error) as error:
        print("Ошибка при обновлении данных:", error)

# Обновим стаж врача с ID 101 на 3 года
print("Задание: Обновить зарплату врачу с ID 103\n")
update_salary(103, 30000)
````
Получаем необходимый результат
![image](https://github.com/user-attachments/assets/ae1839d0-45b0-4c04-8356-569d0987083d)

Задание 4. Получите все записи из таблицы "Doctor" с опытом работы более 5 лет.
Составляем запрос на вывод всех врачей, у которых опыт больше 5.
````
import psycopg2

def get_connection(database_name):
    connection = psycopg2.connect(user="postgres",
                                  password="1",
                                  host="localhost",
                                  port="5432",
                                  database=database_name)
    return connection

def close_connection(connection):
    if connection:
        connection.close()
        print("Соединение с PostgreSQL закрыто")

def get_doctors_with_experience():
    try:
        database_name = 'medical_db'
        connection = get_connection(database_name)
        cursor = connection.cursor()

        # Пишем SQL-запрос для получения врачей, у которых зарплата больше 30000
        select_query = """
        SELECT * FROM Doctor 
        WHERE Experience > 5
        """
        cursor.execute(select_query)
        records = cursor.fetchall()

        # Проверяем и выводим результаты
        print("\nСписок врачей с опытом более 5 лет:\n")
        if records:
            for row in records:
                print("ID врача:", row[0])
                print("Имя врача:", row[1])
                print("ID больницы:", row[2])
                print("Дата начала работы:", row[3])
                print("Специальность:", row[4])
                print("Зарплата:", row[5])
                print("Опыт:", row[6], "\n")
        else:
            print("Врачи с опытом более 5 лет не найдены.")

        close_connection(connection)
    except (Exception, psycopg2.Error) as error:
        print("Ошибка при получении данных:", error)

print("Задание. Получение списка врачей с опытом более 5 лет.\n")
get_doctors_with_experience()
````
Получаем необходимый результат
![image](https://github.com/user-attachments/assets/7c5fa95c-045e-4b6b-b4dc-2a5178af4efb)
Задание 5.Визуализируйте распределение врачей по специальностям.
Визуализируем распределение врачей по специальностям с помощью matplotlib.
````
import psycopg2
import matplotlib.pyplot as plt

def get_connection(database_name):
    connection = psycopg2.connect(user="postgres",
                                  password="1",
                                  host="localhost",
                                  port="5432",
                                  database=database_name)
    return connection

def close_connection(connection):
    if connection:
        connection.close()
        print("Соединение с PostgreSQL закрыто")

def visualize_doctors_by_specialty():
    try:
        database_name = 'medical_db'
        connection = get_connection(database_name)
        cursor = connection.cursor()

        # SQL-запрос для получения количества врачей по специальностям
        select_query = """
        SELECT doctor.speciality, COUNT(*) as count 
        FROM Doctor 
        GROUP BY doctor.speciality
        ORDER BY count DESC
        """
        cursor.execute(select_query)
        records = cursor.fetchall()

        # Проверяем и выводим результаты
        print("\nРаспределение врачей по специальностям:\n")
        if records:
            specialties = []
            counts = []
            
            for row in records:
                specialties.append(row[0])
                counts.append(row[1])
                print(f"{row[0]}: {row[1]} врачей")

            # Создаем визуализацию
            plt.figure(figsize=(10, 6))
            plt.bar(specialties, counts, color='skyblue')
            plt.title('Распределение врачей по специальностям')
            plt.xlabel('Специальность')
            plt.ylabel('Количество врачей')
            plt.xticks(rotation=45, ha='right')
            plt.tight_layout()
            
            # Сохраняем график в файл
            plt.savefig('doctors_by_specialty.png')
            print("\nГрафик сохранен как 'doctors_by_specialty.png'")
            
            # Показываем график
            plt.show()
        else:
            print("Данные о врачах не найдены.")

        close_connection(connection)
    except (Exception, psycopg2.Error) as error:
        print("Ошибка при получении данных:", error)

print("Задание. Визуализация распределения врачей по специальностям.\n")
visualize_doctors_by_specialty()
````
Получим результат с графиком
![image](https://github.com/user-attachments/assets/aa59d38b-4462-4966-a71f-ac5b4d079d5d)

# Вывод
в ходе данной работы мы научились импортировать и экспортировать данные в базу данных SQL, научились работать с внешними данными, преобразовывать их в нужный формат и интегрировать с существующими таблицами в базе данных.
# Структура репозитория
erd_diagram.png — ERD диаграмма схемы базы данных.

create_db_and_tables.sql — SQL скрипт для создания базы данных и таблиц.

Demina_Valeria_Sergeevna.ipynb — Jupyter Notebook с выполнением всех заданий.
# Как запустить
1. Установите PostgreSQL и настройте доступ к базе данных.
2. Выполните SQL-скрипт create_db_and_tables.sql для создания базы данных и таблиц.
3. Откройте и выполните Jupyter Notebook для проверки выполнения заданий.
