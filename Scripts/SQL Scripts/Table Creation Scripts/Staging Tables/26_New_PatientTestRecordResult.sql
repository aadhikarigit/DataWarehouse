USE [Stag_Carelab_Ban]
GO

/****** Object:  Table [dbo].[New_PatientTestRecordResult]    Script Date: 7/8/2019 3:14:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[New_PatientTestRecordResult](
	[patrecordid] [int] NOT NULL,
	[PatId] [int] NOT NULL,
	[IndividualTestId] [int] NOT NULL,
	[TestPanId] [int] NOT NULL,
	[TestResult] [nvarchar](50) NULL,
	[CheckedBy] [int] NOT NULL,
	[CheckedBySecond] [int] NULL,
	[ResultDate] [datetime] NOT NULL,
	[Nrl_Reg_No] [nvarchar](50) NOT NULL,
	[patuserid] [int] NULL,
	[IsExecutive] [bit] NULL,
	[IstakenByPatient] [bit] NULL,
	[IsReportDone] [bit] NULL,
	[ReportTakenBy] [nvarchar](155) NULL,
	[patnote] [nvarchar](max) NULL,
	[TestRange] [nvarchar](max) NULL,
	[IspartiallyDone] [bit] NULL,
	[patrechideonprint] [bit] NULL,
	[ReportedNepaliDate] [varchar](15) NULL,
	[IsSync] [bit] NOT NULL,
	[CheckedByThird] [int] NOT NULL,
	[Abnormality] [int] NULL,
	[ttrfrid] [int] NULL,
	[ttrfrtestid] [int] NULL,
	[SubTestId] [int] NULL,
	[Result] [nvarchar](max) NULL,
	[Range] [nvarchar](155) NULL,
	[Method] [nvarchar](155) NULL,
	[ttfrabnormality] [int] NULL,
	[IsHideOnPrint] [bit] NULL,
	[Note] [nvarchar](256) NULL,
	[testresultdate] [datetime] NULL,
	[UserId] [int] NULL,
	[intestid] [int] NOT NULL,
	[intestdgid] [int] NOT NULL,
	[TestId] [int] NOT NULL,
	[SubGroupId] [int] NOT NULL,
	[IsDifferentialCount] [bit] NULL,
	[SubDiagnosis] [nvarchar](20) NULL,
	[IsActive] [int] NOT NULL,
	[intestissync] [bit] NOT NULL,
	[ranid] [int] NULL,
	[DGId] [int] NULL,
	[Min] [nvarchar](max) NULL,
	[Max] [nvarchar](max) NULL,
	[Group] [nvarchar](30) NULL,
	[SubGroup] [nvarchar](25) NULL,
	[Date] [datetime] NULL,
	[fiscalyear] [varchar](10) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO