-- Index creating scripts----

-- Staging

-- 1. PatientMaster
USE [Stag_Carelab_Ban]
GO

/****** Object:  Index [PK__PatientM__3214EC27F49B6F95]    Script Date: 7/13/2019 12:26:17 PM ******/
ALTER TABLE [dbo].[PatientMaster] DROP CONSTRAINT [PK__PatientM__3214EC27F49B6F95] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [PK__PatientM__3214EC27F49B6F95]    Script Date: 7/13/2019 12:26:17 PM ******/
ALTER TABLE [dbo].[PatientMaster] ADD PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



 2. TestMaster
 SET ANSI_PADDING ON
GO

/****** Object:  Index [NonClusteredIndex-20190711-172408]    Script Date: 7/14/2019 5:53:36 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190711-172408] ON [dbo].[TestMaster]
(
	[fiscalyear] ASC
)
INCLUDE ( 	[_TestIDOrig],
	[TestCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

3. SubTestMaster
SET ANSI_PADDING ON
GO

/****** Object:  Index [NonClusteredIndex-20190623-002659]    Script Date: 7/14/2019 5:55:13 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190623-002659] ON [dbo].[SubTestMaster]
(
	[_SubTestIdOrig] ASC
)
INCLUDE ( 	[SubTestName],
	[SubTestGroup],
	[SubTestRange],
	[SubTestUnits],
	[ParentSubTestId],
	[ParentSubTest],
	[IsActive],
	[_OrigTestId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

4. MemberMaster
/****** Object:  Index [NonClusteredIndex-20190624-005846]    Script Date: 7/14/2019 5:57:19 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190624-005846] ON [dbo].[MemberMaster]
(
	[PatId] ASC
)
INCLUDE ( 	[MemberCode],
	[FirstName],
	[MidName],
	[LastName],
	[FullName],
	[Dob],
	[Gender],
	[Address1],
	[Address2],
	[Address3],
	[ContactNo],
	[EmailId],
	[IdentityID],
	[IdentityType],
	[Salutation],
	[ContactNo2],
	[ContactNo3],
	[CrdtPrtyId],
	[IsActive]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

5. MasterSpecialist

/****** Object:  Index [NonClusteredIndex-20190624-010715]    Script Date: 7/14/2019 5:59:18 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190624-010715] ON [dbo].[MasterSpecialist]
(
	[_SpecialistIdOrig] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

6. PanelMaster


/****** Object:  Index [NonClusteredIndex-20190624-011917]    Script Date: 7/14/2019 6:02:52 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190624-011917] ON [dbo].[PanelMaster]
(
	[_OrigPanelId] ASC
)
INCLUDE ( 	[PanelName],
	[PanelType],
	[Specimen],
	[DiagnosisGroup],
	[DiagnosisId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

7. PatientHistoMaster

/****** Object:  Index [NonClusteredIndex-20190624-013926]    Script Date: 7/14/2019 6:05:19 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190624-013926] ON [dbo].[PatientHistoMaster]
(
	[_OrigPatId] ASC,
	[HistoTestId] ASC
)
INCLUDE ( 	[CheckedByFirstId],
	[CheckedByFirstName],
	[CheckedByFirstDesignation],
	[CheckedByFirstRegNo],
	[CheckedBySecondId],
	[CheckedBySecondName],
	[CheckedBySecondDesignation],
	[CheckedBySecondRegNo],
	[ReportDate],
	[IsFinished],
	[HistoTestTypeId],
	[HistoTestType],
	[IsTaken],
	[UserId],
	[UserName],
	[ReportTakenBy],
	[HistoCode],
	[ResultDate],
	[ReportNepaliDate],
	[Note]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


8. LoginMaster

/****** Object:  Index [NonClusteredIndex-20190710-060850]    Script Date: 7/14/2019 6:06:11 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190710-060850] ON [dbo].[LoginMaster]
(
	[LoginType] ASC,
	[LoginTypeID] ASC,
	[LoginID] ASC,
	[_OrigId] ASC,
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


9. DiagnosisMaster

/****** Object:  Index [NonClusteredIndex-20190623-000303]    Script Date: 7/14/2019 6:07:20 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190623-000303] ON [dbo].[DiagnosisMaster]
(
	[_DiagnosisIDOrig] ASC,
	[DiagnosisName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

10. RequestorMaster
/****** Object:  Index [NonClusteredIndex-20190624-004651]    Script Date: 7/14/2019 6:09:07 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190624-004651] ON [dbo].[RequestorMaster]
(
	[_OrigRequestorId] ASC
)
INCLUDE ( 	[RequestorName],
	[ReqIsActive],
	[ReqReqId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


11. BillMaster

/****** Object:  Index [NonClusteredIndex-20190710-061137]    Script Date: 7/14/2019 6:11:09 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190710-061137] ON [dbo].[BillMaster]
(
	[BillNo] ASC,
	[_PatientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


12. BillLoginMaster
/****** Object:  Index [NonClusteredIndex-20190626-000049]    Script Date: 7/13/2019 12:24:46 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190626-000049] ON [dbo].[BillLoginMaster]
(
	[_PatientID] ASC,
	[BillLogin] ASC
)
INCLUDE ( 	[BillPassword],
	[IsActive],
	[IsMemberMapped],
	[IsDocSharable]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



13. BranchPatientHistoMaster

/****** Object:  Index [NonClusteredIndex-20190711-190930]    Script Date: 7/14/2019 6:15:24 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190711-190930] ON [dbo].[BranchPatientHistoMaster]
(
	[_OrigPatId] ASC,
	[HistoTestId] ASC,
	[fiscalyear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

14. BranchPatientMaster

/****** Object:  Index [NonClusteredIndex-20190712-043402]    Script Date: 7/14/2019 6:17:03 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190712-043402] ON [dbo].[BranchPatientMaster]
(
	[MainPatID] ASC,
	[fiscalyear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

15. Int_BranchPatientBillReport
/****** Object:  Index [NonClusteredIndex-20190712-051005]    Script Date: 7/14/2019 6:18:02 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190712-051005] ON [dbo].[Int_BranchPatientBillReport]
(
	[_OrigPatId] ASC,
	[_OrigBillId] ASC,
	[BillNo] ASC,
	[fiscalyear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
16. 