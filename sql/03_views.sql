-- =========================================
-- Useful SQL Views
-- =========================================

USE placement_database;

CREATE VIEW Student_Profile AS
SELECT
    s.Student_ID,
    u.First_Name,
    u.Last_Name,
    u.Email,
    b.Branch_Name,
    p.Programme_Name,
    s.Year_Of_Study,
    s.CPI,
    s.Backlogs
FROM Student s
JOIN Users u ON s.Student_ID = u.User_ID
JOIN Branch b ON s.Branch_ID = b.Branch_ID
JOIN Programme p ON b.Programme_ID = p.Programme_ID;

CREATE VIEW Company_Jobs AS
SELECT
    c.Company_Name,
    j.Job_ID,
    j.Job_Title,
    j.Package,
    j.Application_Deadline
FROM Company c
JOIN Job_Posting j ON c.Company_ID = j.Company_ID;

CREATE VIEW Student_Applications AS
SELECT
    u.First_Name,
    u.Last_Name,
    c.Company_Name,
    j.Job_Title,
    st.Status,
    a.Date_Applied
FROM Application a
JOIN Student s ON a.Student_ID = s.Student_ID
JOIN Users u ON s.Student_ID = u.User_ID
JOIN Job_Posting j ON a.Job_ID = j.Job_ID
JOIN Company c ON j.Company_ID = c.Company_ID
JOIN Status st ON a.Status_ID = st.Status_ID;

CREATE VIEW Placement_Drive_Details AS
SELECT
    d.Drive_ID,
    c.Company_Name,
    d.Date,
    d.Time,
    d.Venue
FROM Placement_Drive d
JOIN Company c ON d.Company_ID = c.Company_ID;

CREATE VIEW Alumni_Mentoring AS
SELECT
    m.Mentoring_ID,
    su.First_Name AS Student_Name,
    au.First_Name AS Alumni_Name,
    m.Session_Date,
    m.Topic,
    m.Feedback
FROM Mentoring m
JOIN Users su ON m.Student_ID = su.User_ID
JOIN Users au ON m.Alumni_ID = au.User_ID;

CREATE VIEW Eligible_Jobs AS
SELECT
    j.Job_ID,
    c.Company_Name,
    j.Job_Title,
    e.Min_CPI,
    e.Back_Allowed
FROM Job_Posting j
JOIN Company c ON j.Company_ID = c.Company_ID
JOIN Job_Eligibility e ON j.Eligibility_ID = e.Eligibility_ID;

CREATE VIEW Student_Documents AS
SELECT
    u.First_Name,
    u.Last_Name,
    d.Document_Name,
    d.Document_Type
FROM Document d
JOIN Users u ON d.Student_ID = u.User_ID;

CREATE VIEW Company_Drive_Count AS
SELECT
    c.Company_Name,
    COUNT(d.Drive_ID) AS Total_Drives
FROM Company c
LEFT JOIN Placement_Drive d ON c.Company_ID = d.Company_ID
GROUP BY c.Company_ID, c.Company_Name;

CREATE VIEW Application_Statistics AS
SELECT
    st.Status,
    COUNT(*) AS Total_Applications
FROM Application a
JOIN Status st ON a.Status_ID = st.Status_ID
GROUP BY st.Status;

CREATE VIEW Student_Placement_Summary AS
SELECT
    u.First_Name,
    u.Last_Name,
    COUNT(a.App_ID) AS Applications_Submitted,
    SUM(CASE WHEN st.Status='Selected' THEN 1 ELSE 0 END) AS Offers_Received
FROM Student s
JOIN Users u ON s.Student_ID = u.User_ID
LEFT JOIN Application a ON s.Student_ID = a.Student_ID
LEFT JOIN Status st ON a.Status_ID = st.Status_ID
GROUP BY s.Student_ID, u.First_Name, u.Last_Name;
