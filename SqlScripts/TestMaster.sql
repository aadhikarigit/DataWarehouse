
insert into  [DataWareHouse]..[TestMaster]

SELECT 
 ID AS _TestIDOrig
,TESTCODE AS TestCode
,Testname AS Testname
,'' AS Price
,'' AS TotalPrice
,Specimen AS Specimen
,Method AS Method
,Schedule AS Schedule
,Reporting AS Reporting
,Units AS Units
,IsOutGoingTest AS IsOutGoingTest
,SubGroupId AS SubGroupId
,SubGroupType AS SubGroupType
,IsCulture AS IsCulture
,u.usrFullName AS UserId
,EntryDate AS EntryDate
,IsActive AS TestIsActive
,TestType AS TestType
,'' AS _SubTestIDOrig
,'' AS TestSubType
,'' AS [Group]
,'' AS SubTestRange
,'' AS SubTestUnits
,'' AS SubTestIsActive
,'' AS ParentSubTestId
,'' AS IsHisto
,'' AS HistoTestName
,'' AS HistoTestType
,'' AS TestTitle
,'' AS TestParent
,'' AS DefaultResult
,'' AS IsDifferentialTest
FROM tbl_NRLTests T
LEFT JOIN tbl_appUsers U on T.UserId =  U.usruserid