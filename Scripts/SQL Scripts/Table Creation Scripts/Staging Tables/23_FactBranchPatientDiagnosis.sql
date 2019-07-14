USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[FactBranchPatientDiagnosis]    Script Date: 7/8/2019 3:08:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FactBranchPatientDiagnosis](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MemberCode] [varchar](50) NULL,
	[PatientID] [int] NULL,
	[MobileNo] [varchar](20) NULL,
	[BillID] [int] NULL,
	[CheckedByFirstID] [int] NULL,
	[CheckedBySecondID] [int] NULL,
	[DiagnosisID] [int] NULL,
	[TestID] [int] NULL,
	[Method] [varchar](50) NULL,
	[Range] [nvarchar](max) NULL,
	[Result] [varchar](100) NULL,
	[Price] [varchar](20) NULL,
	[Remarks] [nvarchar](2000) NULL,
	[AttachmentLink] [varchar](200) NULL,
	[CreateTs] [datetime] NULL,
	[UpdateTs] [datetime] NULL,
	[SubTest] [nvarchar](150) NULL,
	[SubTestRange] [nvarchar](max) NULL,
	[SubTestUnits] [nvarchar](max) NULL,
	[SubTestActive] [int] NULL,
	[SubTestResult] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[SubMethod] [nvarchar](max) NULL,
	[ResultDate] [varchar](100) NULL,
	[ReportDate] [varchar](100) NULL,
	[IsReportDone] [bit] NULL,
	[IsExecutive] [bit] NULL,
	[IsReportTaken] [bit] NULL,
	[IsPartiallyDone] [bit] NULL,
	[SubTestId] [int] NULL,
	[_OrigSubTestId] [int] NULL,
	[PanelId] [int] NULL,
	[_OrigPanelId] [int] NULL,
	[SyncStatus] [bit] NULL,
	[IsSync] [int] NOT NULL,
	[TestRecordId] [int] NULL,
	[fiscalyear] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[FactBranchPatientDiagnosis] ADD  DEFAULT ((0)) FOR [IsSync]
GO



