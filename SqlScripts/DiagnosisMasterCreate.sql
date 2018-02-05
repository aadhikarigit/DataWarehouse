CREATE TABLE DiagnosisMaster
(
ID INT IDENTITY(1,1)
,_DiagnosisIDOrig VARCHAR(255) 
,DiagnosisName VARCHAR(255) 
,IsPanel VARCHAR(255) 
,PanelGroupName VARCHAR(255) 
,PanelType VARCHAR(255) 
,IsExecutive VARCHAR(255) 
,ExecutiveGroupName VARCHAR(255) 
,RangeMin VARCHAR(255) 
,RangeMax VARCHAR(255) 
,OrigDate DATETIME
,RangeFromDate DATETIME
,RangeToDate DATEtIME
)