USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[SyncFactPatientDiagnosis]    Script Date: 7/11/2019 6:43:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--NRLMAH.CareLab_Current.
--EXEC Sync.SyncFactPatientDiagnosis
/*
select * from 
dbo.Int_PatientReportDetails
where PatId in 
(5218
,5519
,4591) and _OrigDiagID in (9,2) and _OrigTestID in (318,320,26) and SubTest in ('Motility ','')
order by PatId
   
,_OrigDiagID 
,_OrigTestID      
,SubTest 
select PatientId
,BillID      
,DiagnosisID 
,TestID      
,SubTest 
,count(*)
from  dbo.FactPatientDiagnosis
group by PatientId
,BillID      
,DiagnosisID 
,TestID      
,SubTest
having count(*) >1
*/
ALTER proc [Sync].[SyncFactPatientDiagnosis]
	@fiscalyear varchar(10) = '2075-76'
as
begin

	create table #tempfactpatient(PatId INT DEFAULT 0 );

	BEGIN TRANSACTION
		BEGIN TRY
			Insert into #tempfactpatient
			select distinct ipbr.PatId from dbo.Int_PatientBillReport ipbr;

					Merge dbo.FactPatientDiagnosis as target
					using (
					select distinct  ipbr.MemberCode
							,ipbr.PatId as _PatientID
							,pm.ContactNo as MobileNo
							,ipbr.BillId as BillID
							,SpecialistId as CheckedByFirstID
							,SecondSpecialistId as CheckedBySecondID
							,DiagId as DiagnosisID
							,TestID as TestID
							,iprd._OrigPanelId
							,iprd.PanelId
							,iprd.TestMethod as Method
							,TestRange as Range
							,TestResult as Result
							,TestPrice as Price
							,iprd.Note as Remarks
							,'' as AttachmentLink
							,getdate() as CreateTs
							,getdate() as UpdateTs
							,isnull(iprd.SubTestId,0) as SubTestId
							,isnull(iprd._OrigSubTestId,0) as _OrigSubTestId
							,iprd.SubTest
							,iprd.SubTestRange
							,iprd.SubTestUnits
							,iprd.SubTestActive
							,iprd.SubTestResult
							,iprd.Note
							,iprd.SubMethod
							,ipbr.ResultDate
							,ipbr.ReportDate
							--,case when ipbr.IsDone = 'Y' then 1 else 0 end as IsReportDone
							,ipbr.IsDone as IsReportDone
							--,case when iprd.IsExecutive = 'Y' then 1 else 0 end as IsExecutive
							,iprd.IsExecutive
							--,case when ipbr.IsReportTaken = 'Y' then 1 else 0 end as IsReportTaken
							,ipbr.IsReportTaken
							--,case when ipbr.IsPartiallyDone = 'Y' then 1 else 0 end as IsPartiallyDone
							,ipbr.IsPartiallyDone
							,iprd.SyncStatus
							,iprd.TestRecordId
							,iprd.IsHideOnPrint
					from dbo.Int_PatientBillReport ipbr
					 join dbo.Int_PatientReportDetails iprd on iprd.PatId=ipbr.PatId --and iprd.ReportDate=ipbr.ReportDate
					 join dbo.PatientMaster pm on pm.ID=ipbr.PatId
					 where ipbr.IsSync = 0 --and ipbr.IsFactLoaded=0 and iprd.IsFactLoaded=0
					 --where ipbr.PatId not in (5218,5519,4591)
					) as source
					on target.PatientID				  = source._PatientID
						and target.BillID             = source.BillID
						and target.DiagnosisID        = source.DiagnosisID
						and target.TestID             = source.TestID
						and target._OrigSubTestId     = source._OrigSubTestId
						and target.PanelId			  = source.PanelId
						and target.fiscalyear = @fiscalyear

						when matched 
					--	and
					--(
					--	   target.MemberCode		 <> source.MemberCode  
					--	OR target.MobileNo           <> source.MobileNo
					--	OR target.CheckedByFirstID   <> source.CheckedByFirstID
					--	OR target.CheckedBySecondID  <> source.CheckedBySecondID
					--	OR target.Method             <> source.Method
					--	OR target.Range              <> source.Range
					--	OR target.Result             <> source.Result
					--	OR target.Price              <> source.Price
					--	OR target.Remarks            <> source.Remarks
					--	OR target.AttachmentLink     <> source.AttachmentLink
					--	OR target.SubTestRange       <> source.SubTestRange
					--	OR target.SubTestUnits       <> source.SubTestUnits
					--	OR target.SubTestActive      <> source.SubTestActive
					--	OR target.SubTestResult      <> source.SubTestResult
					--	OR target.Note               <> source.Note
					--	OR target.SubTest            <> source.SubTest
					--	OR target.SubMethod          <> source.SubMethod
					--	OR target.ResultDate         <> source.ResultDate
					--	OR target.ReportDate		 <> source.ReportDate
					--	OR target.IsReportDone		 <> source.IsReportDone
					--	OR target.IsExecutive		 <> source.IsExecutive
					--	OR target.IsReportTaken		 <> source.IsReportTaken
					--	OR target.IsPartiallyDone	 <> source.IsPartiallyDone
					--	OR target.SyncStatus		 <> source.SyncStatus
					--)
					THEN
					UPDATE
					SET
						target.MemberCode			= source.MemberCode  
						, target.MobileNo           = source.MobileNo
						, target.CheckedByFirstID   = source.CheckedByFirstID
						, target.CheckedBySecondID  = source.CheckedBySecondID
						, target.Method             = source.Method
						, target.Range              = source.Range
						, target.Result             = source.Result
						, target.Price              = source.Price
						, target.Remarks            = source.Remarks
						, target.AttachmentLink     = source.AttachmentLink
						, target.UpdateTs           = source.UpdateTs
						, target.SubTestRange       = source.SubTestRange
						, target.SubTestUnits       = source.SubTestUnits
						, target.SubTestActive      = source.SubTestActive
						, target.SubTestResult      = source.SubTestResult
						, target.Note               = source.Note
						,target.SubTest             = source.SubTest
						, target.SubMethod          = source.SubMethod
						, target.ResultDate         = source.ResultDate
						, target.ReportDate			= source.ReportDate
						, target.IsReportDone		 = source.IsReportDone
						, target.IsExecutive		 = source.IsExecutive
						, target.IsReportTaken		 = source.IsReportTaken
						, target.IsPartiallyDone	 = source.IsPartiallyDone
						, target.IsSync					=  0
						,target.SyncStatus			= source.SyncStatus
						,target.TestRecordId		= source.TestRecordId
						,target.IsHideOnPrint		= source.IsHideOnPrint
		
					when not matched then
					insert 
					values(
						 source.MemberCode
						,source._PatientID
						,source.MobileNo
						,source.BillID
						,source.CheckedByFirstID
						,source.CheckedBySecondID
						,source.DiagnosisID
						,source.TestID
						,source.Method
						,source.[Range]
						,source.Result
						,source.Price
						,source.Remarks
						,source.AttachmentLink
						,source.CreateTs
						,source.UpdateTs
						,source.SubTest
						,source.SubTestRange
						,source.SubTestUnits
						,source.SubTestActive
						,source.SubTestResult
						,source.Note
						,source.SubMethod
						,source.PanelId
						,source.ResultDate
						,source.ReportDate
						,source.IsReportDone
						,source.IsExecutive
						,source.IsReportTaken
						,source.IsPartiallyDone
						,source.SubTestId
						,source._OrigSubTestId
						,0
						,source.SyncStatus
						,source.TestRecordId
						,source.IsHideOnPrint
						,@fiscalyear
					);
	
		update dbo.Int_PatientBillReport set IsFactLoaded=1 where PatId in (select PatId from #tempfactpatient);
		update dbo.Int_PatientReportDetails set IsFactLoaded=1 where PatId in (select PatId from #tempfactpatient);

	COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
	END CATCH
	
	drop table #tempfactpatient;
end


