
CREATE DATABASE IF NOT EXISTS placement_database;
USE placement_database;

CREATE TABLE Users (
    User_ID INT NOT NULL,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Role ENUM('Student','Alumni','Admin','Recruiter') NOT NULL,
    PRIMARY KEY (User_ID)
);

CREATE TABLE Phone_No (
    Phone_No VARCHAR(15) NOT NULL,
    User_ID INT NOT NULL,
    PRIMARY KEY (Phone_No),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Programme (
    Programme_ID INT NOT NULL,
    Programme_Name VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (Programme_ID)
);

CREATE TABLE Branch (
    Branch_ID INT NOT NULL,
    Branch_Name VARCHAR(100) NOT NULL,
    Programme_ID INT NOT NULL,
    PRIMARY KEY (Branch_ID),
    FOREIGN KEY (Programme_ID) REFERENCES Programme(Programme_ID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE Student (
    Student_ID INT NOT NULL,
    Branch_ID INT NOT NULL,
    Year_Of_Study INT NOT NULL CHECK (Year_Of_Study BETWEEN 1 AND 5),
    CPI DECIMAL(3,2) NOT NULL CHECK (CPI BETWEEN 0 AND 10),
    Date_Of_Birth DATE NOT NULL,
    Backlogs INT NOT NULL DEFAULT 0 CHECK (Backlogs>=0),
    PRIMARY KEY (Student_ID),
    FOREIGN KEY (Student_ID) REFERENCES Users(User_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Document (
    Student_ID INT NOT NULL,
    Document_Name VARCHAR(100) NOT NULL,
    Document_Type VARCHAR(50) NOT NULL,
    PRIMARY KEY (Student_ID, Document_Name),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Company (
    Company_ID INT NOT NULL,
    Company_Name VARCHAR(150) NOT NULL,
    Industry_Type VARCHAR(100),
    Description TEXT,
    Company_Email VARCHAR(100) UNIQUE,
    PRIMARY KEY (Company_ID)
);

CREATE TABLE Placement_Drive (
    Drive_ID INT NOT NULL,
    Company_ID INT NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    Venue VARCHAR(150) NOT NULL,
    PRIMARY KEY (Drive_ID),
    FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Job_Eligibility (
    Eligibility_ID INT NOT NULL,
    Min_CPI DECIMAL(3,2) NOT NULL CHECK (Min_CPI BETWEEN 0 AND 10),
    Back_Allowed BOOLEAN NOT NULL,
    PRIMARY KEY (Eligibility_ID)
);

CREATE TABLE Programme_Allowed (
    Eligibility_ID INT NOT NULL,
    Programme_ID INT NOT NULL,
    PRIMARY KEY (Eligibility_ID, Programme_ID),
    FOREIGN KEY (Eligibility_ID) REFERENCES Job_Eligibility(Eligibility_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Programme_ID) REFERENCES Programme(Programme_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Branch_Allowed (
    Eligibility_ID INT NOT NULL,
    Branch_ID INT NOT NULL,
    PRIMARY KEY (Eligibility_ID, Branch_ID),
    FOREIGN KEY (Eligibility_ID) REFERENCES Job_Eligibility(Eligibility_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Job_Posting (
    Job_ID INT NOT NULL,
    Company_ID INT NOT NULL,
    Eligibility_ID INT NOT NULL,
    Job_Title VARCHAR(150) NOT NULL,
    Job_Description TEXT,
    Package DECIMAL(10,2) NOT NULL,
    Application_Deadline DATE NOT NULL,
    PRIMARY KEY (Job_ID),
    FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Eligibility_ID) REFERENCES Job_Eligibility(Eligibility_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Status (
    Status_ID INT NOT NULL,
    Status VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (Status_ID)
);

CREATE TABLE Application (
    App_ID INT NOT NULL,
    Student_ID INT NOT NULL,
    Job_ID INT NOT NULL,
    Status_ID INT NOT NULL,
    Date_Applied DATE NOT NULL,
    Last_Updated DATE,
    PRIMARY KEY (App_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Job_ID) REFERENCES Job_Posting(Job_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Status_ID) REFERENCES Status(Status_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Alumni (
    Alumni_ID INT NOT NULL,
    Graduate_Year YEAR NOT NULL,
    Current_Status VARCHAR(100) NOT NULL,
    PRIMARY KEY (Alumni_ID),
    FOREIGN KEY (Alumni_ID) REFERENCES Users(User_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Mentoring (
    Mentoring_ID INT NOT NULL,
    Student_ID INT NOT NULL,
    Alumni_ID INT NOT NULL,
    Session_Date DATE NOT NULL,
    Topic VARCHAR(150) NOT NULL,
    Feedback TEXT,
    PRIMARY KEY (Mentoring_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Alumni_ID) REFERENCES Alumni(Alumni_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);