USE [Stag_Carelab_Ban]
GO
/****** Object:  StoredProcedure [Sync].[SyncFactBranchPatientDiagnosis]    Script Date: 7/12/2019 4:57:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [Sync].[SyncFactBranchPatientDiagnosis]
	@fiscalyear varchar(10) = '2075-76'
as
begin

	create table #tempfactpatient(PatId INT DEFAULT 0 );

	BEGIN TRANSACTION
		BEGIN TRY
			Insert into #tempfactpatient
			select distinct ipbr.PatId from dbo.Int_BranchPatientBillReport ipbr;

					Merge dbo.FactBranchPatientDiagnosis as target
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
							--,iprd.IsHideOnPrint
					from dbo.Int_BranchPatientBillReport ipbr
					 join dbo.Int_BranchPatientReportDetails iprd on iprd.PatId=ipbr.PatId --and iprd.ReportDate=ipbr.ReportDate
					 join dbo.BranchPatientMaster pm on pm.ID=ipbr.PatId
					) as source
					on target.PatientID				  = source._PatientID
						and target.BillID             = source.BillID
						and target.DiagnosisID        = source.DiagnosisID
						and target.TestID             = source.TestID
						and target._OrigSubTestId     = source._OrigSubTestId
						and target.PanelId			  = source.PanelId
						and target.fiscalyear = @fiscalyear

						when matched 
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
						--,target.IsHideOnPrint		= source.IsHideOnPrint
		
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
						,source.ResultDate
						,source.ReportDate
						,source.IsReportDone
						,source.IsExecutive
						,source.IsReportTaken
						,source.IsPartiallyDone
						,source.SubTestId
						,source._OrigSubTestId
						,source.PanelId
						,0
						,source.SyncStatus
						,0
						,source.TestRecordId
						--,source.IsHideOnPrint
						,@fiscalyear
					);
	
		--update dbo.Int_PatientBillReport set IsFactLoaded=1 where PatId in (select PatId from #tempfactpatient);
		--update dbo.Int_PatientReportDetails set IsFactLoaded=1 where PatId in (select PatId from #tempfactpatient);

	COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
	END CATCH
	
	drop table #tempfactpatient;
end


