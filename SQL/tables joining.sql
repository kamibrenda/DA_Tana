SELECT 
emp.firstName as employee_name,
emp.lastName AS employee_lastname, 
emp_.firstName AS reports_to_firstname,
emp_.lastName as reports_to_firstname
FROM 
employees emp
LEFT JOIN employees emp_
ON emp.reportsTo = emp_.employeeNumber
;