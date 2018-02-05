INSERT INTO DataWareHouse..DiagnosisMaster

SELECT
  diag.Id		AS _DiagnosisIDOrig
, Diagnosis		AS DiagnosisName
, CASE WHEN PanelGroup.DiagnosisId IS NOT NULL THEN 1 ELSE 0 END AS IsPanel
, PanelGroup.Description AS PanelGroupName
, PType.TestType AS PanelType
, CASE WHEN ExcPanel.Id is not null then 1 else 0 end AS IsExecutive
, ExcPanel.GroupName AS ExecutiveGroupName
, TstRange.Min AS RangeMin
, TstRange.Max AS RangeMax
, Date AS OrigDate  -- change format
, Date AS RangeFromDate  -- change format
, cast('12/31/2300' as date) AS RangeToDate
FROM tbl_DiagnosisGroup Diag
LEFT JOIN tbl_Panel_ProfileGroup PanelGroup ON Diag.Id =  PanelGroup.DiagnosisId
LEFT JOIN tbl_Test_GroupType PType ON PanelGroup.TypeId	= PType.Id
LEFT JOIN tbl_ExecutiveTestGroup ExcTGrp ON PanelGroup.Id = ExcTGrp.Pan_GroupId
LEFT JOIN tbl_ExecutivePanel ExcPanel	ON ExcPanel.Id = ExcTGrp.ExecutiveGroupId
LEFT JOIN tbl_RangeOfTests TstRange ON TstRange.DGId = Diag.Id