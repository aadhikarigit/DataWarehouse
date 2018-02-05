INSERT INTO DataWareHouse..TestMaster
SELECT DISTINCT
 
 tests.id				 AS _TestIDOrig
,tests.TestCode			 AS TestCode
,tests.Testname			 AS Testname
,tests.Price			 AS Price
,tests.TotalPrice		 AS TotalPrice
,tests.Specimen			 AS Specimen
,tests.Method			 AS Method
,tests.Schedule			 AS Schedule
,tests.Reporting		 AS Reporting
,tests.Units			 AS Units
,tests.IsOutGoingTest	 AS IsOutGoingTest
,tests.SubGroupId		 AS SubGroupId
,tests.SubGroupType		 AS SubGroupType
,tests.IsCulture		 AS IsCulture
,tests.UserId			 AS UserId
,tests.EntryDate		 AS EntryDate
,tests.IsActive			 AS TestIsActive
,tests.TestType			 AS TestType
,Stests.Id AS _SubTestIDOrig
,Stests.TestSubType AS TestSubType
,Stests.[Group] AS [Group]
,Stests.SubTestRange AS SubTestRange
,Stests.SubTestUnits AS SubTestUnits
,Stests.IsActive AS SubTestIsActive
,Stests.SubTestId AS ParentSubTestId
,0 AS IsHisto
,NULL AS HistoTestName
,NULL AS HistoTestType
,NULL AS TestTitle
,NULL AS TestParent
,NULL AS DefaultResult
,NULL AS IsDifferentialTest
FROM tbl_NRLTests Tests
LEFT JOIN tbl_SubTests Stests ON Tests.ID = Stests.TestId

UNION ALL

SELECT DISTINCT
 Histo.ID AS _TestIDOrig
,HIsto.HistoTestName AS TestCode
,Histo.HistoTestName AS Testname
,Histo.Price AS Price
,Histo.Price AS TotalPrice
,Histo.Specimen AS Specimen
,Histo.Method AS Method
,NULL AS Schedule
,NULL AS Reporting
,Histo.Units AS Units
,NULL AS IsOutGoingTest
,NULL AS SubGroupId
,NULL AS SubGroupType
,NULL AS IsCulture
,NULL AS UserId
,NULL AS EntryDate
,NULL AS TestIsActive
,NULL AS TestType
,NULL AS _SubTestIDOrig
,NULL AS TestSubType
,NULL AS [Group]
,NULL AS SubTestRange
,NULL AS SubTestUnits
,NULL AS SubTestIsActive
,NULL AS ParentSubTestId
,1 AS IsHisto
,Histo.HistoTestName AS HistoTestName
,HstTyp.HistoType AS HistoTestType
,HstLkp.TestTitle AS TestTitle
,HstLkp.TestParent AS TestParent
,HstLkp.DefaultResult AS DefaultResult
,NULL AS IsDifferentialTest
FROM tbl_NRLHistoTests Histo
LEFT JOIN tbl_HistoTestType HstTyp ON HstTyp.Id = Histo.HistoGroupTypeId
LEFT JOIN tbl_HistoReportTypeLookUp HstLkp	ON HstLkp.HistoId = Histo.id
