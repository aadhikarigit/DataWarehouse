USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncDiagnosisMaster]    Script Date: 7/11/2019 6:08:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--NRLBAN.Carelab_Ktm_104.

--EXEC Sync.syncDiagnosisMaster

ALTER Proc [Sync].[syncDiagnosisMaster]
	@fiscalyear varchar(10) = '2075-76'
AS
BEGIN
	MERGE dbo.DiagnosisMaster AS target
	USING 
	(
		SELECT
			 diag.Id		AS _DiagnosisIDOrig
			,Diagnosis		AS DiagnosisName
			,getdate() as CreateTs
			,getdate() as UpdateTs
		FROM NRLBAN.Carelab_Ktm_104.dbo.tbl_DiagnosisGroup Diag
		where Diag.Issync = 0
	) as source
	on target._DiagnosisIDOrig = source._DiagnosisIDOrig
	and target.fiscalyear = @fiscalyear
	when matched
	AND target.DiagnosisName     <> source.DiagnosisName     
     
	THEN
	
	UPDATE
	SET
		target.DiagnosisName  = source.DiagnosisName
		,target.Updatets		= source.UpdateTs
		,target.Issync = 0
	 
	 WHEN NOT matched THEN
	 INSERT (_DiagnosisIDOrig,DiagnosisName,CreateTs,UpdateTs,fiscalyear)
	 VALUES (
  source._DiagnosisIDOrig
 ,source.DiagnosisName
 ,getdate()
 ,getdate()
 ,@fiscalyear);
		 
END
