-- =========================================
-- 06_sample_queries.sql
-- =========================================

USE placement_database;

-- 1. Students with CPI greater than average
SELECT Student_ID, CPI
FROM Student
WHERE CPI > (SELECT AVG(CPI) FROM Student);

-- 2. Company offering the highest package
SELECT c.Company_Name, j.Package
FROM Company c
JOIN Job_Posting j ON c.Company_ID=j.Company_ID
WHERE j.Package=(SELECT MAX(Package) FROM Job_Posting);

-- 3. Students who never applied for any job
SELECT u.User_ID,u.First_Name,u.Last_Name
FROM Users u
JOIN Student s ON u.User_ID=s.Student_ID
WHERE NOT EXISTS(
    SELECT 1 FROM Application a
    WHERE a.Student_ID=s.Student_ID
);

-- 4. Company with maximum job postings
SELECT c.Company_Name,COUNT(*) AS TotalJobs
FROM Company c
JOIN Job_Posting j ON c.Company_ID=j.Company_ID
GROUP BY c.Company_ID,c.Company_Name
ORDER BY TotalJobs DESC
LIMIT 1;

-- 5. Students who applied to Google
SELECT DISTINCT u.First_Name,u.Last_Name
FROM Users u
JOIN Student s ON u.User_ID=s.Student_ID
JOIN Application a ON s.Student_ID=a.Student_ID
JOIN Job_Posting j ON a.Job_ID=j.Job_ID
JOIN Company c ON j.Company_ID=c.Company_ID
WHERE c.Company_Name='Google';

-- 6. Applications per company
SELECT c.Company_Name,COUNT(*) AS TotalApplications
FROM Company c
JOIN Job_Posting j ON c.Company_ID=j.Company_ID
JOIN Application a ON j.Job_ID=a.Job_ID
GROUP BY c.Company_Name
ORDER BY TotalApplications DESC;

-- 7. Highest CPI student in each branch (correlated)
SELECT u.First_Name,u.Last_Name,b.Branch_Name,s.CPI
FROM Student s
JOIN Users u ON s.Student_ID=u.User_ID
JOIN Branch b ON s.Branch_ID=b.Branch_ID
WHERE s.CPI=(
SELECT MAX(s2.CPI)
FROM Student s2
WHERE s2.Branch_ID=s.Branch_ID);

-- 8. Students eligible for all jobs
SELECT Student_ID
FROM Student
WHERE CPI>=(SELECT MAX(Min_CPI) FROM Job_Eligibility);

-- 9. Companies with no placement drives
SELECT Company_Name
FROM Company c
WHERE NOT EXISTS(
SELECT 1 FROM Placement_Drive d
WHERE d.Company_ID=c.Company_ID);

-- 10. Branch with highest average CPI
SELECT b.Branch_Name,AVG(s.CPI) AvgCPI
FROM Student s
JOIN Branch b ON s.Branch_ID=b.Branch_ID
GROUP BY b.Branch_Name
ORDER BY AvgCPI DESC
LIMIT 1;

-- 11. Companies offering above-average package
SELECT c.Company_Name,j.Package
FROM Company c
JOIN Job_Posting j ON c.Company_ID=j.Company_ID
WHERE j.Package>(SELECT AVG(Package) FROM Job_Posting);

-- 12. Students who received offers
SELECT u.First_Name,u.Last_Name,c.Company_Name
FROM Users u
JOIN Student s ON u.User_ID=s.Student_ID
JOIN Application a ON s.Student_ID=a.Student_ID
JOIN Status st ON a.Status_ID=st.Status_ID
JOIN Job_Posting j ON a.Job_ID=j.Job_ID
JOIN Company c ON j.Company_ID=c.Company_ID
WHERE st.Status='Selected';

-- 13. Company-wise average package
SELECT c.Company_Name,AVG(j.Package) AvgPackage
FROM Company c
JOIN Job_Posting j ON c.Company_ID=j.Company_ID
GROUP BY c.Company_Name;

-- 14. Students with more than 3 applications
SELECT u.First_Name,u.Last_Name,COUNT(*) TotalApplications
FROM Users u
JOIN Student s ON u.User_ID=s.Student_ID
JOIN Application a ON s.Student_ID=a.Student_ID
GROUP BY u.User_ID,u.First_Name,u.Last_Name
HAVING COUNT(*)>3;

