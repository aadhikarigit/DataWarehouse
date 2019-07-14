USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[syncTestMaster]    Script Date: 7/11/2019 5:23:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--NRLBAN.Carelab_ktm_CloudSyncTest.
--EXEC Sync.syncTestMaster
--select * from [DataWareHouse].dbo.[TestMaster_Ban]
ALTER proc [Sync].[syncTestMaster]
	@fiscalyear varchar(10) = '2075-76'
as
begin
	Merge dbo.[TestMaster] as target
	using (
		SELECT 
		 T.ID AS _TestIDOrig
		,T.TESTCODE AS TestCode
		,T.Testname AS Testname
		,ISnull(T.Price,0) AS Price
		,ISnull(T.TotalPrice, 0) AS TotalPrice
		,T.Specimen AS Specimen
		,T.Method AS Method
		,T.Schedule AS Schedule
		,T.Reporting AS Reporting
		,T.Units AS Units
		,T.IsOutGoingTest AS IsOutGoingTest
		,T.SubGroupId AS SubGroupId
		,ISNULL(T.SubGroupType,'') AS SubGroupType
		,T.IsCulture AS IsCulture
		,u.usrFullName AS EnteredBy
		,T.EntryDate AS EntryDate
		,T.IsActive AS TestIsActive
		,isnull(T.TestType,'') AS TestType
		,'0' AS IsHisto
		,'0' AS IsDifferentialTest
		,getdate() as CreateTs
		,getdate() as UpdateTs
		FROM NRLBAN.Carelab_Ktm_104.dbo.tbl_NRLTests T
		LEFT JOIN NRLBAN.Carelab_Ktm_104.dbo.tbl_appUsers U on T.UserId =  U.usruserid 
		WHERE T.Issync = 0
	) as source
	on target._TestIDOrig = source._TestIDOrig 
	AND target.TestCode  = source.TestCode
	and target.fiscalyear = @fiscalyear
	when matched
	then
	update set  
	  --target.TestCode           = source.TestCode
	 target.Testname           = source.Testname
	 ,target.Price              = source.Price
	 ,target.TotalPrice         = source.TotalPrice
	 ,target.Specimen           = source.Specimen
	 ,target.Method             = source.Method
	 ,target.Schedule           = source.Schedule
	 ,target.Reporting          = source.Reporting
	 ,target.Units              = source.Units
	 ,target.IsOutGoingTest     = source.IsOutGoingTest
	 ,target.SubGroupId         = source.SubGroupId
	 ,target.SubGroupType       = source.SubGroupType
	 ,target.IsCulture          = source.IsCulture
	 ,target.EnteredBy          = source.EnteredBy
	 ,target.EntryDate          = source.EntryDate
	 ,target.TestIsActive       = source.TestIsActive
	 ,target.TestType           = source.TestType
	 ,target.IsHisto            = source.IsHisto
	 ,target.IsDifferentialTest = source.IsDifferentialTest
	 ,target.UpdateTs			= getdate()
	 ,target.Issync				= 0
	 --,target.fiscalyear			= @fiscalyear

	when not matched then
	insert
	values(
		 source._TestIDOrig
		,source.TestCode
		,source.Testname
		,source.Price
		,source.TotalPrice
		,source.Specimen
		,source.Method
		,source.Schedule
		,source.Reporting
		,source.Units
		,source.IsOutGoingTest
		,source.SubGroupId
		,source.SubGroupType
		,source.IsCulture
		,source.EnteredBy
		,source.EntryDate
		,source.TestIsActive
		,source.TestType
		,source.IsHisto
		,source.IsDifferentialTest
		,0
		,getdate()
		,getdate()
		,@fiscalyear
	);
end
