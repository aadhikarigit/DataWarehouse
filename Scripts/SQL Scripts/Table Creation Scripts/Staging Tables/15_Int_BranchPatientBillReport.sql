USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[Int_BranchPatientBillReport]    Script Date: 7/8/2019 3:11:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Int_BranchPatientBillReport](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PatId] [int] NULL,
	[_OrigPatId] [int] NULL,
	[MemberCode] [varchar](20) NULL,
	[BillId] [int] NULL,
	[_OrigBillId] [int] NULL,
	[BillNo] [nvarchar](12) NULL,
	[BillDate] [varchar](10) NULL,
	[ReportDate] [varchar](10) NULL,
	[EnteredBy] [varchar](50) NULL,
	[SpecialistId] [int] NULL,
	[SecondSpecialistId] [int] NULL,
	[IsReportTaken] [char](1) NULL,
	[IsDone] [char](1) NULL,
	[IsPartiallyDone] [char](1) NULL,
	[BillPriceFinal] [money] NULL,
	[RequestorId] [int] NULL,
	[ResultDate] [varchar](100) NULL,
	[IsSync] [int] NOT NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Int_BranchPatientBillReport] ADD  DEFAULT ((0)) FOR [IsSync]
GO