-- 15. Student with maximum applications
SELECT Student_ID,COUNT(*) TotalApplications
FROM Application
GROUP BY Student_ID
ORDER BY TotalApplications DESC
LIMIT 1;

-- 16. Students with CPI > 8 and no backlogs
SELECT u.First_Name,u.Last_Name
FROM Users u
JOIN Student s ON u.User_ID=s.Student_ID
WHERE s.CPI>8 AND s.Backlogs=0;

-- 17. Second highest package
SELECT DISTINCT Package
FROM Job_Posting
ORDER BY Package DESC
LIMIT 1 OFFSET 1;

-- 18. Companies offering multiple jobs
SELECT c.Company_Name,COUNT(*) Jobs
FROM Company c
JOIN Job_Posting j ON c.Company_ID=j.Company_ID
GROUP BY c.Company_Name
HAVING COUNT(*)>1;

-- 19. Students mentored by Software Engineers
SELECT su.First_Name,su.Last_Name
FROM Mentoring m
JOIN Alumni a ON m.Alumni_ID=a.Alumni_ID
JOIN Users su ON m.Student_ID=su.User_ID
WHERE a.Current_Status='Software Engineer';

-- 20. Branch-wise selected students
SELECT b.Branch_Name,COUNT(*) SelectedStudents
FROM Student s
JOIN Branch b ON s.Branch_ID=b.Branch_ID
JOIN Application a ON s.Student_ID=a.Student_ID
JOIN Status st ON a.Status_ID=st.Status_ID
WHERE st.Status='Selected'
GROUP BY b.Branch_Name;

-- 21. Jobs with minimum eligibility CPI
SELECT c.Company_Name,j.Job_Title
FROM Company c
JOIN Job_Posting j ON c.Company_ID=j.Company_ID
JOIN Job_Eligibility e ON j.Eligibility_ID=e.Eligibility_ID
WHERE e.Min_CPI=(SELECT MIN(Min_CPI) FROM Job_Eligibility);

-- 22. Students who applied to every company
SELECT a.Student_ID
FROM Application a
JOIN Job_Posting j ON a.Job_ID=j.Job_ID
GROUP BY a.Student_ID
HAVING COUNT(DISTINCT j.Company_ID)=(SELECT COUNT(*) FROM Company);

-- 23. Highest package in every company
SELECT c.Company_Name,MAX(j.Package) HighestPackage
FROM Company c
JOIN Job_Posting j ON c.Company_ID=j.Company_ID
GROUP BY c.Company_Name;

-- 24. Average selected package branch-wise
SELECT b.Branch_Name,AVG(j.Package) AvgPackage
FROM Student s
JOIN Branch b ON s.Branch_ID=b.Branch_ID
JOIN Application a ON s.Student_ID=a.Student_ID
JOIN Status st ON a.Status_ID=st.Status_ID
JOIN Job_Posting j ON a.Job_ID=j.Job_ID
WHERE st.Status='Selected'
GROUP BY b.Branch_Name;

-- 25. Students with all required documents
SELECT Student_ID
FROM Document
GROUP BY Student_ID
HAVING COUNT(DISTINCT Document_Name)>=2;

-- 26. Companies with above-average package
SELECT c.Company_Name,AVG(j.Package)
FROM Company c
JOIN Job_Posting j ON c.Company_ID=j.Company_ID
GROUP BY c.Company_Name
HAVING AVG(j.Package)>(SELECT AVG(Package) FROM Job_Posting);

-- 27. Rank companies by average package
SELECT c.Company_Name,
AVG(j.Package) AvgPackage,
DENSE_RANK() OVER(ORDER BY AVG(j.Package) DESC) CompanyRank
FROM Company c
JOIN Job_Posting j ON c.Company_ID=j.Company_ID
GROUP BY c.Company_Name;

-- 28. Top 5 students by CPI
SELECT u.First_Name,u.Last_Name,s.CPI
FROM Users u
JOIN Student s ON u.User_ID=s.Student_ID
ORDER BY s.CPI DESC
LIMIT 5;

-- 29. Companies where all jobs allow backlogs
SELECT DISTINCT c.Company_Name
FROM Company c
WHERE NOT EXISTS(
SELECT 1
FROM Job_Posting j
JOIN Job_Eligibility e ON j.Eligibility_ID=e.Eligibility_ID
WHERE j.Company_ID=c.Company_ID
AND e.Back_Allowed=FALSE);